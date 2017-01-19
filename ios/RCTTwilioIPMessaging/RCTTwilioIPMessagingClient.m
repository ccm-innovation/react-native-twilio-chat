//
//  RCTTwilioIPMessagingClient.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioIPMessagingClient.h"
#import "RCTTwilioAccessManager.h"
#import "RCTEventDispatcher.h"
#import "RCTConvert+TwilioIPMessagingClient.h"
#import "RCTUtils.h"

@interface RCTTwilioIPMessagingClient() <TwilioIPMessagingClientDelegate>
@end

@implementation RCTTwilioIPMessagingClient

@synthesize bridge = _bridge;
@synthesize client;

#pragma mark Singleton Methods

+ (id)sharedManager {
  static RCTTwilioIPMessagingClient *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(createClient, properties:(NSDictionary *)properties resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  TwilioAccessManager *accessManager = [[RCTTwilioAccessManager sharedManager] accessManager];
  // TODO add check to see if AccessManager has been initialized or not
  TwilioIPMessagingClientProperties *props = nil;
  if (properties.count > 0) {
    props = [[TwilioIPMessagingClientProperties alloc] init];
    props.synchronizationStrategy = [RCTConvert TWMClientSynchronizationStrategy:properties[@"synchronizationStrategy"]];
    props.initialMessageCount = [RCTConvert NSUInteger:properties[@"initialMessageCount"]];
  }
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  _client.client = [TwilioIPMessagingClient ipMessagingClientWithAccessManager:accessManager properties:props delegate:self];
  resolve([RCTConvert TwilioIPMessagingClient:_client.client]);
}

RCT_REMAP_METHOD(userInfo, userInfo_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  resolve([RCTConvert TWMUserInfo:_client.client.userInfo]);
}

RCT_EXPORT_METHOD(synchronizationStatus:(RCTResponseSenderBlock)callback) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  callback(@[@(_client.client.synchronizationStatus)]);
}

RCT_EXPORT_METHOD(version:(RCTResponseSenderBlock)callback) {
  callback(@[client.version]);
}

RCT_EXPORT_METHOD(register:(NSString *)token) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  [[_client client] registerWithToken:[RCTConvert dataWithHexString:token]];
}

RCT_EXPORT_METHOD(unregister:(NSString *)token) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  [[_client client] deregisterWithToken:[RCTConvert dataWithHexString:token]];
}

RCT_EXPORT_METHOD(handleNotification:(NSDictionary *)notification) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  [[_client client] handleNotification:notification];
}

RCT_EXPORT_METHOD(shutdown) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  [[_client client] shutdown];
}

RCT_EXPORT_METHOD(setLogLevel:(TWMLogLevel)logLevel) {
  [TwilioIPMessagingClient setLogLevel:logLevel];
}

RCT_EXPORT_METHOD(logLevel:(TWMLogLevel)logLevel callback:(RCTResponseSenderBlock)callback) {
  callback(@[@(TwilioIPMessagingClient.logLevel)]);
}

RCT_REMAP_METHOD(setFriendlyName, friendlyName:(NSString *)friendlyName friendlyName_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  [[[_client client]userInfo] setFriendlyName:friendlyName completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-friendly-name-error", @"Error occured while attempting to set friendly name for the user.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(setAttributes, attributes:(NSDictionary *)attributes attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioIPMessagingClient *_client = [RCTTwilioIPMessagingClient sharedManager];
  [[[_client client]userInfo] setAttributes:attributes completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-attributes-error", @"Error occured while attempting to set attributes for the user.", result.error);
    }  
  }];
}

#pragma mark Twilio IP Messaging Client Delegates

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client synchronizationStatusChanged:(TWMClientSynchronizationStatus)status {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:synchronizationStatusChanged"
                                               body:@(status)];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channelAdded:(TWMChannel *)channel {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channelAdded"
                                               body: [RCTConvert TWMChannel:channel]];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channelChanged:(TWMChannel *)channel {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channelChanged"
                                               body: [RCTConvert TWMChannel:channel]];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channelDeleted:(TWMChannel *)channel {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channelRemoved"
                                               body: [RCTConvert TWMChannel:channel]];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel synchronizationStatusChanged:(TWMChannelSynchronizationStatus)status {
  NSString *channelSid;
  if (channel) {
    channelSid = channel.sid;
  }
  else {
    channelSid = RCTNullIfNil(nil);
  }
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:synchronizationStatusChanged"
                                               body: @{
                                                       @"channelSid": channelSid,
                                                       @"status": @(status)
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel memberJoined:(TWMMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:memberJoined"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TWMMember:member]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel memberChanged:(TWMMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:memberChanged"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TWMMember:member]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel memberLeft:(TWMMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:memberLeft"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TWMMember:member]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel messageAdded:(TWMMessage *)message {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:messageAdded"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"message": [RCTConvert TWMMessage:message]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel messageChanged:(TWMMessage *)message {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:messageChanged"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"message": [RCTConvert TWMMessage:message]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel messageDeleted:(TWMMessage *)message {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:messageDeleted"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"message": [RCTConvert TWMMessage:message]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client errorReceived:(TWMError *)error {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:errorReceived"
                                               body:@{@"error": [error localizedDescription],
                                                      @"userInfo": [error userInfo]
                                                      }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client typingStartedOnChannel:(TWMChannel *)channel member:(TWMMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:typingStartedOnChannel"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TWMMember:member]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client typingEndedOnChannel:(TWMChannel *)channel member:(TWMMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:typingEndedOnChannel"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TWMMember:member]
                                                       }];
}

- (void)ipMessagingClientToastSubscribed:(TwilioIPMessagingClient *)client {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:toastSubscribed"
                                               body: RCTNullIfNil(nil)];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client toastReceivedOnChannel:(TWMChannel *)channel message:(TWMMessage *)message {
    [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:toastReceived"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"messageSid": message.sid
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client toastRegistrationFailedWithError:(TWMError *)error {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:toastFailed"
                                               body:@{@"error": [error localizedDescription],
                                                      @"userInfo": [error userInfo]
                                                      }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client userInfo:(TWMUserInfo *)userInfo updated:(TWMUserInfoUpdate)updated {
  [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:userInfoUpdated"
                                               body: @{@"updated": @(updated),
                                                       @"userInfo": [RCTConvert TWMUserInfo:userInfo]
                                                       }];
}

- (void)ipMessagingClient:(TwilioIPMessagingClient *)client channel:(TWMChannel *)channel member:(TWMMember *)member userInfo:(TWMUserInfo *)userInfo updated:(TWMUserInfoUpdate)updated {
    [self.bridge.eventDispatcher sendAppEventWithName:@"ipMessagingClient:channel:member:userInfoUpdated"
                                                 body: @{@"channelSid": channel.sid,
                                                         @"updated": @(updated),
                                                         @"userInfo": [RCTConvert TWMUserInfo:userInfo]
                                                         }];

}

#pragma mark Enums

- (NSDictionary *)constantsToExport
{
  return @{ @"Constants": @{
                @"TWMClientSynchronizationStatus": @{
                    @"Started" : @(TWMClientSynchronizationStatusStarted),
                    @"ChannelsListCompleted" : @(TWMClientSynchronizationStatusChannelsListCompleted),
                    @"Completed" : @(TWMClientSynchronizationStatusCompleted),
                    @"Failed" : @(TWMClientSynchronizationStatusFailed)
                    },
                @"TWMChannelSynchronizationStatus": @{
                    @"None" : @(TWMChannelSynchronizationStatusNone),
                    @"Identifier" : @(TWMChannelSynchronizationStatusIdentifier),
                    @"Metadata" : @(TWMChannelSynchronizationStatusMetadata),
                    @"All" : @(TWMChannelSynchronizationStatusAll),
                    @"Failed" : @(TWMChannelSynchronizationStatusFailed)
                    },
                @"TWMChannelStatus": @{
                    @"Invited": @(TWMChannelStatusInvited),
                    @"Joined": @(TWMChannelStatusJoined),
                    @"NotParticipating": @(TWMChannelStatusNotParticipating)
                    },
                @"TWMChannelType": @{
                    @"Public": @(TWMChannelTypePublic),
                    @"Private": @(TWMChannelTypePrivate)
                    },
                @"TWMClientSynchronizationStrategy": @{
                    @"All": @(TWMClientSynchronizationStrategyAll),
                    @"ChannelsList": @(TWMClientSynchronizationStrategyChannelsList)
                    },
                @"TWMUserInfoUpdate": @{
                    @"FriendlyName": @(TWMUserInfoUpdateFriendlyName),
                    @"Attributes": @(TWMUserInfoUpdateAttributes),
                    @"ReachabilityOnline": @(TWMUserInfoUpdateReachabilityOnline),
                    @"ReachabilityNotifiable": @(TWMUserInfoUpdateReachabilityNotifiable)
                    },
                @"TWMLogLevel": @{
                    @"Fatal" : @(TWMLogLevelFatal),
                    @"Critical" : @(TWMLogLevelCritical),
                    @"Warning" : @(TWMLogLevelWarning),
                    @"Info" : @(TWMLogLevelInfo),
                    @"Debug" : @(TWMLogLevelDebug)
                    },
                @"TWMChannelOption": @{
                        @"FriendlyName" : TWMChannelOptionFriendlyName,
                        @"UniqueName" : TWMChannelOptionUniqueName,
                        @"Type" : TWMChannelOptionType,
                        @"Attributes" : TWMChannelOptionAttributes
                        }
                }
            };
};


@end
