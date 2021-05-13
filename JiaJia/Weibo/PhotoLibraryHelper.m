//
//  PhotoLibraryHelper.m
//  JiaJia
//
//  Created by zeng on 2020/11/30.
//  Copyright © 2020 zeng. All rights reserved.
//

#import "PhotoLibraryHelper.h"
#import "GenericAsset.h"
#import "NSString+TimeExt.h"

static PhotoLibraryHelper *obj = nil;

@interface PhotoLibraryHelper() {
    int a; //成员变量
    NSArray *arr;//实力变量
}
@property(nonatomic, strong) PHAssetCollection *assetCollection;
@property(nonatomic, strong) PHImageRequestOptions *options;
//@property(nonatomic, strong) PHFetchResult *assets;
@property(nonatomic, strong) NSArray *assets;//属性变量


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
//    [self createCollection];
    a = 1;
    return self;
}

- (PHAssetCollection *)findAssetCollection:(NSString *)name {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"localizedTitle = %@", name];
    fetchOptions.predicate = p;
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    PHAssetCollection *createCollection = nil;
    if (collections.count != 0) {
        createCollection = collections.firstObject;
    }

    return createCollection;
}

- (void)createCollection:(NSString *)name completionHandler:(nullable void(^)(BOOL success, PHAssetCollection *assetCollection, NSError *__nullable error))completionHandler{
    //查询所有【自定义相册】
    
    PHAssetCollection *createCollection = [self findAssetCollection:name];
    if (createCollection == nil) {
        //当前对应的app相册没有被创建
        //创建一个【自定义相册】
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];

        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
//                创建的相册休息1s，等待系统响应，要不刚创建的相册无法写入资源
                PHAssetCollection *collection = [self findAssetCollection:name];
                completionHandler(true, collection, nil);
            }
            else {
                NSLog(@"%@", error);
                completionHandler(false, nil, error);
            }
        }];

    }
    else {
        NSLog(@"相册已存在");
        completionHandler(true, createCollection, nil);
    }
}

- (void)removeCollection:(NSString *)name completionHandler:(nullable void(^)(BOOL success,  NSString *info, NSError *__nullable error))completionHandler {
    PHAssetCollection *collection = [self findAssetCollection:name];
    if (collection != nil) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest deleteAssetCollections:@[collection]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
//                创建的相册休息1s，等待系统响应，要不刚创建的相册无法写入资源
                completionHandler(true, @"delete success", nil);
            }
            else {
                NSLog(@"%@", error);
                completionHandler(false, @"delete error", error);
            }
        }];
    }
    else {
        NSLog(@"相册不存在");
        completionHandler(true, @"album not fond", nil);
    }
}

- (PHFetchResult<PHAsset *> *)getAssets:(NSArray *)array {
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:array options:nil];
    return fetchResult;
}


- (void)addAssetCollection:(PHFetchResult<PHAsset *> *)objects assetCollection:(PHAssetCollection *)assetCollection completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler{
//    for (PHAsset *asset in objects) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *requestCollection = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [requestCollection addAssets:objects];
        }completionHandler:^(BOOL success, NSError*_Nullableerror) {
            NSLog(@"%@",success?@"保存成功":@"保存失败");
            NSLog(@"%@", _Nullableerror);
            completionHandler(success, _Nullableerror);
        }];
//    }
}


- (void)removeAssetCollection:(PHFetchResult<PHAsset *> *)objects assetCollection:(PHAssetCollection *)assetCollection  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            if (assetCollection) {
                NSLog(@"删除相册照片");
                PHAssetCollectionChangeRequest *requestCollection = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                [requestCollection removeAssets:objects];
            }
            else {
                NSLog(@"删除照片");
                [PHAssetChangeRequest deleteAssets:objects];
            }
        }completionHandler:^(BOOL success, NSError*_Nullableerror) {
            NSLog(@"%@",success?@"保存成功":@"保存失败");
            completionHandler(success, _Nullableerror);
        }];
}

- (void)favoriteAssetCollection:(PHFetchResult<PHAsset *> *)objects favite:(BOOL)favite completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler; {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSLog(@"收藏照片");
        for (PHAsset *asset in objects) {
            PHAssetChangeRequest *req = [PHAssetChangeRequest changeRequestForAsset:asset];
            req.favorite = favite;
        }
    }completionHandler:^(BOOL success, NSError*_Nullableerror) {
        NSLog(@"%@",success?@"保存成功":@"保存失败");
        completionHandler(success, _Nullableerror);
    }];
}

- (void)hiddenAssetCollection:(PHFetchResult<PHAsset *> *)objects hidden:(BOOL)hidden completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler; {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSLog(@"收藏照片");
        for (PHAsset *asset in objects) {
            PHAssetChangeRequest *req = [PHAssetChangeRequest changeRequestForAsset:asset];
            req.hidden = hidden;
        }
    }completionHandler:^(BOOL success, NSError*_Nullableerror) {
        NSLog(@"%@",success?@"保存成功":@"保存失败");
        completionHandler(success, _Nullableerror);
    }];
}


- (void)saveImages:(GenericAsset *)image completionHandler:(nullable void(^)(BOOL success,  PHAsset *asset, NSError *__nullable error))completionHandler {
    NSString *uuid = [NSString getUUID];
    if (image) {

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
//            options.uniformTypeIdentifier = uuid;
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:image.type
                                                                          fileURL:image.url
                                                                          options:options];

        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",@"保存失败");
                completionHandler(false, nil, error);

            } else {
                NSLog(@"%@",@"保存成功");
                PHAsset *asset = [self findAssetForUUID:uuid];
                completionHandler(true, asset, nil);
            }
        }];
    }
}
- (PHAsset *)findAssetForUUID:(NSString *)uuid {
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithLocalIdentifiers:@[uuid] options:nil];
    return [assetsFetchResults firstObject];
}

- (PHAsset *)latestAsset {
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return [assetsFetchResults firstObject];
}

- (NSArray<PHAsset *> *)getAssetIdentifyForDate:(NSDate *)date {
    /*
     1, Problem when first loading APP: Only the appropriate permissions will be obtained without responding to the method
     */
    //This handler is called every time you visit the album to check the authorization of the changed app
    //PHPhotoLibrary
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
         //code
            NSLog(@"dispatch_semaphore_signal");
            [self getAllPhotosFromAlbumForDate:date];
            dispatch_semaphore_signal(sema);

        }
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_semaphore_wait");
    return self.assets;
}

- (void)getAllPhotosFromAlbumForDate:(NSDate *)date {//Configuration is simple, but the parameters are more than the price.
    self.options= [[PHImageRequestOptions alloc] init];//Request Options Settings
//    self.options.resizeMode=PHImageRequestOptionsResizeModeExact;
//resizeMode custom settings for image size enumeration type*
// PHImageRequestOptionsResizeMode:*
//PHImageRequest Options ResizeModeNone = 0, // Keep the original size
//PHImageRequest Options Resize Model Fast, // Efficient, but does not guarantee that the size of the image is customized
//PHImageRequest Options ResizeModel Exact, // strictly according to custom size

   self.options.synchronous=YES;   //YES must be synchronous NO is not necessarily asynchronous
//  imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        /*
     PHImageRequestOptionsResizeModeNone // No Size Adjustment
     PHImageRequestOptionsResizeModeFast // Arranged by the system, the situation is uncertain: sometimes you set a lower size, according to the size you set, sometimes than
     PHImageRequestOptionsResizeModeExact// Guarantee accuracy to custom size: Precise premise here is to use PH Image Content Model AspectFill
     */

    //SimageOptions.version = PHImageRequest Options Version Current; //version iOS 8.0 after the image editing extension, you can get the original image or edited image according to the next enumeration.
    /*PHImageRequestOptionsVersion:
     PHImageRequestOptionsVersionCurrent = 0, //Current (Edited? Edited Graph: Original Graph)
     PHImageRequestOptionsVersionUnadjusted, //Edited drawings
     PHImageRequestOptionsVersionOriginal    //Original picture
     */

    //    imageOptions.networkAccessAllowed = YES; // Used to open iClould to download pictures
    //    Callback to download progress of imageOptions.progressHandler//iClould

//    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//In the case of imageOptions.synchronous = NO, is the final decision asynchronous?

//Container class
//    PHFetchResult *as = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    //Here option is to get the configuration of Collection, and I just set it to nil so that it can be used
   /*
//For example, sort resources by their creation time
         PHFetchOptions *options = [[PHFetchOptions alloc] init];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
         options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//Where: key is the property of the PHAsset class, which is a kvc
         PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    */
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    options.predicate = [NSPredicate predicateWithFormat:@"favorite == YES"];

//    NSDate *date1 = [NSDate dateWithString:@"2020-12-23T11:42:59+0800" format:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate > $DATE"];
    predicate = [predicate predicateWithSubstitutionVariables:
                 [NSDictionary dictionaryWithObject:date forKey:@"DATE"]];

    options.predicate = predicate;

    
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];

    CGSize size =CGSizeMake(50,50);//Custom image size changes are quite complex. Here's how
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PHAsset *asset in assetsFetchResults) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage*_Nullable result,NSDictionary*_Nullable info) {
     /*
             The size of the final image is determined by imageOptions.resizeMode (PHImageRequest Options) and PHImageContentMode, and of course, by the size we set.
             Priority
             PHImageRequestOptions > PHImageContentMode
             */
            //This handler is not executed on the main thread, so if you have UI updates, you have to add them manually to the main thread.
    //       dispatch_async(dispatch_get_main_queue(), ^{ //update UI  });

//    #Pragma If - [PH Image Request Options is Synchronous] returns NO (or options is nil), resultHandler may be called 1 or more times.... Asynchronous callbacks one or more times on this callback.
//    #Pragma If - [PH Image Request Options is Synchronous] returns YES, resultHandler will be called exactly once synchronization.
    //At first, I intended to save all the photos by data bar. But I found that the synchronous card UI was called back many times, and my array became double. So I had to use the task method cell for Item.
            
//            NSLog(@"%@", [asset.creationDate stringWithFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]);
            [array addObject:asset];
//            NSLog(@"%@", result);
        }];

    }
    self.assets = [array copy];
    
}




- (void)saveImages:(NSArray *)images {
    // 2.拥有一个【自定义相册】
    PHAssetCollection * assetCollection = self.assetCollection;

    
    for (NSData *image in images) {
        
        if (image) {
            NSError *error = nil;
            PHAssetChangeRequest *placeholder = nil;
            //   1. 保存所有图片
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
//                placeholder = [PHAssetCreationRequest creationRequestForAsset];
               [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:image options:options];
//                placeholder = [PHAssetChangeRequest creationRequestForAssetFromImage:image];

            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@",@"保存失败");
                } else {
                    NSLog(@"%@",@"保存成功");
                }
            }];
            
//
//            if (assetCollection == nil) {
//                NSLog(@"创建相册失败");
//            }
//            if (assetCollection != nil) {
//                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//                    PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//                    [requtes addAssets:@[placeholder]];
//                } error:&error];
//                if (error) {
//                    NSLog(@"保存相册失败");
//                } else {
//                    NSLog(@"保存相册成功");
//                }
//            }

        }
        
    }

}
@end
