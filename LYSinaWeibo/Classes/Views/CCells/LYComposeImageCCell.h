//
//  LYComposeImageCCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCCellIdentifier_ComposeImage;

@interface LYComposeImageCCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, copy) void (^deleteImageBlock)(LYComposeImageCCell *ccell);

+ (CGSize)ccellSize;

@end
