//
//  RCTConvert+TwilioChatClient.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//
#import <TwilioChatClient/TwilioChatClient.h>
#import <TwilioChatClient/TCHUserInfo.h>
#import <TwilioAccessManager/TwilioAccessManager.h>
#import <React/RCTConvert.h>

@interface RCTConvert (TwilioChatClient)

+ (TCHClientSynchronizationStatus)TCHClientSynchronizationStatus:(id)json;
+ (TCHChannelSynchronizationStatus)TCHChannelSynchronizationStatus:(id)json;
+ (TCHChannelType)TCHChannelType:(id)json;
+ (TCHChannelStatus)TCHChannelStatus:(id)json;
+ (TCHUserInfoUpdate)TCHUserInfoUpdate:(id)json;
+ (TCHClientSynchronizationStrategy)TCHClientSynchronizationStrategy:(id)json;
+ (TCHLogLevel)TCHLogLevel:(id)json;
+ (TCHClientConnectionState)TCHClientConnectionState:(id)json;

+ (NSDictionary *)TwilioAccessManager:(TwilioAccessManager *)accessManager;
+ (NSDictionary *)TwilioChatClient:(TwilioChatClient *)client;

+ (NSDictionary *)TCHChannel:(TCHChannel *)channel;
+ (NSDictionary *)TCHChannelDescriptor:(TCHChannelDescriptor *)channel;
+ (NSDictionary *)TCHUserInfo:(TCHUserInfo *)userInfo;
+ (NSDictionary *)TCHMember:(TCHMember *)member;
+ (NSDictionary *)TCHMessage:(TCHMessage *)message;

+ (NSDictionary *)TCHMemberPaginator:(TCHMemberPaginator *)paginator;
+ (NSDictionary *)TCHChannelPaginator:(TCHChannelPaginator *)paginator;
+ (NSDictionary *)TCHChannelDescriptorPaginator:(TCHChannelDescriptorPaginator *)paginator;

+ (NSArray *)TCHChannels:(NSArray<TCHChannel *>*)channels;
+ (NSArray *)TCHChannelDescriptors:(NSArray<TCHChannelDescriptor *>*)channels;
+ (NSArray *)TCHMembers:(NSArray<TCHMember *>*)members;
+ (NSArray *)TCHMessages:(NSArray<TCHMessage *> *)messages;

+ (NSData *)dataWithHexString:(NSString*)hex;

@end
