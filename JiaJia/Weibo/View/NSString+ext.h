//
//  NSString+ext.h
//  Mosaic
//
//  Created by zeng on 2021/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ext)

+ (NSString *)getHexByDecimal:(NSInteger)decimal;
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

@end

NS_ASSUME_NONNULL_END
