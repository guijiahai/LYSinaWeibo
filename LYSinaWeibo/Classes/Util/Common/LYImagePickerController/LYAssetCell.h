//
//  LYAssetCell.h
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/6.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_Album;
extern NSString *const kCCellIdentifier_Asset;
extern NSString *const kCCellIdentifier_AssetCamera;

@class LYAssetModel, LYAlbumModel;

@interface LYAlbumCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *dotView;

@property (nonatomic, strong) LYAlbumModel *albumModel;

+ (CGFloat)cellHeight;

@end

@interface LYAssetCCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIButton *selectButton;

@property (nonatomic, strong) LYAssetModel *assetModel;
@property (nonatomic, assign) BOOL showMaskView;

@property (nonatomic, copy) void (^didSelectPhotoHandler)(LYAssetCCell *ccell);

+ (CGSize)ccellSize;

@end

@interface LYAssetCameraCCell : UICollectionViewCell

@end
