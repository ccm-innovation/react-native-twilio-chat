//
//  RCTTwilioChatClient.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioChatClient.h"
#import "RCTTwilioAccessManager.h"
#import <React/RCTEventDispatcher.h>
#import "RCTConvert+TwilioChatClient.h"
#import <React/RCTUtils.h>

@interface RCTTwilioChatClient() <TwilioChatClientDelegate>
@end

@implementation RCTTwilioChatClient

@synthesize bridge = _bridge;
@synthesize client;

#pragma mark Singleton Methods

+ (id)sharedManager {
  static RCTTwilioChatClient *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(createClient, token:(NSString*)token properties:(NSDictionary *)properties resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    TwilioChatClientProperties *props = nil;
    if (properties.count > 0) {
      props = [[TwilioChatClientProperties alloc] init];
      if (properties[@"region"]) {
        props.region = [RCTConvert NSString:properties[@"region"]];
      }
    }
    [TwilioChatClient chatClientWithToken:token properties:props delegate:self completion:^(TCHResult *result, TwilioChatClient *chatClient) {
      if (!result.isSuccessful) {
        reject(@"create-client-error", @"Error occurred while attempting to create the [client. Error Message:", result.error);
        return;
      }
      RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
      _client.client = chatClient;
      resolve([RCTConvert TwilioChatClient:_client.client]);
    }];
}

RCT_EXPORT_METHOD(updateToken:(NSString *)token) {
    RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
    [[_client client] updateToken:token completion:^(TCHResult *result) {
      if (result.isSuccessful) {
        NSLog(@"Client token updated");
      }
      else {
        NSLog(@"Client token update failed: %@", result.error.localizedDescription);
      }
    }];
}

RCT_REMAP_METHOD(user, userInfo_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  resolve([RCTConvert TCHUser:_client.client.user]);
}

RCT_EXPORT_METHOD(synchronizationStatus:(RCTResponseSenderBlock)callback) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  callback(@[@(_client.client.synchronizationStatus)]);
}

RCT_EXPORT_METHOD(version:(RCTResponseSenderBlock)callback) {
  callback(@[client.version]);
}

RCT_EXPORT_METHOD(register:(NSString *)token) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  [[_client client] registerWithNotificationToken:[RCTConvert dataWithHexString:token] completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      NSLog(@"Notification token registered");
    }
    else {
      NSLog(@"Notification token registration failed: %@", result.error.localizedDescription);
    }
  }];
}

RCT_EXPORT_METHOD(unregister:(NSString *)token) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  [[_client client] deregisterWithNotificationToken:[RCTConvert dataWithHexString:token] completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      NSLog(@"Notification token deregistered");
    }
    else {
      NSLog(@"Notification token deregistration failed: %@", result.error.localizedDescription);
    }
  }];
}

RCT_EXPORT_METHOD(handleNotification:(NSDictionary *)notification) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  [[_client client] handleNotification:notification completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      NSLog(@"Notification handled successfully");
    }
    else {
      NSLog(@"Notification handling failed: %@", result.error.localizedDescription);
    }
  }];
}

RCT_EXPORT_METHOD(shutdown) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  [[_client client] shutdown];
}

RCT_EXPORT_METHOD(setLogLevel:(TCHLogLevel)logLevel) {
  [TwilioChatClient setLogLevel:logLevel];
}

RCT_EXPORT_METHOD(logLevel:(TCHLogLevel)logLevel callback:(RCTResponseSenderBlock)callback) {
  callback(@[@(TwilioChatClient.logLevel)]);
}

RCT_REMAP_METHOD(setFriendlyName, friendlyName:(NSString *)friendlyName friendlyName_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  [[[_client client] user] setFriendlyName:friendlyName completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-friendly-name-error", @"Error occured while attempting to set friendly name for the user.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(setAttributes, attributes:(NSDictionary *)attributes attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
  [[[_client client] user] setAttributes:attributes completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-attributes-error", @"Error occured while attempting to set attributes for the user.", result.error);
    }
  }];
}

#pragma mark Twilio IP Messaging Client Delegates

- (void)chatClient:(TwilioChatClient *)client connectionStateChanged:(TCHClientConnectionState)state {
    [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:connectionStateChanged"
                                                 body:@(state)];
}

- (void)chatClient:(TwilioChatClient *)client synchronizationStatusUpdated:(TCHClientSynchronizationStatus)status {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:synchronizationStatusUpdated"
                                               body:@(status)];
}

- (void)chatClient:(TwilioChatClient *)client channelAdded:(TCHChannel *)channel {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channelAdded"
                                               body: [RCTConvert TCHChannel:channel]];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel updated:(TCHChannelUpdate)updated {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:updated"
                                               body:[RCTConvert TCHChannel:channel]];
}

- (void)chatClient:(TwilioChatClient *)client channelDeleted:(TCHChannel *)channel {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channelDeleted"
                                               body: [RCTConvert TCHChannel:channel]];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel synchronizationStatusChanged:(TCHChannelSynchronizationStatus)status {
  NSString *channelSid;
  if (channel) {
    channelSid = channel.sid;
  }
  else {
    channelSid = RCTNullIfNil(nil);
  }
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:synchronizationStatusChanged"
                                               body: @{
                                                       @"channelSid": channelSid,
                                                       @"status": @(status)
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberJoined:(TCHMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:memberJoined"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TCHMember:member]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel memberLeft:(TCHMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:memberLeft"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TCHMember:member]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageAdded:(TCHMessage *)message {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:messageAdded"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"message": [RCTConvert TCHMessage:message]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel message:(TCHMessage *)message updated:(TCHMessageUpdate)updated {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:messageChanged"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"message": [RCTConvert TCHMessage:message]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageDeleted:(TCHMessage *)message {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:messageDeleted"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"message": [RCTConvert TCHMessage:message]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client errorReceived:(TCHError *)error {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:errorReceived"
                                               body:@{@"error": [error localizedDescription],
                                                      @"userInfo": [error userInfo]
                                                      }];
}

- (void)chatClient:(TwilioChatClient *)client typingStartedOnChannel:(TCHChannel *)channel member:(TCHMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:typingStartedOnChannel"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TCHMember:member]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client typingEndedOnChannel:(TCHChannel *)channel member:(TCHMember *)member {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:typingEndedOnChannel"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"member": [RCTConvert TCHMember:member]
                                                       }];
}

- (void)chatClientToastSubscribed:(TwilioChatClient *)client {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:toastSubscribed"
                                               body: RCTNullIfNil(nil)];
}

- (void)chatClient:(TwilioChatClient *)client toastReceivedOnChannel:(TCHChannel *)channel message:(TCHMessage *)message {
    [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:toastReceivedOnChannel"
                                               body: @{
                                                       @"channelSid": channel.sid,
                                                       @"messageSid": message.sid
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client toastRegistrationFailedWithError:(TCHError *)error {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:toastFailed"
                                               body:@{@"error": [error localizedDescription],
                                                      @"userInfo": @""
                                                      }];
}

- (void)chatClient:(TwilioChatClient *)client user:(TCHUser *)user updated:(TCHUserUpdate)updated {
  [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:userUpdated"
                                               body: @{@"updated": @(updated),
                                                       @"user": [RCTConvert TCHUser:user]
                                                       }];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel member:(TCHMember *)member updated:(TCHMemberUpdate)updated {
  [member userDescriptorWithCompletion:^(TCHResult *result, TCHUserDescriptor *user) {
    [self.bridge.eventDispatcher sendAppEventWithName:@"chatClient:channel:member:userUpdated"
                                                 body: @{@"channelSid": channel.sid,
                                                         @"updated": @(updated),
                                                         @"userDescriptor": [RCTConvert TCHUserDescriptor:user]
                                                         }];
  }];

}

#pragma mark Enums

- (NSDictionary *)constantsToExport
{
  return @{ @"Constants": @{
                @"TCHClientSynchronizationStatus": @{
                    @"Started" : @(TCHClientSynchronizationStatusStarted),
                    @"ChannelsListCompleted" : @(TCHClientSynchronizationStatusChannelsListCompleted),
                    @"Completed" : @(TCHClientSynchronizationStatusCompleted),
                    @"Failed" : @(TCHClientSynchronizationStatusFailed)
                    },
                @"TCHChannelSynchronizationStatus": @{
                    @"None" : @(TCHChannelSynchronizationStatusNone),
                    @"Identifier" : @(TCHChannelSynchronizationStatusIdentifier),
                    @"Metadata" : @(TCHChannelSynchronizationStatusMetadata),
                    @"All" : @(TCHChannelSynchronizationStatusAll),
                    @"Failed" : @(TCHChannelSynchronizationStatusFailed)
                    },
                @"TCHChannelStatus": @{
                    @"Invited": @(TCHChannelStatusInvited),
                    @"Joined": @(TCHChannelStatusJoined),
                    @"NotParticipating": @(TCHChannelStatusNotParticipating)
                    },
                @"TCHChannelType": @{
                    @"Public": @(TCHChannelTypePublic),
                    @"Private": @(TCHChannelTypePrivate)
                    },
                @"TCHUserInfoUpdate": @{
                    @"FriendlyName": @(TCHUserUpdateFriendlyName),
                    @"Attributes": @(TCHUserUpdateAttributes),
                    @"ReachabilityOnline": @(TCHUserUpdateReachabilityOnline),
                    @"ReachabilityNotifiable": @(TCHUserUpdateReachabilityNotifiable)
                    },
                @"TCHLogLevel": @{
                    @"Fatal" : @(TCHLogLevelFatal),
                    @"Critical" : @(TCHLogLevelCritical),
                    @"Warning" : @(TCHLogLevelWarning),
                    @"Info" : @(TCHLogLevelInfo),
                    @"Debug" : @(TCHLogLevelDebug)
                    },
                @"TCHChannelOption": @{
                        @"FriendlyName" : TCHChannelOptionFriendlyName,
                        @"UniqueName" : TCHChannelOptionUniqueName,
                        @"Type" : TCHChannelOptionType,
                        @"Attributes" : TCHChannelOptionAttributes
                        },
                @"TCHClientConnectionState": @{
                        @"Unknown" : @(TCHClientConnectionStateUnknown),
                        @"Disconnected" : @(TCHClientConnectionStateDisconnected),
                        @"Connected" : @(TCHClientConnectionStateConnected),
                        @"Connecting" : @(TCHClientConnectionStateConnecting),
                        @"Denied" : @(TCHClientConnectionStateDenied),
                        @"Error" : @(TCHClientConnectionStateError)
                        }
                }
            };
};


@end
