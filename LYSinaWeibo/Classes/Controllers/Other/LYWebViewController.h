//
//  LYWebViewController.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/8.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseViewController.h"
//#import <WebKit/WebKit.h>

@interface LYWebViewController : LYBaseViewController <UIWebViewDelegate>

@property (nonatomic, strong, readonly) UIWebView *webView;
//@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSURL *URL;

@end
