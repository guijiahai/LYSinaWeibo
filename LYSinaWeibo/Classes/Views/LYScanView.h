//
//  LYScanView.h
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/10.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYScanView : UIView

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong, readonly) UILabel *prepareLabel;
@property (nonatomic, strong, readonly) UIButton *flashButton;

@property (nonatomic, assign) BOOL showFlashButton;     //default is no

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, copy) void (^cardButtonClickedBlock)();
@property (nonatomic, copy) BOOL (^flashButtonClickedBlock)();

- (void)prepareDeviceWithText:(NSString *)text;
- (void)stopToPrepareDevice;
- (void)beginScanAnimation;
- (void)stopScanAnimation;

+ (CGRect)rectOfInterestForAVCaputreMetadataOutputWithFrame:(CGRect)frame;

@end
