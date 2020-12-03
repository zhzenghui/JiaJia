//
//  WBTimelineItem.m
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "WBTimelineItem.h"

@implementation WBTimelineItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"hasVisible" : @"hasvisible",
             @"previousCursor" : @"previous_cursor",
             @"uveBlank" : @"uve_blank",
             @"hasUnread" : @"has_unread",
             @"totalNumber" : @"total_number",
             @"maxID" : @"max_id",
             @"sinceID" : @"since_id",
             @"nextCursor" : @"next_cursor"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"statuses" : [WBStatus class]};
}
@end
