//
//  RCTTCHChannels.h
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/2/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <TwilioChatClient/TCHChannels.h>
#import <TwilioChatClient/TCHChannel.h>
#import <React/RCTBridgeModule.h>

@interface RCTTwilioChatChannels : NSObject <RCTBridgeModule>

+ (void)loadChannelFromSid:(NSString *)sid :(void (^)(TCHResult *result, TCHChannel *channel))completion;

@end
