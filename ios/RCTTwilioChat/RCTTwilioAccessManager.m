//
//  RCTTwilioAccessManager.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioAccessManager.h"
#import "RCTConvert+TwilioChatClient.h"
#import <React/RCTUtils.h>
#import "RCTTwilioChatClient.h"
#import <React/RCTEventDispatcher.h>

@interface RCTTwilioAccessManager() <TwilioAccessManagerDelegate>
@end


@implementation RCTTwilioAccessManager

@synthesize bridge = _bridge;
@synthesize accessManager;

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
  static RCTTwilioAccessManager *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

RCT_EXPORT_MODULE()

#pragma mark Twilio Access Manager Methods

RCT_REMAP_METHOD(accessManagerWithToken, token:(NSString *)token token_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  RCTTwilioAccessManager *_accessManager = [RCTTwilioAccessManager sharedManager];
  _accessManager.accessManager = [TwilioAccessManager accessManagerWithToken:token delegate:self];
  resolve([RCTConvert TwilioAccessManager:_accessManager.accessManager]);
}

RCT_REMAP_METHOD(updateToken, token:(NSString *)token update_token_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    RCTTwilioAccessManager *_accessManager = [RCTTwilioAccessManager sharedManager];
    [_accessManager.accessManager updateToken:token];
    resolve([RCTConvert TwilioAccessManager:accessManager]);
}

RCT_EXPORT_METHOD(registerClient){
    RCTTwilioAccessManager *_accessManager = [RCTTwilioAccessManager sharedManager];
    __weak RCTTwilioChatClient *_client = [RCTTwilioChatClient sharedManager];
    [_accessManager.accessManager registerClient:_client.client forUpdates:^(NSString * _Nonnull updatedToken) {
        [_client.client updateToken:updatedToken completion:^(TCHResult *result) {
          NSLog(@"Access token updated");
        }];
    }];
}


 #pragma mark Twilio Access Manager Delagate Methods

- (void)accessManagerTokenWillExpire:(TwilioAccessManager *)accessManager {
  NSLog(@"Access token will expire");
  [self.bridge.eventDispatcher sendAppEventWithName:@"accessManager:tokenWillExpire"
                                               body:nil];
}

- (void)accessManagerTokenExpired:(TwilioAccessManager *)accessManager {
    NSLog(@"Access token expired");
    [self.bridge.eventDispatcher sendAppEventWithName:@"accessManager:tokenExpired"
                                                 body:nil];
}

- (void)accessManagerTokenInvalid:(nonnull TwilioAccessManager *)accessManager {
    NSLog(@"Token is invalid.");
    [self.bridge.eventDispatcher sendAppEventWithName:@"accessManager:tokenInvalid"
                                               body:nil];
}

@end
