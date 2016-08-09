//
//  LYOAuthViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYOAuthViewController.h"
#import "AppDelegate.h"

@interface LYOAuthViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;


@end

@implementation LYOAuthViewController

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)loadView {
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"关闭" action:@selector(dismiss)];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", LY_App_Key, LY_Redirect_URI];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [self.webView loadRequest:request];
}

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(nullable SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : LYMainColor} forState:UIControlStateNormal];
    return item;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.absoluteString;
    if (![url hasPrefix:LY_Redirect_URI]) {
        return YES;
    } else {
        
        NSString *query = request.URL.query;
        NSMutableDictionary *queries = [NSMutableDictionary dictionary];
        NSArray *com = [query componentsSeparatedByString:@"&"];
        for (NSString *que in com) {
            NSArray *args = [que componentsSeparatedByString:@"="];
            if (args.count >= 2) {
                [queries setValue:args.lastObject forKey:args.firstObject];
            }
        }
        NSString *code = queries[@"code"];
        if (code) {
            DebugLog(@"授权成功");
            [self loadAccessTokenWithCode:code];
        } else {
            DebugLog(@"授权失败");
            [self dismissWithBlock:nil];
        }
        return NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

- (void)loadAccessTokenWithCode:(NSString *)code {
    NSString *path = @"/oauth2/access_token";
    NSDictionary *params = @{@"client_id" : LY_App_Key,
                             @"client_secret" : LY_App_Secret,
                             @"grant_type" : @"authorization_code",
                             @"code" : code,
                             @"redirect_uri" : LY_Redirect_URI};
    
    ESWeakSelf
    [[LYNetworkTool sharedTool] requestPOSTWithPath:path parameters:params andBlock:^(id data, NSError *error) {
        ESStrongSelf
        [[LYLogin sharedLogin] loginWithData:data];
        [[LYLogin sharedLogin] loadUserInfoWithBlock:^(BOOL finished) {
            if (finished) {
                [strongSelf dismissWithBlock:^{
                    [(AppDelegate *)[UIApplication sharedApplication].delegate setupTabBarController];
                }];
            }
        }];
    }];
}

- (void)dismiss {
    [self dismissWithBlock:nil];
}

- (void)dismissWithBlock:(void (^)())block {
    [self dismissViewControllerAnimated:YES completion:block];
}

@end
