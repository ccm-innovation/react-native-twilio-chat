//
//  RCTConvert+TwilioAccessManager.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTConvert+TwilioIPMessagingClient.h"
#import <RCTUtils.h>

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
           @"version": client.version
           };
}


+ (NSDictionary *)TWMUserInfo:(TWMUserInfo *)userInfo {
  if (!userInfo) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": userInfo.identity,
           @"friendlyName": userInfo.friendlyName,
           @"attributes": RCTNullIfNil(userInfo.attributes)
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
           @"lastUpdatedBy": message.lastUpdatedBy
           };
}

+ (NSDictionary *)TWMMember:(TWMMember *)member {
  if (!member) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"userInfo": [RCTConvert TWMUserInfo:member.userInfo]
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
           @"synchronizationStatus": @(channel.synchronizationStatus)
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


@end