//
//  LYScanResultViewController.m
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/11.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LYScanResultViewController ()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation LYScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"扫描结果";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultBackItemWithTitle:@"返回" target:self action:@selector(goBack)];
    
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.font = [UIFont systemFontOfSize:16];
    self.resultLabel.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
    [self.view addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(50);
    }];
    
    if (self.metadataObject) {
        self.resultLabel.text = self.metadataObject.stringValue;
    } else if (self.messageString) {
        self.resultLabel.text = self.messageString;
    }
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithWhite:217.0/255 alpha:1];
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.resultLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1.0);
    }];
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.textColor = [UIColor grayColor];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.numberOfLines = 0;
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
    }];

    self.stateLabel.text = @"当前扫描结果并非微博提供，如果使用请谨慎";
}

- (void)goBack {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2) {
        UIViewController *toViewController = viewControllers[viewControllers.count - 3];
        [self.navigationController popToViewController:toViewController animated:YES];
    }
}


@end
