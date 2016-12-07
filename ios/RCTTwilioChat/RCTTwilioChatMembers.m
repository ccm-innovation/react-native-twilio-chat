//
//  RCTTwilioChatMembers.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/7/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioChatMembers.h"
#import "RCTConvert+TwilioChatClient.h"
#import "RCTTwilioChatClient.h"
#import <RCTUtils.h>

@implementation RCTTwilioChatMembers

RCT_EXPORT_MODULE()

- (TCHMembers *)loadMembersFromChannelSid:(NSString *)sid {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
  return [[[client channelsList] channelWithId:sid] members];
}

#pragma mark Members Methods

RCT_REMAP_METHOD(getMembers, channelSid:(NSString *)channelSid allObjects_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
    [[client members] membersWithCompletion:^(TCHResult *result, TCHMemberPaginator *paginator) {
        if (result.isSuccessful) {
            NSString *uuid = [RCTTwilioChapPaginator setPaginator:paginator];
            resolve(@{
                      @"sid":uuid,
                      @"paginator": [RCTConvert TCHMemberPaginator:paginator]
                      }]);
            
        }
        else {
            reject(@"get-members-error", @"Error occured while attempting to get the members.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(add, channelSid:(NSString *)channelSid identity:(NSString *)identity add_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [[self loadMembersFromChannelSid:channelSid] addByIdentity:identity completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"add-identity-error", @"Error occured while attempting to add a user to the channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(invite, channelSid:(NSString *)channelSid identity:(NSString *)identity invite_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [[self loadMembersFromChannelSid:channelSid] inviteByIdentity:identity completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"invite-identity-error", @"Error occured while attempting to inviate a user to the channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(remove, channelSid:(NSString *)channelSid identity:(NSString *)identity remove_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
  TCHMember *member = [[[client channelsList] channelWithId:channelSid] memberWithIdentity:identity];
  [[self loadMembersFromChannelSid:channelSid] removeMember:member completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"remove-member-error", @"Error occured while attempting to remove a user from the channel.", result.error);
    }
  }];
}

@end
