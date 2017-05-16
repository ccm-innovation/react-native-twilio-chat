//
//  RCTTCHChannels.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 6/2/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTwilioChatChannels.h"
#import "RCTTwilioChatClient.h"
#import "RCTConvert+TwilioChatClient.h"
#import "RCTTwilioChatPaginator.h"
#import <React/RCTUtils.h>

@implementation RCTTwilioChatChannels

RCT_EXPORT_MODULE();

+ (void)loadChannelFromSid:(NSString *)sid :(void (^)(TCHResult *result, TCHChannel *channel))completion {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
    [[client channelsList] channelWithSidOrUniqueName:sid completion:completion];
}

#pragma mark Channel Methods

RCT_REMAP_METHOD(getUserChannels, userChannels_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
    [[client channelsList] userChannelDescriptorsWithCompletion:^(TCHResult *result, TCHChannelDescriptorPaginator *paginator) {
        if (result.isSuccessful) {
            NSString *uuid = [RCTTwilioChatPaginator setPaginator:paginator];
            resolve(@{
                      @"sid":uuid,
                      @"type": @"ChannelDescriptor",
                      @"paginator": [RCTConvert TCHChannelDescriptorPaginator:paginator]
                      });

        }
        else {
            reject(@"get-user-channels-error", @"Error occured while attempting to get the user channels.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getPublicChannels, publicChannels_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
    [[client channelsList] publicChannelDescriptorsWithCompletion:^(TCHResult *result, TCHChannelDescriptorPaginator *paginator) {
        if (result.isSuccessful) {
            NSString *uuid = [RCTTwilioChatPaginator setPaginator:paginator];
            resolve(@{
                      @"sid":uuid,
                      @"type": @"ChannelDescriptor",
                      @"paginator": [RCTConvert TCHChannelDescriptorPaginator:paginator]
                      });

        }
        else {
            reject(@"get-public-channels-error", @"Error occured while attempting to get the public channels.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getSubscribedChannels, subscribedChannels_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
  NSArray<TCHChannel *>* channels = [[client channelsList] subscribedChannels];
  resolve([RCTConvert TCHChannels:channels]);
}


RCT_REMAP_METHOD(createChannel, options:(NSDictionary *)options create_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
  [[client channelsList] createChannelWithOptions:options completion:^(TCHResult *result, TCHChannel *channel) {
    if (result.isSuccessful) {
      resolve([RCTConvert TCHChannel:channel]);
    }
    else {
      reject(@"create-error", @"Error occured while creating a new channel.", result.error);
    }
  }];
}

RCT_REMAP_METHOD(getChannel, sidOrUniqueName:(NSString *)sidOrUniqueName sid_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  TwilioChatClient *client = [[RCTTwilioChatClient sharedManager] client];
    [[client channelsList] channelWithSidOrUniqueName:sidOrUniqueName completion:^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            resolve([RCTConvert TCHChannel:channel]);
        }
        else {
            reject(@"not-found", [NSString stringWithFormat:@"Channel could not be found with sid/uniquieName: %@.", sidOrUniqueName], result.error);
        }
    }];
}

#pragma mark Channel Instance Methods

RCT_REMAP_METHOD(setAttributes, sid:(NSString *)sid attributes:(NSDictionary *)attributes attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel setAttributes:attributes completion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"set-attributes-error", @"Error occurred while attempting to setAttributes on channel.", result.error);
                }
            }];
        }
        else {
            reject(@"set-attributes-error", @"Error occurred while attempting to setAttributes on channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(setFriendlyName, sid:(NSString *)sid friendlyName:(NSString *)friendlyName attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel setFriendlyName:friendlyName completion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"set-friendlyName-error", @"Error occured while attempting to setFriendlyName on channel.", result.error);
                }
            }];
        }
        else {
            reject(@"set-friendlyName-error", @"Error occured while attempting to setFriendlyName on channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(setUniqueName, sid:(NSString *)sid uniqueName:(NSString *)uniqueName attributes_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel setUniqueName:uniqueName completion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"set-friendlyName-error", @"Error occured while attempting to setUniqueName on channel.", result.error);
                }
            }];
        }
        else {
            reject(@"set-friendlyName-error", @"Error occured while attempting to setUniqueName on channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(join, sid:(NSString *)sid join_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel joinWithCompletion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"join-channel-error", @"Error occured while attempting to join the channel.", result.error);
                }
            }];
        }
        else {
            reject(@"join-channel-error", @"Error occured while attempting to join the channel.", result.error);
        }

    }];
}

RCT_REMAP_METHOD(declineInvitation, sid:(NSString *)sid decline_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel declineInvitationWithCompletion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"decline-invitation-error", @"Error occured while attempting to decline the invitation to join the channel.", result.error);
                }
            }];
        }
        else {
            reject(@"decline-invitation-error", @"Error occured while attempting to decline the invitation to join the channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(leave, sid:(NSString *)sid leave_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel leaveWithCompletion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"leave-channel-error", @"Error occured while attempting to leave the channel.", result.error);
                }
            }];
        }
        else {
            reject(@"leave-channel-error", @"Error occured while attempting to leave the channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(destroy, sid:(NSString *)sid destroy_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel destroyWithCompletion:^(TCHResult *result) {
                if (result.isSuccessful) {
                    resolve(@[@TRUE]);
                }
                else {
                    reject(@"destroy-channel-error", @"Error occurred while attempting to delete channel.", result.error);
                }
            }];
        }
        else {
            reject(@"destroy-channel-error", @"Error occurred while attempting to delete channel.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getUnconsumedMessagesCount, sid:(NSString *)sid unconsumedCount_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel getUnconsumedMessagesCountWithCompletion:^(TCHResult *result, NSUInteger count) {
                if (result.isSuccessful) {
                    resolve(@(count));
                }
                else {
                    reject(@"get-unconsumed-messages-count-error", @"Error occured while attempting to get unconsumed messages count.", result.error);
                }
             }];
        }
        else {
            reject(@"get-unconsumed-messages-count-error", @"Error occured while attempting to get unconsumed messages count.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getMessagesCount, sid:(NSString *)sid messagesCount_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel getMessagesCountWithCompletion:^(TCHResult *result, NSUInteger count) {
                if (result.isSuccessful) {
                    resolve(@(count));
                }
                else {
                    reject(@"get-messages-count-error", @"Error occured while attempting to get channel messages count.", result.error);
                }
             }];
        }
        else {
            reject(@"get-messages-count-error", @"Error occured while attempting to get channel messages count.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getMembersCount, sid:(NSString *)sid membersCount_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel getMembersCountWithCompletion:^(TCHResult *result, NSUInteger count) {
                if (result.isSuccessful) {
                    resolve(@(count));
                }
                else {
                    reject(@"get-members-count-error", @"Error occurred while attempting to get channel members count.", result.error);
                }
            }];

        }
        else {
            reject(@"get-members-count-error", @"Error occurred while attempting to get channel members count.", result.error);
        }
    }];
}



RCT_REMAP_METHOD(typing, sid:(NSString *)sid) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            [channel typing];
        }
    }];
}

RCT_REMAP_METHOD(getMember, sid:(NSString *)sid identity:(NSString *)identity member_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
        if (result.isSuccessful) {
            resolve([RCTConvert TCHMember:[channel memberWithIdentity:identity]]);
        }
        else {
            reject(@"get-member-error", @"Error occured while attempting to get channel member.", result.error);
        }
    }];
}

RCT_REMAP_METHOD(getChannel, sid:(NSString *)sid channel_resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [RCTTwilioChatChannels loadChannelFromSid:sid :^(TCHResult *result, TCHChannel *channel) {
    if (result.isSuccessful) {
      resolve([RCTConvert TCHChannel:channel]);
    }
    else {
      reject(@"get-full-channel-object-error", @"Error occured while attempting to get full channel object.", result.error);
    }
  }];
}



@end
