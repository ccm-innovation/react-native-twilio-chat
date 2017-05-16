//
//  RCTTwilioChatPaginator.h
//  RCTTwilioChat
//
//  Created by Brad Bumbalough on 12/2/16.
//  Copyright © 2016 Brad Bumbalough. All rights reserved.
//

#import <TwilioChatClient/TCHConstants.h>
#import <React/RCTBridgeModule.h>

@interface RCTTwilioChatPaginator : NSObject <RCTBridgeModule> {
    NSMutableDictionary *paginators;
}

@property (nonatomic, retain) NSMutableDictionary *paginators;

+ (id)sharedManager;
+ (NSString*)setPaginator:(id)paginator;

@end
