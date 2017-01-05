//
//  RCTConvert+TwilioAccessManager.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTConvert+TwilioIPMessagingClient.h"
#import "RCTUtils.h"

@implementation RCTConvert (TwilioIPMessagingClient)

RCT_ENUM_CONVERTER(TWMClientSynchronizationStatus,(@{
                                                      @"Started" : @(TWMClientSynchronizationStatusStarted),
                                                      @"ChannelsListCompleted" : @(TWMClientSynchronizationStatusChannelsListCompleted),
                                                      @"Completed" : @(TWMClientSynchronizationStatusCompleted),
                                                      @"Failed" : @(TWMClientSynchronizationStatusFailed),
                                                      }), TWMClientSynchronizationStatusStarted, integerValue)


RCT_ENUM_CONVERTER(TWMChannelSynchronizationStatus,(@{
                                                      @"None" : @(TWMChannelSynchronizationStatusNone),
                                                      @"Identifier" : @(TWMChannelSynchronizationStatusIdentifier),
                                                      @"Metadata" : @(TWMChannelSynchronizationStatusMetadata),
                                                      @"All" : @(TWMChannelSynchronizationStatusAll),
                                                      @"Failed" : @(TWMChannelSynchronizationStatusFailed),
                                                      }), TWMChannelSynchronizationStatusNone, integerValue)

RCT_ENUM_CONVERTER(TWMChannelStatus,(@{
                                       @"Invited" : @(TWMChannelStatusInvited),
                                       @"Joined" : @(TWMChannelStatusJoined),
                                       @"NotParticipating" : @(TWMChannelStatusNotParticipating),
                                      }), TWMChannelStatusInvited, integerValue)

RCT_ENUM_CONVERTER(TWMChannelType,(@{
                                     @"Public" : @(TWMChannelTypePublic),
                                     @"Private" : @(TWMChannelTypePrivate),
                                     }), TWMChannelTypePublic, integerValue)

RCT_ENUM_CONVERTER(TWMUserInfoUpdate,(@{
                                        @"FriendlyName" : @(TWMUserInfoUpdateFriendlyName),
                                        @"Attributes" : @(TWMUserInfoUpdateAttributes),
                                        @"ReachabilityOnline": @(TWMUserInfoUpdateReachabilityOnline),
                                        @"ReachabilityNotifiable": @(TWMUserInfoUpdateReachabilityNotifiable),
                                        }), TWMUserInfoUpdateFriendlyName, integerValue)

RCT_ENUM_CONVERTER(TWMClientSynchronizationStrategy,(@{
                                                       @"All" : @(TWMClientSynchronizationStrategyAll),
                                                       @"ChannelsList" : @(TWMClientSynchronizationStrategyChannelsList),
                                                       }), TWMClientSynchronizationStrategyAll, integerValue)

RCT_ENUM_CONVERTER(TWMLogLevel,(@{
                                  @"Fatal" : @(TWMLogLevelFatal),
                                  @"Critical" : @(TWMLogLevelCritical),
                                  @"Warning" : @(TWMLogLevelWarning),
                                  @"Info" : @(TWMLogLevelInfo),
                                  @"Debug" : @(TWMLogLevelDebug),
                                }), TWMLogLevelFatal, integerValue)


+ (NSDictionary *)TwilioAccessManager:(TwilioAccessManager *)accessManager {
  if (!accessManager) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": accessManager.identity,
           @"token": accessManager.token,
           @"isExpired": @(accessManager.isExpired),
           @"expirationDate": @(accessManager.expirationDate.timeIntervalSince1970 * 1000)
           };
}

+ (NSDictionary *)TwilioIPMessagingClient:(TwilioIPMessagingClient *)client {
  if (!client) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"userInfo": [self TWMUserInfo:client.userInfo],
           @"synchronizationStatus": @(client.synchronizationStatus),
           @"version": client.version,
           @"isReachabilityEnabled": @(client.isReachabilityEnabled)
           };
}


+ (NSDictionary *)TWMUserInfo:(TWMUserInfo *)userInfo {
  if (!userInfo) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": userInfo.identity,
           @"friendlyName": userInfo.friendlyName,
           @"attributes": RCTNullIfNil(userInfo.attributes),
           @"isOnline": @(userInfo.isOnline),
           @"isNotifiable": @(userInfo.isNotifiable)
           };
}

+ (NSDictionary *)TWMMessage:(TWMMessage *)message {
  if (!message) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"sid": message.sid,
           @"index": message.index,
           @"author": message.author,
           @"body": message.body,
           @"timestamp": message.timestamp,
           @"timestampAsDate": @(message.timestampAsDate.timeIntervalSince1970 * 1000),
           @"dateUpdated": message.dateUpdated,
           @"dateUpdatedDate": @(message.dateUpdatedAsDate.timeIntervalSince1970 * 1000),
           @"lastUpdatedBy": message.lastUpdatedBy,
           @"attributes": RCTNullIfNil(message.attributes)
           };
}

+ (NSDictionary *)TWMMember:(TWMMember *)member {
  if (!member) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"userInfo": [RCTConvert TWMUserInfo:member.userInfo],
           @"lastConsumedMessageIndex": RCTNullIfNil(member.lastConsumedMessageIndex),
           @"lastConsumptionTimestamp": RCTNullIfNil(member.lastConsumptionTimestamp)
           };
}

+ (NSDictionary *)TWMChannel:(TWMChannel *)channel {
  if (!channel) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"sid": channel.sid,
           @"friendlyName": channel.friendlyName,
           @"uniqueName": channel.uniqueName,
           @"status": @(channel.status),
           @"type": @(channel.type),
           @"attributes": RCTNullIfNil(channel.attributes),
           @"synchronizationStatus": @(channel.synchronizationStatus),
           @"dateCreated": channel.dateCreated,
           @"dateUpdated": channel.dateUpdated
           };
}

+ (NSArray *)TWMMembers:(NSArray<TWMMember *>*)members {
  if (!members) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TWMMember *member in members) {
    [response addObject:[self TWMMember:member]];
  }
  return response;
}

+ (NSArray *)TWMMessages:(NSArray<TWMMessage *> *)messages {
  if (!messages) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TWMMessage *message in messages) {
    [response addObject:[self TWMMessage:message]];
  }
  return response;
}

+ (NSData *)dataWithHexString:(NSString *)hex {
  // Source:  https://opensource.apple.com/source/Security/Security-55471.14.18/libsecurity_transform/NSData+HexString.m
  char buf[3];
  buf[2] = '\0';
  NSAssert(0 == [hex length] % 2, @"Hex strings should have an even number of digits (%@)", hex);
  unsigned char *bytes = malloc([hex length]/2);
  unsigned char *bp = bytes;
  for (CFIndex i = 0; i < [hex length]; i += 2) {
      buf[0] = [hex characterAtIndex:i];
      buf[1] = [hex characterAtIndex:i+1];
      char *b2 = NULL;
      *bp++ = strtol(buf, &b2, 16);
      NSAssert(b2 == buf + 2, @"String should be all hex digits: %@ (bad digit around %d)", hex, i);
  }

  return [NSData dataWithBytesNoCopy:bytes length:[hex length]/2 freeWhenDone:YES];
}


@end
