//
//  NSString+Ext.h
//  MYPhotoMac
//
//  Created by zeng on 2021/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Ext)

+ (NSString *)getUUID;


-(NSString *)getMMSSFromSS;

- (NSString *)getMD5;

@end

NS_ASSUME_NONNULL_END
