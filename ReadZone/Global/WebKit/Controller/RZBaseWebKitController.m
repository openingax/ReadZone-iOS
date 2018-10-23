//
//  RZBaseWebKitController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/22.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZBaseWebKitController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
#import "RZWebServerManager.h"

@interface RZBaseWebKitController ()
<
WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
UINavigationControllerDelegate
>

@property(nonatomic, strong) WKWebView *webView;
@property WKWebViewJavascriptBridge* bridge;

@end

@implementation RZBaseWebKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - DrawView
- (void)drawNavBar {
    [super drawNavBar];
}

- (void)drawView {
    self.navigationItem.title = self.navTitle;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    configuration.preferences.minimumFontSize = 10;
    configuration.preferences.javaScriptEnabled = YES;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavTotalHeight);
    }];
}

- (void)loadWebView {
    NSString *webDevelopStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kWebDevelopKey];
    if (Develop && [webDevelopStatus isEqualToString:@"1"]) {
        NSString *ipAddr = [[NSUserDefaults standardUserDefaults] objectForKey:kWebIPAddrKey];
        if (!ipAddr) ipAddr = @"192.168.1.25";
        
        NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080/%@.html", ipAddr, self.URL];
        NSLog(@"webView URL: %@", urlStr);
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        [self.webView loadRequest:request];
    } else {
        // 加载本地包
        
        if (![[RZWebServerManager shareInstance] isRunning]) {
            BOOL success = [[RZWebServerManager shareInstance] start];
            NSLog(@"webServer start: %@", @(success));
        }
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [documentPaths objectAtIndex:0];
        
        NSString *docPackagePath = [documentPath stringByAppendingString:@"asset/package.json"];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"asset" ofType:@""];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL needCopy = NO;
        
        if ([fileManager fileExistsAtPath:docPackagePath]) {
            
        } else {
            needCopy = YES;
        }
        
        if (needCopy) {
            NSString *topath = [documentPath stringByAppendingPathComponent:@"/asset"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:topath]) {
                [[NSFileManager defaultManager] removeItemAtPath:topath error:nil];
            }
            NSError *error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:topath error:&error];
            NSLog(@"复制到documentPath:%@",error);
        }
        
        NSUInteger port = [[RZWebServerManager shareInstance] port];
        NSString *path = [NSString stringWithFormat:@"http://localhost:%lu/Documents/asset/%@.html", (unsigned long)port, self.URL];
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
    
    // 后续如果做在线更新，那要加入第三方库 GCDWebServer（参照云米商城的做法）
}

@end
