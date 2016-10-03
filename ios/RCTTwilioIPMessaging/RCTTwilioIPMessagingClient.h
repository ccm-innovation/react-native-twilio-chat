//
//  RCTTwilioIPMessagingClient.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <TwilioIPMessagingClient/TwilioIPMessagingClient.h>
#import "RCTBridgeModule.h"

@interface RCTTwilioIPMessagingClient : NSObject <RCTBridgeModule> {
  TwilioIPMessagingClient *client;
}

@property (nonatomic, retain) TwilioIPMessagingClient *client;

+ (id)sharedManager;

@end