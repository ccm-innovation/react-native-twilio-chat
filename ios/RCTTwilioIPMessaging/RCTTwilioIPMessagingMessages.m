//
//  RCTTwilioIPMessagingMessages.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/3/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioIPMessagingMessages.h"
#import "RCTTwilioIPMessagingChannels.h"
#import "RCTTwilioIPMessagingClient.h"
#import "RCTConvert+TwilioIPMessagingClient.h"
#import <RCTUtils.h>

@implementation RCTTwilioIPMessagingMessages

RCT_EXPORT_MODULE()

- (TWMMessages *)loadMessagesFromChannelSid:(NSString *)channelSid {
  TwilioIPMessagingClient *client = [[RCTTwilioIPMessagingClient sharedManager] client];
  return [[[client channelsList] channelWithId:channelSid] messages];
}

#pragma mark Messages Methods

RCT_REMAP_METHOD(getLastConsumedMessageIndex, channelSid:(NSString *)channelSid last_consumed_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  resolve(@[RCTNullIfNil(messages.lastConsumedMessageIndex)]);
}


RCT_REMAP_METHOD(sendMessage, channelSid:(NSString *)channelSid body:(NSString *)body send_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages sendMessage:[messages createMessageWithBody:body] completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"send-message-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(removeMessage, channelSid:(NSString *)channelSid index:(NSNumber *)index remove_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages removeMessage:[messages messageWithIndex:index] completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"remove-message-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getLastMessages, channelSid:(NSString *)channelSid count:(NSUInteger)count get_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages getLastMessagesWithCount:count completion:^(TWMResult *result, NSArray<TWMMessage *> *messages) {
    if (result.isSuccessful) {
      resolve([RCTConvert TWMMessages:messages]);
    }
    else {
      reject(@"get-message-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getMessagesBefore, channelSid:(NSString *)channelSid index:(NSUInteger)index withCount:(NSUInteger)withCount get_message_before_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages getMessagesBefore:index withCount:withCount completion:^(TWMResult *result, NSArray<TWMMessage *> *messages) {
    if (result.isSuccessful) {
      resolve([RCTConvert TWMMessages:messages]);
    }
    else {
      reject(@"get-message-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getMessagesAfter, channelSid:(NSString *)channelSid index:(NSUInteger)index withCount:(NSUInteger)withCount get_message_after_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages getMessagesAfter:index withCount:withCount completion:^(TWMResult *result, NSArray<TWMMessage *> *messages) {
    if (result.isSuccessful) {
      resolve([RCTConvert TWMMessages:messages]);
    }
    else {
      reject(@"get-message-error", @"error", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getMessage, channelSid:(NSString *)channelSid index:(NSNumber *)index message_index_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  resolve([RCTConvert TWMMessage:[messages messageWithIndex:index]]);
}

RCT_REMAP_METHOD(messageForConsumptionIndex, channelSid:(NSString *)channelSid index:(NSNumber *)index consumption_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
    resolve([RCTConvert TWMMessage:[messages messageForConsumptionIndex:index]]);
}

RCT_REMAP_METHOD(setLastConsumedMessageIndex, channelSid:(NSString *)channelSid set_index:(NSNumber *)index) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages setLastConsumedMessageIndex:index];
}

RCT_REMAP_METHOD(advanceLastConsumedMessageIndex, channelSid:(NSString *)channelSid advance_index:(NSNumber *)index) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages advanceLastConsumedMessageIndex:index];
}

RCT_REMAP_METHOD(setAllMessagesConsumed, channelSid:(NSString *)channelSid) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages setAllMessagesConsumed];
}

#pragma mark Message Instance Methods

RCT_REMAP_METHOD(updateBody, channelSid:(NSString *)channelSid index:(NSNumber *)index body:(NSString *)body update_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TWMMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [[messages messageWithIndex:index] updateBody:body completion:^(TWMResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"update-message-error", @"error", result.error);
    }
  }];
}

@end
