//
//  ImageTableViewCell.m
//  Thread
//
//  Created by zeng on 2020/11/17.
//

#import "ImageTableViewCell.h"

@interface ImageTableViewCell()

@property(nonatomic, strong) UIImageView *thumbImageView;

@end

@implementation ImageTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbImageView  = [[UIImageView alloc] init];
        self.thumbImageView.frame = self.contentView.bounds;

        [self.contentView addSubview:self.thumbImageView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbImageView.frame = self.contentView.bounds;
}



- (void)setImageWithName:(NSString *)name {
    [self rendererImageWithName: name];
}

- (void)setPlaceholderImageWithName:(NSString *)name {
    self.thumbImageView.image = [UIImage imageNamed:@""];
}

- (void)rendererImageWithName:(NSString *)name {
//    __block UIImage *image = [[UIImage alloc] initWithContentsOfFile:[YYImage imageNameStr:name]];
//    
////    dispatch_queue_t queus = dispatch_queue_create("test.att", DISPATCH_QUEUE_CONCURRENT);
//    YYDispatchQueuePool *pool = [[YYDispatchQueuePool alloc] initWithName:@"image.renderer" queueCount:3 qos:NSQualityOfServiceBackground];
//    dispatch_queue_t queue = [pool queue];
//    NSLog(@"%@", queue);
//    
//    dispatch_async(queue, ^{
////        UIImage *img = [[RendererPipeline shareInstance] addRenderer:image key:name];
//        [[RendererPipeline shareInstance] renderer:image imageView:self.thumbImageView key:name];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
////            self.thumbImageView.image = img;
//        });
//    });
}


- (void)setImageWithName2:(NSString *)name {

//    self.thumbImageView.image = [UIImage imageNamed:@""];
//    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
//    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[YYImage imageNameStr:name]];
//    __block UIImage *img = nil;
//
//    CGSize size = CGSizeMake(width, (width * image.size.height) / image.size.width);
//
//    CGSize imageSize = CGSizeMake(size.width/2, size.height/2);
//    imageSize = CGSizeMake(size.width * 4/5, size.height * 4/5);
//    __block CGRect rect = CGRectMake(0, 0, width , size.height);
//    rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//
//    dispatch_queue_t queus = dispatch_queue_create("test.att", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queus, ^{
//        img = [[RendererManager shareInstance] getImageForKey:name];
//        if (!img) {
//            UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:imageSize];
//            img = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
//                [image drawInRect:rect];
//            }];
//            [[RendererManager shareInstance] addRendererDictImage:img forKey:name];
//            NSLog(@"%.0f, %.0f, %.1f", imageSize.width, imageSize.height, (imageSize.width * imageSize.height *4) / 1024/ 1024 );
//            NSLog(@"count：%li ", (long)[[RendererManager shareInstance] count] );
//            NSLog(@"%@ 渲染完成", name);
//        }
//        else {
//            NSLog(@"已渲染");
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.thumbImageView.image = img;
//        });
//    });
    
}



@end
