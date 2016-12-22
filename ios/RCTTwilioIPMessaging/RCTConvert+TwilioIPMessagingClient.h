//
//  RCTConvert+TwilioAccessManager.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//
#import <TwilioIPMessagingClient/TwilioIPMessagingClient.h>
#import <TwilioIPMessagingClient/TWMUserInfo.h>
#import "RCTConvert.h"

@interface RCTConvert (TwilioIPMessagingClient)

+ (TWMClientSynchronizationStatus)TWMClientSynchronizationStatus:(id)json;
+ (TWMChannelSynchronizationStatus)TWMChannelSynchronizationStatus:(id)json;
+ (TWMChannelType)TWMChannelType:(id)json;
+ (TWMChannelStatus)TWMChannelStatus:(id)json;
+ (TWMUserInfoUpdate)TWMUserInfoUpdate:(id)json;
+ (TWMClientSynchronizationStrategy)TWMClientSynchronizationStrategy:(id)json;
+ (TWMLogLevel)TWMLogLevel:(id)json;

+ (NSDictionary *)TwilioAccessManager:(TwilioAccessManager *)accessManager;
+ (NSDictionary *)TwilioIPMessagingClient:(TwilioIPMessagingClient *)client;

+ (NSDictionary *)TWMChannel:(TWMChannel *)channel;
+ (NSDictionary *)TWMUserInfo:(TWMUserInfo *)userInfo;
+ (NSDictionary *)TWMMember:(TWMMember *)member;
+ (NSDictionary *)TWMMessage:(TWMMessage *)message;

+ (NSArray *)TWMMembers:(NSArray<TWMMember *>*)members;
+ (NSArray *)TWMMessages:(NSArray<TWMMessage *> *)messages;

+ (NSData *)dataWithHexString:(NSString*)hex;

@end
