//
//  RCTTwilioChatClient.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <TwilioChatClient/TwilioChatClient.h>
#import <React/RCTBridgeModule.h>

@interface RCTTwilioChatClient : NSObject <RCTBridgeModule> {
  TwilioChatClient *client;
}

@property (nonatomic, retain) TwilioChatClient *client;

+ (id)sharedManager;

@end
