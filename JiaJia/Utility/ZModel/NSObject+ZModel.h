//
//  NSObject+ZModel.h
//  JiaJia
//
//  Created by zeng on 2020/11/27.
//  Copyright © 2020 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(ZModel)

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic;

+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
