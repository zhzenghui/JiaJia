//
//  PhotoLibraryHelper.m
//  JiaJia
//
//  Created by zeng on 2020/11/30.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "PhotoLibraryHelper.h"
#import <Photos/Photos.h>

static PhotoLibraryHelper *obj = nil;

@interface PhotoLibraryHelper()
@property(nonatomic, strong) PHAssetCollection *assetCollection;
@end

@implementation PhotoLibraryHelper

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[PhotoLibraryHelper alloc] init];
    });
    return obj;
}

- (id)init {
    self = [super init];
    [self createCollection];
    return self;
}

- (void)createCollection {
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
    //查询所有【自定义相册】
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHAssetCollection *createCollection = nil;
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        //当前对应的app相册没有被创建
        //创建一个【自定义相册】
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
            //创建一个【自定义相册】
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        } error:&error];

    }
    self.assetCollection = createCollection;
}


- (void)saveImages:(NSArray *)images {
    
    
    for (UIImage *image in images) {
        
        
        NSError *error = nil;
        __block PHAssetChangeRequest *placeholder = nil;
        //   1. 保存所有图片
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            placeholder = [PHAssetChangeRequest creationRequestForAssetFromImage:image];

        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",@"保存失败");
            } else {
                NSLog(@"%@",@"保存成功");
            }
        }];
        
        
        // 2.拥有一个【自定义相册】
        PHAssetCollection * assetCollection = self.assetCollection;
        if (assetCollection == nil) {
            NSLog(@"创建相册失败");
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [requtes addAssets:@[placeholder]];
        } error:&error];
        if (error) {
            NSLog(@"保存图片失败");
        } else {
            NSLog(@"保存图片成功");
        }
        
    }

}
@end
