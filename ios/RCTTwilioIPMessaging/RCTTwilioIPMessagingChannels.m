//
//  RCTTWMChannels.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/2/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioIPMessagingChannels.h"
#import "RCTTwilioIPMessagingClient.h"
#import "RCTConvert+TwilioIPMessagingClient.h"
#import <RCTUtils.h>

@implementation RCTTwilioIPMessagingChannels

RCT_EXPORT_MODULE();

- (TWMChannel *)loadChannelFromSid:(NSString *)sid {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  return [[client channelsList] channelWithId:sid];
}

#pragma mark Channel Methods

RCT_REMAP_METHOD(getChannels, allObjects_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  NSArray<TWMChannel *> *channels = [[client channelsList] allObjects];
  NSMutableArray *response = [NSMutableArray array];
  if (channels) {
    for (TWMChannel *channel in channels) {
      [response addObject:[RCTConvert TWMChannel:channel]];
    }
  }
  resolve(RCTNullIfNil(response));
}

RCT_REMAP_METHOD(createChannel, options:(NSDictionary *)options create_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  [[client channelsList] createChannelWithOptions:options completion:^(TWMResult *result, TWMChannel *channel) {
    if (result.isSuccessful) {
      resolve([RCTConvert TWMChannel:channel]);
    }
    else {
      reject(@"create-error", @"Error occured while creating a new channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getChannel, sid:(NSString *)sid sid_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  TWMChannel *channel = [[client channelsList] channelWithId:sid];
  if (channel) {
    resolve([RCTConvert TWMChannel:channel]);
  }
  else {
      NSError *error = nil;
      reject(@"not-found", [NSString stringWithFormat:@"Channel could not be found with sid: %@.", sid], error);
  }
}

RCT_REMAP_METHOD(getChannelByUniqueName, uniqueName:(NSString *)uniqueName sid_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  TWMChannel *channel = [[client channelsList] channelWithUniqueName:uniqueName];
  if (channel) {
    resolve([RCTConvert TWMChannel:channel]);
  }
  else {
      NSError *error = nil;
      reject(@"not-found", [NSString stringWithFormat:@"Channel could not be found with uniqueName: %@.", uniqueName], error);
  }
}

#pragma mark Channel Instance Methods

RCT_REMAP_METHOD(synchronize, sid:(NSString *)sid synchronize_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel synchronizeWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"sync-error", @"Error occured during channel syncronization.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(setAttributes, sid:(NSString *)sid attributes:(NSDictionary *)attributes attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel setAttributes:attributes completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-attributes-error", @"Error occuring while attempting to setAttributes on channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(setFriendlyName, sid:(NSString *)sid friendlyName:(NSString *)friendlyName attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel setFriendlyName:friendlyName completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-friendlyName-error", @"Error occured while attempting to setFriendlyName on channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(setUniqueName, sid:(NSString *)sid uniqueName:(NSString *)uniqueName attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel setUniqueName:uniqueName completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"set-friendlyName-error", @"Error occured while attempting to setUniqueName on channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(join, sid:(NSString *)sid join_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel joinWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"join-channel-error", @"Error occured while attempting to join the channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(declineInvitation, sid:(NSString *)sid decline_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel declineInvitationWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"decline-invitation-error", @"Error occured while attempting to decline the invitation to join the channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(leave, sid:(NSString *)sid leave_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel leaveWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"leave-channel-error", @"Error occured while attempting to leave the channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(destroy, sid:(NSString *)sid destroy_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel destroyWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"destroy-channel-error", @"Error occured while attempting to delete the channel.", result.error);
    }
  }];
}


RCT_REMAP_METHOD(typing, sid:(NSString *)sid) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel typing];
}

@end
