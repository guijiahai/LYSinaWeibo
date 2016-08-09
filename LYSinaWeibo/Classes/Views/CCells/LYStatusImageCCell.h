//
//  LYStatusImageCCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/11.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCCellIdentifier_LYStatusImage;

@interface LYStatusImageCCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIImageView *gifIcon;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) BOOL canLoadImage;

@property (nonatomic, copy) void (^imageDownloadFinished)(UIImage *image, NSString *url);

@end
