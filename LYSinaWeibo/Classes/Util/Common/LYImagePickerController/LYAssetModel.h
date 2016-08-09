//
//  LYAssetModel.h
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/6.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYAssetModel : NSObject

/*
 如果两个asset的localIdentifier相同，那么会返回同一个model
 之所以这样，是希望共享selected字段，防止图片被重复选择
 */
+ (instancetype)modelWithAsset:(PHAsset *)asset;

@property (nonatomic, readonly) PHAsset *asset;
@property (nonatomic, getter=isSelected) BOOL selected;

@end

@interface LYAlbumModel : NSObject

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) UIImage *displayImage;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray<LYAssetModel *> *assetModels;

@property (nonatomic, assign) BOOL hasSelectedAssets;   //default is no

- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection;

@end

@interface LYImageManager : NSObject

+ (CGFloat)imageScale;

+ (NSArray *)fetchAlbumModels;
+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *image, NSDictionary *info, BOOL degraded))resultHandler;

@end

NS_ASSUME_NONNULL_END