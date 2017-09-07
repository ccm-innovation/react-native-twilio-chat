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
#import <React/RCTUtils.h>

@implementation RCTTwilioChatMessages

RCT_EXPORT_MODULE()

- (void)loadMessagesFromChannelSid:(NSString * __nonnull)sid :(void (^)(TCHResult *result, TCHMessages *messages))completion {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        completion(result, [channel messages]);
    }];
}

#pragma mark Messages Methods

RCT_REMAP_METHOD(getLastConsumedMessageIndex, channelSid:(NSString * __nonnull)channelSid last_consumed_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
      if (result.isSuccessful) {
          resolve(@[RCTNullIfNil(messages.lastConsumedMessageIndex)]);
      }
      else {
          reject(@"let-last-used-consumption-index-error", @"Error occured while attempting to getLastUsedConsumptionIndex.", result.error);
      }
  }];
}


RCT_REMAP_METHOD(sendMessage, channelSid:(NSString * __nonnull)channelSid body:(NSString * __nullable)body attributes:(NSDictionary<NSString *, id> *)attributes send_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
          TCHMessage* message = [messages createMessageWithBody:body];
          void (^sendListener)(TCHResult * sendResult) = ^(TCHResult *sendResult) {
              if (sendResult.isSuccessful) {
                  resolve(@[@TRUE]);
              }
              else {
                  reject(@"send-message-error", @"Error occured while attempting to send a message.", sendResult.error);
              }
          };
          if (attributes != nil) {
            [message setAttributes:attributes completion:^(TCHResult *setAttrResult) {
                if(setAttrResult.isSuccessful) {
                    [messages sendMessage:message completion:sendListener];
                } else {
                    reject(@"send-attributed-message-error", @"Error occured while attempting to send attributed message.", setAttrResult.error);
                }
            }];
          }
          else {
            [messages sendMessage:message completion:sendListener];
          }
        }
        else {
            reject(@"send-message-error", @"Error occured while attempting to send a message.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(removeMessage, channelSid:(NSString * __nonnull)channelSid index:(NSNumber * __nonnull)index remove_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages messageWithIndex:index completion:^(TCHResult *result, TCHMessage *message) {
                if (result.isSuccessful) {
                    [messages removeMessage:message completion:^(TCHResult *result) {
                        if (result.isSuccessful) {
                            resolve(@[@TRUE]);
                        }
                        else {
                            reject(@"remove-message-error", @"Error occured while attempting to delete a message.", result.error);
                        }
                    }];
                }
                else {
                    reject(@"remove-message-error", @"Error occured while attempting to delete a message.", result.error);
                }
            }];
        }
        else {
            reject(@"remove-message-error", @"Error occured while attempting to delete a message.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getLastMessages, channelSid:(NSString * __nonnull)channelSid count:(NSUInteger)count get_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
           [messages getLastMessagesWithCount:count completion:^(TCHResult *result, NSArray<TCHMessage *> *messages) {
               if (result.isSuccessful) {
                   resolve([RCTConvert TCHMessages:messages]);
               }
               else {
                   reject(@"get-message-error", @"Error occured while attempting to getLastMessages.", result.error);
               }
           }];
        }
        else {
            reject(@"get-message-error", @"Error occured while attempting to getLastMessages.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getMessagesBefore, channelSid:(NSString * __nonnull)channelSid index:(NSUInteger)index withCount:(NSUInteger)withCount get_message_before_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages getMessagesBefore:index withCount:withCount completion:^(TCHResult *result, NSArray<TCHMessage *> *messages) {
                if (result.isSuccessful) {
                    resolve([RCTConvert TCHMessages:messages]);
                }
                else {
                    reject(@"get-message-error", @"Error occured while attempting to getMessagesBefore.", result.error);
                }
            }];
        }
        else {
            reject(@"get-message-error", @"Error occured while attempting to getMessagesBefore.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getMessagesAfter, channelSid:(NSString * __nonnull)channelSid index:(NSUInteger)index withCount:(NSUInteger)withCount get_message_after_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages getMessagesAfter:index withCount:withCount completion:^(TCHResult *result, NSArray<TCHMessage *> *messages) {
                if (result.isSuccessful) {
                    resolve([RCTConvert TCHMessages:messages]);
                }
                else {
                    reject(@"get-message-error", @"Error occured while attempting to getMessagesAfter.", result.error);
                }
            }];
        }
        else {
            reject(@"get-message-error", @"Error occured while attempting to getMessagesAfter.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getMessage, channelSid:(NSString * __nonnull)channelSid index:(NSNumber * __nonnull)index message_index_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages messageWithIndex:index completion:^(TCHResult *result, TCHMessage *message) {
                if (result.isSuccessful) {
                    resolve([RCTConvert TCHMessage:message]);
                }
                else {
                    reject(@"get-message-error", @"Error occured while attempting to getMessage.", result.error);
                }
            }];
        }
        else {
            reject(@"get-message-error", @"Error occured while attempting to getMessage.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(messageForConsumptionIndex, channelSid:(NSString * __nonnull)channelSid index:(NSNumber * __nonnull)index consumption_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages messageForConsumptionIndex:index completion:^(TCHResult *result, TCHMessage *message) {
                if (result.isSuccessful) {
                    resolve([RCTConvert TCHMessage:message]);
                }
                else {
                    reject(@"get-message-error", @"Error occured while attempting to getMessageForConsumptionIndex.", result.error);
                }
            }];
        }
        else {
            reject(@"get-message-error", @"Error occured while attempting to getMessage.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(setLastConsumedMessageIndex, channelSid:(NSString * __nonnull)channelSid set_index:(NSNumber * __nonnull)index setLastConsumedMessageIndex_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages setLastConsumedMessageIndex:index];
            resolve(@[@TRUE]);
        }
        else {
            reject(@"set-last-consumed-message-error", @"Error occured while attempting to setLastConsumedMessageIndex.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(advanceLastConsumedMessageIndex, channelSid:(NSString * __nonnull)channelSid advance_index:(NSNumber * __nonnull)index advanceLastConsumedMessageIndex:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages advanceLastConsumedMessageIndex:index];
            resolve(@[@TRUE]);
        }
        else {
            reject(@"advanceLastConsumedMessageIndex-error", @"Error occured while attempting to advanceLastConsumedMessageIndex.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(setAllMessagesConsumed, channelSid:(NSString * __nonnull)channelSid setAllMessagesConsumed:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages setAllMessagesConsumed];
            resolve(@[@TRUE]);
        }
        else {
            reject(@"setAllMessagesConsumed-error", @"Error occured while attempting to setAllMessagesConsumed.", result.error);
        }
    }];
}

#pragma mark Message Instance Methods

RCT_REMAP_METHOD(updateBody, channelSid:(NSString * __nonnull)channelSid index:(NSNumber * __nonnull)index body:(NSString * __nonnull)body update_message_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages messageWithIndex:index completion:^(TCHResult *result, TCHMessage *message) {
                if (result.isSuccessful) {
                    [message updateBody:body completion:^(TCHResult *result) {
                        if (result.isSuccessful) {
                            resolve(@[@TRUE]);
                        }
                        else {
                            reject(@"update-message-error", @"Error occured while attempting to update the body of the message.", result.error);
                        }
                    }];
                }
                else {
                    reject(@"update-message-error", @"Error occured while attempting to update the body of the message.", result.error);
                }
            }];
        }
        else {
            reject(@"update-message-error", @"Error occured while attempting to update the body of the message.", result.error);
        }
    }];
}


RCT_REMAP_METHOD(setAttributes, channelSid:(NSString * __nonnull)channelSid index:(NSNumber * __nonnull)index attributes:(NSDictionary * __nonnull)attributes set_attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [self loadMessagesFromChannelSid:channelSid :^(TCHResult *result, TCHMessages *messages) {
        if (result.isSuccessful) {
            [messages messageWithIndex:index completion:^(TCHResult *result, TCHMessage *message) {
                if (result.isSuccessful) {
                    [message setAttributes:attributes completion:^(TCHResult *result) {
                        if (result.isSuccessful) {
                            resolve(@[@TRUE]);
                        }
                        else {
                            reject(@"set-attributes-error", @"Error occured while attempting to set attributes of the message.", result.error);
                        }
                    }];
                }
                else {
                    reject(@"set-attributes-error", @"Error occured while attempting to set attributes of the message.", result.error);
                }
            }];
        }
        else {
            reject(@"set-attributes-error", @"Error occured while attempting to set attributes of the message.", result.error);
        }
    }];
}

@end
