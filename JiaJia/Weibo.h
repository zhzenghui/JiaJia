//
//  Weibo.h
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Weibo : NSObject

@property (strong, nonatomic) User *user;

+ (instancetype)shareInstance;

- (void)reqSSOWeiboUser;

- (void)setWeiboUser:(NSDictionary *)user;
/// 获取user dict 给user对象赋值
- (void)getWeiboUser;

@end

NS_ASSUME_NONNULL_END
