//
//  RCTConvert+TwilioChatClient.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//
#import <TwilioChatClient/TwilioChatClient.h>
#import <TwilioChatClient/TCHUserInfo.h>
#import <RCTConvert.h>

@interface RCTConvert (TwilioChatClient)

+ (TCHClientSynchronizationStatus)TCHClientSynchronizationStatus:(id)json;
+ (TCHChannelSynchronizationStatus)TCHChannelSynchronizationStatus:(id)json;
+ (TCHChannelType)TCHChannelType:(id)json;
+ (TCHChannelStatus)TCHChannelStatus:(id)json;
+ (TCHUserInfoUpdate)TCHUserInfoUpdate:(id)json;
+ (TCHClientSynchronizationStrategy)TCHClientSynchronizationStrategy:(id)json;
+ (TCHLogLevel)TCHLogLevel:(id)json;

+ (NSDictionary *)TwilioAccessManager:(TwilioAccessManager *)accessManager;
+ (NSDictionary *)TwilioChatClient:(TwilioChatClient *)client;

+ (NSDictionary *)TCHChannel:(TCHChannel *)channel;
+ (NSDictionary *)TCHUserInfo:(TCHUserInfo *)userInfo;
+ (NSDictionary *)TCHMember:(TCHMember *)member;
+ (NSDictionary *)TCHMessage:(TCHMessage *)message;

+ (NSArray *)TCHMembers:(NSArray<TCHMember *>*)members;
+ (NSArray *)TCHMessages:(NSArray<TCHMessage *> *)messages;

+ (NSData *)dataWithHexString:(NSString*)hex;

@end
