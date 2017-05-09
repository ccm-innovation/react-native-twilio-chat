//
//  RCTTwilioChatPaginator.m
//  RCTTwilioChat
//
//  Created by Brad Bumbalough on 12/2/16.
//  Copyright © 2016 Brad Bumbalough. All rights reserved.
//

#import "RCTTwilioChatPaginator.h"
#import "RCTConvert+TwilioChatClient.h"
#import <React/RCTUtils.h>

@interface RCTTwilioChatPaginator()
@end

@implementation RCTTwilioChatPaginator

@synthesize paginators;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static RCTTwilioChatPaginator *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.paginators = [[NSMutableDictionary alloc] init];
    });
    return sharedMyManager;
}

+ (NSString*)setPaginator:(id)paginator {
    RCTTwilioChatPaginator *_paginator = [RCTTwilioChatPaginator sharedManager];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [_paginator.paginators setValue:paginator forKey:uuid];
    return uuid;
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(requestNextPageChannels, sid:(NSString*)sid requestNextPageChannels_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSMutableDictionary *_paginators = [[RCTTwilioChatPaginator sharedManager] paginators];
    [[_paginators objectForKey:sid] requestNextPageWithCompletion:^(TCHResult *result, TCHChannelPaginator *paginator) {
        if (result.isSuccessful) {
            NSString* uuid = [RCTTwilioChatPaginator setPaginator:paginator];
            resolve(@{
                      @"sid":uuid,
                      @"type": @"Channel",
                      @"paginator": [RCTConvert TCHChannelPaginator:paginator]
                      });
        }
        else {
            reject(@"request-next-page", @"Error occured while attempting to request the next page.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(requestNextPageChannelDescriptors, sid:(NSString*)sid requestNextPageChannelDescriptors_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSMutableDictionary *_paginators = [[RCTTwilioChatPaginator sharedManager] paginators];
    [[_paginators objectForKey:sid] requestNextPageWithCompletion:^(TCHResult *result, TCHChannelDescriptorPaginator *paginator) {
        if (result.isSuccessful) {
            NSString* uuid = [RCTTwilioChatPaginator setPaginator:paginator];
            resolve(@{
                      @"sid":uuid,
                      @"type": @"ChannelDescriptor",
                      @"paginator": [RCTConvert TCHChannelDescriptorPaginator:paginator]
                      });
        }
        else {
            reject(@"request-next-page", @"Error occured while attempting to request the next page.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(requestNextPageMembers, sid:(NSString*)sid requestNextPageMembers_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSMutableDictionary *_paginators = [[RCTTwilioChatPaginator sharedManager] paginators];
    [[_paginators objectForKey:sid] requestNextPageWithCompletion:^(TCHResult *result, TCHMemberPaginator *paginator) {
        if (result.isSuccessful) {
            NSString* uuid = [RCTTwilioChatPaginator setPaginator:paginator];
            resolve(@{
                      @"sid":uuid,
                      @"paginator": [RCTConvert TCHMemberPaginator:paginator]
                      });
        }
        else {
            reject(@"request-next-page", @"Error occured while attempting to request the next page.", result.error);
        }
    }];
}

@end
