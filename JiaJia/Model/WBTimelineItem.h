//
//  WBTimelineItem.h
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBTimelineItem : NSObject
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) NSArray *advertises;
@property (nonatomic, strong) NSString *gsid;
@property (nonatomic, assign) int32_t interval;
@property (nonatomic, assign) int32_t uveBlank;
@property (nonatomic, assign) int32_t hasUnread;
@property (nonatomic, assign) int32_t totalNumber;
@property (nonatomic, strong) NSString *sinceID;
@property (nonatomic, strong) NSString *maxID;
@property (nonatomic, strong) NSString *previousCursor;
@property (nonatomic, strong) NSString *nextCursor;
@property (nonatomic, strong) NSArray<WBStatus *> *statuses;
@end

NS_ASSUME_NONNULL_END
