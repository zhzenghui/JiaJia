//
//  ImageHelper.h
//  Mosaic
//
//  Created by zeng on 2021/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageHelper : NSObject

@property(nonatomic, assign) NSInteger header;
@property(nonatomic, assign) NSInteger userID;
@property(nonatomic, assign) NSInteger row;

@property(nonatomic, assign) CGRect rect;

- (void)readCGData:(CGImageRef)imageRef;
- (void)readData:(UIImage *)image ;
- (UIImage *)readRect:(UIImage *)image  row:(NSInteger)row rect:(CGRect)cropRect;

@end

NS_ASSUME_NONNULL_END
