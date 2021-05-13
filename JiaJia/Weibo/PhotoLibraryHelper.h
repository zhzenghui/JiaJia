//
//  PhotoLibraryHelper.h
//  JiaJia
//
//  Created by zeng on 2020/11/30.
//  Copyright © 2020 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+YYAdd.h"
#import <Photos/Photos.h>
#import "GenericAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoLibraryHelper : NSObject

+ (instancetype)shareInstance;

// 创建相册
- (void)createCollection:(NSString *)name completionHandler:(nullable void(^)(BOOL success,  PHAssetCollection *assetCollection, NSError *__nullable error))completionHandler;

- (void)removeCollection:(NSString *)name completionHandler:(nullable void(^)(BOOL success,  NSString *info, NSError *__nullable error))completionHandler;


// 添加asset 到相册
- (void)addAssetCollection:(PHFetchResult<PHAsset *> *)objects assetCollection:(PHAssetCollection *)assetCollection completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

// 删除相册中的 asset
- (void)removeAssetCollection:(PHFetchResult<PHAsset *> *)objects assetCollection:(PHAssetCollection *)assetCollection  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

// 收藏
- (void)favoriteAssetCollection:(PHFetchResult<PHAsset *> *)objects favite:(BOOL)favite  completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;;

- (void)hiddenAssetCollection:(PHFetchResult<PHAsset *> *)objects hidden:(BOOL)hidden completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;



// 获取大于date创建时间的照片
- (NSArray<PHAsset *> *)getAssetIdentifyForDate:(NSDate *)date;
// 根据Identify 数组，获取assets
- (PHFetchResult<PHAsset *> *)getAssets:(NSArray *)array;
//获取最新一张图片
- (PHAsset *)latestAsset;

- (void)saveImages:(GenericAsset *)image completionHandler:(nullable void(^)(BOOL success,  PHAsset *asset, NSError *__nullable error))completionHandler;



- (void)saveImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
