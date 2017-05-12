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
#import "RCTTwilioChatChannels.h"
#import "RCTTwilioChatPaginator.h"
#import <React/RCTUtils.h>

@implementation RCTTwilioChatMembers

RCT_EXPORT_MODULE()

- (void)loadMembersFromChannelSid:(NSString *)sid :(void (^)(TCHResult *result, TCHMembers *members))completion {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        completion(result, [channel members]);
    }];
}

#pragma mark Members Methods

RCT_REMAP_METHOD(getMembers, channelSid:(NSString *)channelSid allObjects_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMembersFromChannelSid:channelSid :^(TCHResult *result, TCHMembers *members) {
        if (result.isSuccessful) {
            [members membersWithCompletion:^(TCHResult *result, TCHMemberPaginator *paginator) {
                if (result.isSuccessful) {
                    NSString *uuid = [RCTTwilioChatPaginator setPaginator:paginator];
                    resolve(@{
                              @"sid":uuid,
                              @"type": @"Member",
                              @"paginator": [RCTConvert TCHMemberPaginator:paginator]
                              });
                }
                else {
                    reject(@"get-members-error", @"Error occured while attempting to get the members.", result.error);
                }
            }];
        }
        else {
           reject(@"get-members-error", @"Error occured while attempting to get the members.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(add, channelSid:(NSString *)channelSid identity:(NSString *)identity add_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMembersFromChannelSid:channelSid :^(TCHResult *result, TCHMembers *members) {
        if (result.isSuccessful) {
            [members addByIdentity:identity completion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"add-identity-error", @"Error occured while attempting to add a user to the channel.", result.error);
                }
            }];
        }
        else {
            reject(@"add-identity-error", @"Error occured while attempting to add a user to the channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(invite, channelSid:(NSString *)channelSid identity:(NSString *)identity invite_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMembersFromChannelSid:channelSid :^(TCHResult *result, TCHMembers *members) {
        if (result.isSuccessful) {
            [members inviteByIdentity:identity completion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"invite-identity-error", @"Error occured while attempting to inviate a user to the channel.", result.error);
                }
            }];
        }
        else {
            reject(@"invite-identity-error", @"Error occured while attempting to inviate a user to the channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(remove, channelSid:(NSString *)channelSid identity:(NSString *)identity remove_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {

    [RCTTwilioChatChannels loadChannelFromSid:channelSid :^(TCHResult *result, TCHChannel *channel) {
        TCHMember *member = [channel memberWithIdentity:identity];
        [[channel members] removeMember:member completion:^(TCHResult *result) {
            if (result.isSuccessful) {
                resolve(@[@TRUE]);
            }
            else {
                reject(@"remove-member-error", @"Error occured while attempting to remove a user from the channel.", result.error);
            }
        }];
    }];
}
@end
