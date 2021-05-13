//
//  ImageHelper.m
//  Mosaic
//
//  Created by zeng on 2021/5/13.
//

#import "ImageHelper.h"
#import "NSString+ext.h"

@implementation ImageHelper


- (UIImage *)readRect:(UIImage *)image  row:(NSInteger)row rect:(CGRect)cropRect {
    int space = 4;

    size_t imagebitsPerRow = cropRect.size.width * space;
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height =  row;//CGImageGetHeight(souceimageRef);
    size_t bits = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    int alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    CGDataProviderRef provideRef = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(provideRef);
    NSInteger lenght1 = width * space * row;// (int)CFDataGetLength(soucedataRef);
    CGSize size = cropRect.size;
    int lenght2 =  size.width * size.height * space;
    CFRange range = CFRangeMake(lenght1, lenght2);
    unsigned char *mosBuffer = malloc(lenght2);
    CFDataGetBytes(dataRef, range, mosBuffer);

    CFRange backRange = CFRangeMake(0, lenght1);
    unsigned char *aBuffer = malloc(lenght1);
    CFDataGetBytes(dataRef, backRange, aBuffer);

    CGContextRef moscontextRef = CGBitmapContextCreate(mosBuffer,
                                                       size.width, size.height,
                                                       bits, imagebitsPerRow, colorSpace, alphaInfo);
    CGContextRef contextRef = CGBitmapContextCreate(aBuffer, width, height, bits, bitsPerRow, colorSpace, alphaInfo);
    CGColorSpaceRelease(colorSpace);

//    //转换uiimage
    CGImageRef backImageRef = CGBitmapContextCreateImage(contextRef);
    CGImageRef cropbackImageRef = CGBitmapContextCreateImage(moscontextRef);
    UIImage *backImage = [UIImage imageWithCGImage:backImageRef
                                             scale:[UIScreen mainScreen].scale
                                       orientation:image.imageOrientation];
    
    UIImage *mosImage = [UIImage imageWithCGImage:cropbackImageRef
                                             scale:[UIScreen mainScreen].scale
                                       orientation:image.imageOrientation];
    //记得要释放
    
    CFRelease(moscontextRef);
    CFRelease(contextRef);
    CFRelease(dataRef);
    CFRelease(backImageRef);
    CFRelease(cropbackImageRef);
    
    CGFloat w1 = width;// CGImageGetWidth(backImageRef);
    CGFloat h1 = height;// CGImageGetHeight(backImageRef);
//    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
    [backImage drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
    [mosImage drawInRect:cropRect];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
//
    
//    self.image2.image = resultImg;
    return resultImg;
}


- (void)readData:(UIImage *)image {
    CGImageRef imageRef = image.CGImage;

    [self readCGData:imageRef];
}
- (void)readCGData:(CGImageRef)imageRef {
    if (imageRef == nil) {
        return;
    }

    CGDataProviderRef provideRef = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(provideRef);
    UInt8 *pixelBuf = (UInt8 *)CFDataGetMutableBytePtr((CFMutableDataRef)dataRef);
    
    NSMutableString *ms = [@"" mutableCopy];
    for (int i = 0; i < 440; i+=4) {//注意:每个像素有4个颜色通道 故i+=4  !!!
        //修改原始像素RGB数据
        int offEndsetR = i;
        int red   = pixelBuf[offEndsetR];
//        NSLog(@"%i, ", red);

        if (red > 100) {
            [ms appendFormat:@"1"];
        }
        else {
            [ms appendFormat:@"0"];
        }

    }
    CFRelease(dataRef);

//    NSLog(@"%@", ms);
    NSString *headers = [ms substringWithRange:NSMakeRange(0, 14)];
    NSString *userid = [ms substringWithRange:NSMakeRange(14, 16)];
    NSString *row = [ms substringWithRange:NSMakeRange(30, 16)];

    NSString *rx = [ms substringWithRange:NSMakeRange(46, 16)];
    NSString *ry = [ms substringWithRange:NSMakeRange(62, 16)];
    NSString *rw = [ms substringWithRange:NSMakeRange(78, 16)];
    NSString *rh = [ms substringWithRange:NSMakeRange(94, 16)];
    
    NSInteger header = [NSString getDecimalByBinary:headers];
    NSInteger r = [NSString getDecimalByBinary:row];
    NSInteger u = [NSString getDecimalByBinary:userid];

    NSInteger x = [NSString getDecimalByBinary:rx];
    NSInteger y = [NSString getDecimalByBinary:ry];
    NSInteger w = [NSString getDecimalByBinary:rw];
    NSInteger h = [NSString getDecimalByBinary:rh];
    

    self.header = header;
    self.row = r;
    self.userID = u;
    
    self.rect = CGRectMake(x, y, w, h);



    
}


@end
