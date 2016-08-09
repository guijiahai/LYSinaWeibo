//
//  LYWebViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/8.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYWebViewController.h"
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>

@interface LYWebViewController ()

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) UIBarButtonItem *goBackItem;
@property (nonatomic, strong) UIBarButtonItem *goForwardItem;
@property (nonatomic, strong) UIBarButtonItem *refreshItem;
@property (nonatomic, strong) UIBarButtonItem *stopItem;

@property (nonatomic, strong) NJKWebViewProgress *progress;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@end

@implementation LYWebViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LYBackgroundColor;

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - 44.0)];
//    _webView.delegate = self;
    [self.view addSubview:_webView];
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-44);
//    }];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_toolBar];
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    _goBackItem = [[UIBarButtonItem alloc] initWithTitle:@"←" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    _goForwardItem = [[UIBarButtonItem alloc] initWithTitle:@"→" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    _refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    _stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopLoading)];
    
    _toolBar.items = @[_goBackItem, _goForwardItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], _stopItem];
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 2)];
    [self.view addSubview:_progressView];
    
    _progress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progress;
    _progress.webViewProxyDelegate = self;
    ESWeakSelf
    _progress.progressBlock = ^(float progress) {
        ESStrongSelf
        [strongSelf.progressView setProgress:progress animated:YES];
    };
    
    if (_URL) {
        [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
    }
}

- (void)setURL:(NSURL *)URL {
    _URL = [URL copy];
    if (_webView) {
        [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _toolBar.items = @[_goBackItem, _goForwardItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], _stopItem];
    self.navigationItem.title = @"加载中";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
    _toolBar.items = @[_goBackItem, _goForwardItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], _refreshItem];
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad:webView];
}

- (void)goBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)goForward {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)refresh {
    if (!self.webView.isLoading) {
        [self.webView reload];
    }
}

- (void)stopLoading {
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
}



@end
