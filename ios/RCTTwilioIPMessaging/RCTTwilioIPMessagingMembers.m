//
//  RCTTwilioIPMessagingMembers.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/7/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioIPMessagingMembers.h"
#import "RCTConvert+TwilioIPMessagingClient.h"
#import "RCTTwilioIPMessagingClient.h"
#import <RCTUtils.h>

@implementation RCTTwilioIPMessagingMembers

RCT_EXPORT_MODULE()

- (TWMMembers *)loadMembersFromChannelSid:(NSString *)sid {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  return [[[client channelsList] channelWithId:sid] members];
}

#pragma mark Members Methods

RCT_REMAP_METHOD(getMembers, channelSid:(NSString *)channelSid allObjects_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  NSArray<TWMMember *> *members = [[self loadMembersFromChannelSid:channelSid] allObjects];
  NSMutableArray *response = [NSMutableArray array];
  if (members) {
    for (TWMMember *member in members) {
      [response addObject:[RCTConvert TWMMember:member]];
    }
  }
  resolve(RCTNullIfNil(response));
}

RCT_REMAP_METHOD(add, channelSid:(NSString *)channelSid identity:(NSString *)identity add_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [[self loadMembersFromChannelSid:channelSid] addByIdentity:identity completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"add-identity-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(invite, channelSid:(NSString *)channelSid identity:(NSString *)identity invite_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [[self loadMembersFromChannelSid:channelSid] inviteByIdentity:identity completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"invite-identity-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(remove, channelSid:(NSString *)channelSid identity:(NSString *)identity remove_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  TWMMember *member = [[[client channelsList] channelWithId:channelSid] memberWithIdentity:identity];
  [[self loadMembersFromChannelSid:channelSid] removeMember:member completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"remove-member-error", @"error", result.error);
    }
  }];
}


RCT_REMAP_METHOD(getMember, channelSid:(NSString *)channelSid identity:(NSString *)identity member_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    resolve([RCTConvert TWMMember:[[self loadMembersFromChannelSid:channelSid] memberWithIdentity:identity]);
}

@end
