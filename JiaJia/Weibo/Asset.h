//
//  Asset.h
//  MYPhotoMac
//
//  Created by zeng on 2021/1/28.
//

#import <Foundation/Foundation.h>
#import <Photos/PHAsset.h>
NS_ASSUME_NONNULL_BEGIN

@interface Asset : NSObject
//Select ZGENERICASSET.ZFILENAME, ZGENERICASSET.ZDIRECTORY, ZGENERICASSET.ZHEIGHT,ZGENERICASSET.ZWIDTH, ZGENERICASSET.ZLATITUDE, ZGENERICASSET.ZLONGITUDE, ZGENERICASSET.ZCLOUDASSETGUID,
//ZGENERICASSET.ZUNIFORMTYPEIDENTIFIER, ZGENERICASSET.ZUUID,
//ZGENERICALBUM.ZTITLE
@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *zTitle;
@property (nonatomic, strong) NSString *zFileName;
@property (nonatomic, strong) NSString *zDirectory;
@property (nonatomic, assign) int zHeight;
@property (nonatomic, assign) double zDURATION;

@property (nonatomic, assign) int zWidth;
@property (nonatomic, assign) int zFavorite;
@property (nonatomic, assign) int isSync;
@property (nonatomic, assign) int zHidden;
@property (nonatomic, assign) float zLatitude;
@property (nonatomic, assign) float zLongitude;
@property (nonatomic, assign) int zKIND;
@property (nonatomic, assign) int zPLAYBACKSTYLE;
@property (nonatomic, assign) int zKINDSUBTYPE;
@property (nonatomic, assign) int zTRASHEDSTATE;
@property (nonatomic, strong) NSString *zCloudassetguid;
@property (nonatomic, strong) NSString *zUniformtypeidentifier;
@property (nonatomic, strong) NSString *zUUID;
@property (nonatomic, assign) NSTimeInterval zDATECREATED;
@property (nonatomic, assign) NSTimeInterval zMODIFICATIONDATE;
@property (nonatomic, assign) NSTimeInterval zTRASHEDDATE;

@property (nonatomic, strong) NSString *macPath;
@property (nonatomic, strong) NSString *thumbnailMacPath;
@property (nonatomic, strong) NSString *devicePath;
@property (nonatomic, strong) NSString *thumbnailDevicePath;

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) int cHeight;
@property (nonatomic, assign) int cWidth;

@property (nonatomic, assign) int minHeight;
@property (nonatomic, assign) int minWidth;


@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
