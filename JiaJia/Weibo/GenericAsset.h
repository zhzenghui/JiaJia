//
//  GenericAsset.h
//  MYPhotos
//
//  Created by zeng on 2021/4/3.
//

#import <Foundation/Foundation.h>
#import <Photos/PhotosTypes.h>
NS_ASSUME_NONNULL_BEGIN

@interface GenericAsset : NSObject

@property (nonatomic) PHAssetResourceType type;
@property (strong, nonatomic) NSURL *url;

@end

NS_ASSUME_NONNULL_END
