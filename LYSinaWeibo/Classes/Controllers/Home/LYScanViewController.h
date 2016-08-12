//
//  LYScanViewController.h
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/10.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYScanViewController : UIViewController

- (void)openFlash:(BOOL)flag;
- (BOOL)isFlashOn;
- (BOOL)isFlashAvailable;

@end
