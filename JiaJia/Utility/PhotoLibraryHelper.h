//
//  PhotoLibraryHelper.h
//  JiaJia
//
//  Created by zeng on 2020/11/30.
//  Copyright © 2020 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoLibraryHelper : NSObject

+ (instancetype)shareInstance;

- (void)saveImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
