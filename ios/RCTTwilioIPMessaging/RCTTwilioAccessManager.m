//
//  RCTTwilioAccessManager.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioAccessManager.h"
#import "RCTConvert+TwilioIPMessagingClient.h"
#import "RCTUtils.h"
#import "RCTEventDispatcher.h"



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
  [accessManager updateToken:token];
  resolve([RCTConvert TwilioAccessManager:accessManager]);
}

RCT_EXPORT_METHOD(token:(RCTResponseSenderBlock)callback) {
  callback(@[[accessManager token]]);
}

RCT_EXPORT_METHOD(identity:(RCTResponseSenderBlock)callback) {
  callback(@[[accessManager identity]]);
}

RCT_EXPORT_METHOD(isExpired:(RCTResponseSenderBlock)callback) {
  callback(@[@([accessManager isExpired])]);
}

RCT_EXPORT_METHOD(expirationDate:(RCTResponseSenderBlock)callback) {
  callback(@[@([accessManager expirationDate].timeIntervalSince1970 * 1000)]);
}

#pragma mark Twilio Access Manager Delagate Methods

- (void)accessManagerTokenExpired:(TwilioAccessManager *)accessManager {
  NSLog(@"Access token expired");
  [self.bridge.eventDispatcher sendAppEventWithName:@"accessManager:tokenExpired"
                                               body:nil];
}

- (void)accessManager:(TwilioAccessManager *)accessManager error:(NSError *)error {
  NSLog(@"Error updating token: %@", error);
  [self.bridge.eventDispatcher sendAppEventWithName:@"accessManager:error"
                                               body:@{@"error": [error localizedDescription],
                                                      @"userInfo": [error userInfo]}];
}

@end
