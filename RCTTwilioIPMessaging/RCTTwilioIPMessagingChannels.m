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

RCT_REMAP_METHOD(allObjects, allObjects_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
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

RCT_REMAP_METHOD(createChannelWithOptions, options:(NSDictionary *)options create_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  [[client channelsList] createChannelWithOptions:options completion:^(TWMResult *result, TWMChannel *channel) {
    if (result.isSuccessful) {
      resolve([RCTConvert TWMChannel:channel]);
    }
    else {
      reject(@"create-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(channelWithId, sid:(NSString *)sid sid_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  TWMChannel *channel = [[client channelsList] channelWithId:sid];
  if (channel) {
    resolve([RCTConvert TWMChannel:channel]);
  }
  else {
    reject(@"not-found", @"error", [NSError init]);
  }
}

RCT_REMAP_METHOD(channelWithUniqueName, uniqueName:(NSString *)uniqueName sid_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  TWMChannel *channel = [[client channelsList] channelWithUniqueName:uniqueName];
  if (channel) {
    resolve([RCTConvert TWMChannel:channel]);
  }
  else {
    reject(@"not-found", @"error", [NSError init]);
  }
}

#pragma mark Channel Instance Methods

RCT_REMAP_METHOD(members, sid:(NSString *)sid members_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  resolve([RCTConvert TWMMembers:channel.members.allObjects]);
}

RCT_REMAP_METHOD(synchronizeWithCompletion, sid:(NSString *)sid synchronize_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel synchronizeWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"sync-error", @"error", result.error);
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
      reject(@"set-attributes-error", @"error", result.error);
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
      reject(@"set-friendlyName-error", @"error", result.error);
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
      reject(@"set-friendlyName-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(joinWithCompletion, sid:(NSString *)sid join_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel joinWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"join-channel-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(declineInvitationWithCompletion, sid:(NSString *)sid decline_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel declineInvitationWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"decline-invitation-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(leaveWithCompletion, sid:(NSString *)sid leave_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel leaveWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"leave-channel-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(destroyWithCompletion, sid:(NSString *)sid destroy_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel destroyWithCompletion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"destroy-channel-error", @"error", result.error);
    }
  }];
}


RCT_REMAP_METHOD(typing, sid:(NSString *)sid) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  [channel typing];
}

RCT_REMAP_METHOD(memberWithIdentity, sid:(NSString *)sid identity:(NSString *)identity member_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMChannel *channel = [self loadChannelFromSid:sid];
  resolve([RCTConvert TWMMember:[channel memberWithIdentity:identity]]);
}

@end
