//
//  WBNetworkStore.h
//  JiaJia
//
//  Created by zeng on 2020/11/29.
//  Copyright © 2020 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBTimelineItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBNetworkStore : NSObject

@property (strong, nonatomic) WBTimelineItem *timeLineItem;
@property (nonatomic, strong) NSURLRequest *pps_request;

+ (NSString *)changedNotification;

+ (instancetype)shareInstance;

- (void)getHome:(NSString *)sinceID maxID:(NSString *)maxID;
- (void)getUserTimeline:(NSString *)sinceID maxID:(NSString *)maxID;


@end

NS_ASSUME_NONNULL_END
