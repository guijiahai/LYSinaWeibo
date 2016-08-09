//
//  LYAssetModel.m
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/6.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYAssetModel.h"

@implementation LYAssetModel

static NSMapTable<NSString *, LYAssetModel *> *sharedMapTable;

+ (void)initialize {
    sharedMapTable = [NSMapTable strongToWeakObjectsMapTable];
}

+ (instancetype)modelWithAsset:(PHAsset *)asset {
    LYAssetModel *assetModel = [sharedMapTable objectForKey:asset.localIdentifier];
    if (!assetModel) {
        assetModel = [[self alloc] initWithAsset:asset];
        [sharedMapTable setObject:assetModel forKey:asset.localIdentifier];
    }
    return assetModel;
}

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.selected = NO;
        _asset = asset;
    }
    return self;
}

@end

@implementation LYAlbumModel

@synthesize title = _title;
@synthesize displayImage = _displayImage;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection {
    if (self = [super init]) {
        self.assetCollection = assetCollection;
        self.hasSelectedAssets = NO;
    }
    return self;
}

- (NSString *)title {
    if ([_title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    } else if ([_title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([_title isEqualToString:@"Favorites"]) {
        return @"个人收藏";
    } else if ([_title isEqualToString:@"Screenshots"]) {
        return @"屏幕截图";
    } else if ([_title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([_title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([_title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    return _title;
}

- (void)setAssetCollection:(PHAssetCollection *)assetCollection {
    _assetCollection = assetCollection;
    _title = _assetCollection.localizedTitle;
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:_assetCollection options:nil];
    NSMutableArray *assetModels = [NSMutableArray arrayWithCapacity:result.count];
    for (PHAsset *asset in result) {
        LYAssetModel *model = [LYAssetModel modelWithAsset:asset];
        [assetModels addObject:model];
    }
    _assetModels = [assetModels copy];
}

//- (void)checkWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets {
//    if (!selectedAssets || selectedAssets.count <= 0) {
//        return;
//    }
//    for (LYAssetModel *model in self.assetModels) {
//        if ([selectedAssets containsObject:model.asset]) {
//            model.selected = YES;
//            [self.selectedAssetModels addObject:model];
//        } 
//    }
//}

@end


@implementation LYImageManager

+ (CGFloat)imageScale {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return 1.5;
    } else {
        return MIN(2, [UIScreen mainScreen].scale);
    }
}

+ (NSArray *)fetchAlbumModels {
    
    NSMutableArray *array = [NSMutableArray array];
    
    PHFetchResult<PHAssetCollection *> *result = nil;
    
    result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in result) {
        LYAlbumModel *model = [[LYAlbumModel alloc] initWithAssetCollection:collection];
        if ([model.assetCollection.localizedTitle isEqualToString:@"Camera Roll"]) {
            [array addObject:model];
            continue;
        }
        if (model.assetModels.count > 0) {
            [array addObject:model];
        }
    }
    result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in result) {
        LYAlbumModel *model = [[LYAlbumModel alloc] initWithAssetCollection:collection];
        if ([model.assetCollection.localizedTitle isEqualToString:@"Camera Roll"]) {
            [array addObject:model];
            continue;
        }
        if (model.assetModels.count > 0) {
            [array addObject:model];
        }
    }
    
    return [array copy];
}

+ (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *image, NSDictionary *info, BOOL degraded))resultHandler {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL finished = !([info[PHImageCancelledKey] boolValue] || info[PHImageErrorKey]);
        if (finished && result) {
            resultHandler(result, info, [info[PHImageResultIsDegradedKey] boolValue]);
        }
        
        if (info[PHImageResultIsInCloudKey] && !result) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [self scaleImage:resultImage toSize:targetSize];
                if (resultImage && resultHandler) {
                    resultHandler(resultImage, info, [info[PHImageResultIsDegradedKey] boolValue]);
                }
            }];
        }
    }];
    return requestID;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:(CGRect){0, 0, size}];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

@end
