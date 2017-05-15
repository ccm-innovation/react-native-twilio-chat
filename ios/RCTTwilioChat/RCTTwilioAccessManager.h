//
//  RCTTwilioAccessManager.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//
#import <TwilioAccessManager/TwilioAccessManager.h>
#import <React/RCTBridgeModule.h>

@interface RCTTwilioAccessManager : NSObject <RCTBridgeModule> {
  TwilioAccessManager *accessManager;
}

@property (nonatomic, strong) TwilioAccessManager *accessManager;

+ (instancetype)sharedManager;

@end
