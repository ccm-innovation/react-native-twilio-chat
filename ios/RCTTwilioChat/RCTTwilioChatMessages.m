//
//  RCTTwilioChatMessages.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/3/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioChatMessages.h"
#import "RCTTwilioChatChannels.h"
#import "RCTTwilioChatClient.h"
#import "RCTConvert+TwilioChatClient.h"
#import <RCTUtils.h>

@implementation RCTTwilioChatMessages

RCT_EXPORT_MODULE()

- (TCHMessages *)loadMessagesFromChannelSid:(NSString *)channelSid {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
  return [[[client channelsList] channelWithId:channelSid] messages];
}

#pragma mark Messages Methods

RCT_REMAP_METHOD(getLastConsumedMessageIndex, channelSid:(NSString *)channelSid last_consumed_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  resolve(@[RCTNullIfNil(messages.lastConsumedMessageIndex)]);
}


RCT_REMAP_METHOD(sendMessage, channelSid:(NSString *)channelSid body:(NSString *)body send_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages sendMessage:[messages createMessageWithBody:body] completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"send-message-error", @"Error occured while attempting to send a message.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(removeMessage, channelSid:(NSString *)channelSid index:(NSNumber *)index remove_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages removeMessage:[messages messageWithIndex:index] completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"remove-message-error", @"Error occured while attempting to delete a message.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getLastMessages, channelSid:(NSString *)channelSid count:(NSUInteger)count get_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages getLastMessagesWithCount:count completion:^(TCHResult *result, NSArray<TCHMessage *> *messages) {
    if (result.isSuccessful) {
      resolve([RCTConvert TCHMessages:messages]);
    }
    else {
      reject(@"get-message-error", @"Error occured while attempting to getLastMessages.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getMessagesBefore, channelSid:(NSString *)channelSid index:(NSUInteger)index withCount:(NSUInteger)withCount get_message_before_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages getMessagesBefore:index withCount:withCount completion:^(TCHResult *result, NSArray<TCHMessage *> *messages) {
    if (result.isSuccessful) {
      resolve([RCTConvert TCHMessages:messages]);
    }
    else {
      reject(@"get-message-error", @"Error occured while attempting to getMessagesBefore.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getMessagesAfter, channelSid:(NSString *)channelSid index:(NSUInteger)index withCount:(NSUInteger)withCount get_message_after_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages getMessagesAfter:index withCount:withCount completion:^(TCHResult *result, NSArray<TCHMessage *> *messages) {
    if (result.isSuccessful) {
      resolve([RCTConvert TCHMessages:messages]);
    }
    else {
      reject(@"get-message-error", @"Error occured while attempting to getMessagesAfter.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getMessage, channelSid:(NSString *)channelSid index:(NSNumber *)index message_index_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  resolve([RCTConvert TCHMessage:[messages messageWithIndex:index]]);
}

RCT_REMAP_METHOD(messageForConsumptionIndex, channelSid:(NSString *)channelSid index:(NSNumber *)index consumption_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
    resolve([RCTConvert TCHMessage:[messages messageForConsumptionIndex:index]]);
}

RCT_REMAP_METHOD(setLastConsumedMessageIndex, channelSid:(NSString *)channelSid set_index:(NSNumber *)index) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages setLastConsumedMessageIndex:index];
}

RCT_REMAP_METHOD(advanceLastConsumedMessageIndex, channelSid:(NSString *)channelSid advance_index:(NSNumber *)index) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages advanceLastConsumedMessageIndex:index];
}

RCT_REMAP_METHOD(setAllMessagesConsumed, channelSid:(NSString *)channelSid) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [messages setAllMessagesConsumed];
}

#pragma mark Message Instance Methods

RCT_REMAP_METHOD(updateBody, channelSid:(NSString *)channelSid index:(NSNumber *)index body:(NSString *)body update_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
  [[messages messageWithIndex:index] updateBody:body completion:^(TCHResult *result) {
    if (result.isSuccessful) {
      resolve(@[@TRUE]);
    }
    else {
      reject(@"update-message-error", @"Error occured while attempting to update the body of the message.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(setAttributes, channelSid:(NSString *)channelSid index:(NSNumber *)index attributes:(NSDictionary *)attributes set_attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    TCHMessages *messages = [self loadMessagesFromChannelSid:channelSid];
    [[messages messageWithIndex:index] setAttributes:attributes completion:^(TCHResult *result) {
        if (result.isSuccessful) {
            resolve(@[@TRUE]);
        }
        else {
            reject(@"set-attributes-error", @"Error occured while attempting to set attributes of the message.", result.error);
        }
    }];
}

@end
