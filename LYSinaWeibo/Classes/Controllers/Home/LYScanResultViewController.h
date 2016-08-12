//
//  LYScanResultViewController.h
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/11.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVMetadataMachineReadableCodeObject;

@interface LYScanResultViewController : UIViewController

@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadataObject;
@property (nonatomic, strong) NSString *messageString;

@end
