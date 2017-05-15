//
//  RCTConvert+TwilioChatClient.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTConvert+TwilioChatClient.h"
#import <React/RCTUtils.h>

@implementation RCTConvert (TwilioChatClient)

RCT_ENUM_CONVERTER(TCHClientSynchronizationStatus,(@{
                                                      @"Started" : @(TCHClientSynchronizationStatusStarted),
                                                      @"ChannelsListCompleted" : @(TCHClientSynchronizationStatusChannelsListCompleted),
                                                      @"Completed" : @(TCHClientSynchronizationStatusCompleted),
                                                      @"Failed" : @(TCHClientSynchronizationStatusFailed),
                                                      }), TCHClientSynchronizationStatusStarted, integerValue)


RCT_ENUM_CONVERTER(TCHChannelSynchronizationStatus,(@{
                                                      @"None" : @(TCHChannelSynchronizationStatusNone),
                                                      @"Identifier" : @(TCHChannelSynchronizationStatusIdentifier),
                                                      @"Metadata" : @(TCHChannelSynchronizationStatusMetadata),
                                                      @"All" : @(TCHChannelSynchronizationStatusAll),
                                                      @"Failed" : @(TCHChannelSynchronizationStatusFailed),
                                                      }), TCHChannelSynchronizationStatusNone, integerValue)

RCT_ENUM_CONVERTER(TCHChannelStatus,(@{
                                       @"Invited" : @(TCHChannelStatusInvited),
                                       @"Joined" : @(TCHChannelStatusJoined),
                                       @"NotParticipating" : @(TCHChannelStatusNotParticipating),
                                      }), TCHChannelStatusInvited, integerValue)

RCT_ENUM_CONVERTER(TCHChannelType,(@{
                                     @"Public" : @(TCHChannelTypePublic),
                                     @"Private" : @(TCHChannelTypePrivate),
                                     }), TCHChannelTypePublic, integerValue)

RCT_ENUM_CONVERTER(TCHUserUpdate,(@{
                                        @"FriendlyName" : @(TCHUserUpdateFriendlyName),
                                        @"Attributes" : @(TCHUserUpdateAttributes),
                                        @"ReachabilityOnline": @(TCHUserUpdateReachabilityOnline),
                                        @"ReachabilityNotifiable": @(TCHUserUpdateReachabilityNotifiable),
                                        }), TCHUserUpdateFriendlyName, integerValue)

RCT_ENUM_CONVERTER(TCHLogLevel,(@{
                                  @"Fatal" : @(TCHLogLevelFatal),
                                  @"Critical" : @(TCHLogLevelCritical),
                                  @"Warning" : @(TCHLogLevelWarning),
                                  @"Info" : @(TCHLogLevelInfo),
                                  @"Debug" : @(TCHLogLevelDebug),
                                }), TCHLogLevelFatal, integerValue)

RCT_ENUM_CONVERTER(TCHClientConnectionState,(@{
                                  @"Unknown" : @(TCHClientConnectionStateUnknown),
                                  @"Disconnected" : @(TCHClientConnectionStateDisconnected),
                                  @"Connected" : @(TCHClientConnectionStateConnected),
                                  @"Connecting" : @(TCHClientConnectionStateConnecting),
                                  @"Denied" : @(TCHClientConnectionStateDenied),
                                  @"Error" : @(TCHClientConnectionStateError)
                                  }), TCHClientConnectionStateUnknown, integerValue)


+ (NSDictionary *)TwilioAccessManager:(TwilioAccessManager *)accessManager {
  if (!accessManager) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"token": accessManager.currentToken,
           @"expirationDate": @(accessManager.expiryTime.timeIntervalSince1970 * 1000)
           };
}

+ (NSDictionary *)TwilioChatClient:(TwilioChatClient *)client {
  if (!client) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"user": [self TCHUser:client.user],
           @"synchronizationStatus": @(client.synchronizationStatus),
           @"version": client.version,
           @"isReachabilityEnabled": @(client.isReachabilityEnabled)
           };
}


+ (NSDictionary *)TCHUser:(TCHUser *)user {
  if (!user) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": user.identity,
           @"friendlyName": user.friendlyName,
           @"attributes": RCTNullIfNil(user.attributes),
           @"isOnline": @(user.isOnline),
           @"isNotifiable": @(user.isNotifiable)
           };
}

+ (NSDictionary *)TCHUserDescriptor:(TCHUserDescriptor *)user {
  if (!user) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": user.identity,
           @"friendlyName": user.friendlyName,
           @"attributes": RCTNullIfNil(user.attributes),
           @"isOnline": @(user.isOnline),
           @"isNotifiable": @(user.isNotifiable)
           };
}

+ (NSDictionary *)TCHMessage:(TCHMessage *)message {
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

+ (NSDictionary *)TCHMember:(TCHMember *)member {
  if (!member) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": RCTNullIfNil(member.identity),
           @"lastConsumedMessageIndex": RCTNullIfNil(member.lastConsumedMessageIndex),
           @"lastConsumptionTimestamp": RCTNullIfNil(member.lastConsumptionTimestamp)
           };
}

+ (NSDictionary *)TCHChannel:(TCHChannel *)channel {
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
           @"dateUpdated": channel.dateUpdated,
           @"createdBy": channel.createdBy
           };
}

+ (NSDictionary *)TCHChannelDescriptor:(TCHChannelDescriptor *)channel {
    if (!channel) {
        return RCTNullIfNil(nil);
    }
    return @{
             @"sid": channel.sid,
             @"friendlyName": channel.friendlyName,
             @"uniqueName": channel.uniqueName,
             @"attributes": RCTNullIfNil(channel.attributes),
             @"messageCount": @(channel.messagesCount),
             @"membersCount": @(channel.membersCount),
             @"dateCreated": @(channel.dateCreated.timeIntervalSince1970 * 1000),
             @"dateUpdated": @(channel.dateUpdated.timeIntervalSince1970 * 1000),
             @"createdBy": channel.createdBy
             };
}

+ (NSArray *)TCHMembers:(NSArray<TCHMember *>*)members {
  if (!members) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TCHMember *member in members) {
    [response addObject:[self TCHMember:member]];
  }
  return response;
}

+ (NSArray *)TCHChannels:(NSArray<TCHChannel *>*)channels {
    if (!channels) {
        return RCTNullIfNil(nil);
    }
    NSMutableArray *response = [NSMutableArray array];
    for (TCHChannel *channel in channels) {
        [response addObject:[self TCHChannel:channel]];
    }
    return response;
}

+ (NSArray *)TCHChannelDescriptors:(NSArray<TCHChannelDescriptor *>*)channels {
    if (!channels) {
        return RCTNullIfNil(nil);
    }
    NSMutableArray *response = [NSMutableArray array];
    for (TCHChannelDescriptor *channel in channels) {
        [response addObject:[self TCHChannelDescriptor:channel]];
    }
    return response;
}

+ (NSArray *)TCHMessages:(NSArray<TCHMessage *> *)messages {
  if (!messages) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TCHMessage *message in messages) {
    [response addObject:[self TCHMessage:message]];
  }
  return response;
}

+ (NSArray *)TCHUserDescriptors:(NSArray<TCHUserDescriptor *>*)users {
  if (!users) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TCHUserDescriptor *user in users) {
    [response addObject:[self TCHUserDescriptor:user]];
  }
  return response;
}

+ (NSDictionary *)TCHMemberPaginator:(TCHMemberPaginator *)paginator {
    if (!paginator) {
        return RCTNullIfNil(nil);
    }
    return @{
             @"hasNextPage": @(paginator.hasNextPage),
             @"items": [self TCHMembers:paginator.items]
             };
}

+ (NSDictionary *)TCHChannelDescriptorPaginator:(TCHChannelDescriptorPaginator *)paginator {
    if (!paginator) {
        return RCTNullIfNil(nil);
    }
    return @{
             @"hasNextPage": @(paginator.hasNextPage),
             @"items": [self TCHChannelDescriptors:paginator.items]
             };
}

+ (NSDictionary *)TCHUserDescriptorPaginator:(TCHUserDescriptorPaginator *)paginator {
  if (!paginator) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"hasNextPage": @(paginator.hasNextPage),
           @"items": [self TCHUserDescriptors:paginator.items]
           };
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
