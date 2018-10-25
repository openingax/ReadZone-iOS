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
#import "RZWebKitManager.h"

@interface RZBaseWebKitController ()
<
WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
UINavigationControllerDelegate
>

@property(nonatomic, strong) WKWebView *webView;
@property WKWebViewJavascriptBridge *bridge;

@end

@implementation RZBaseWebKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
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
        
        if (@available(iOS 9.0, *)) {
            NSArray *types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
            NSSet *websiteDataTypes = [NSSet setWithArray:types];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
                [self.webView loadRequest:request];
            }];
        } else {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
            [self.webView loadRequest:request];
        }
        
        
    } else {
        // 加载本地包
        
        if (![[RZWebServerManager shareInstance] isRunning]) {
            BOOL success = [[RZWebServerManager shareInstance] start];
            NSLog(@"webServer start: %@", @(success));
        }
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [documentPaths objectAtIndex:0];
        
        NSString *docPackagePath = [documentPath stringByAppendingString:@"/asset/package.json"];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"asset" ofType:@""];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL needCopy = NO;
        
        if ([fileManager fileExistsAtPath:docPackagePath]) {
            
            NSDictionary *packageJSONContent = [RZWebKitManager dictionaryWithJSONFile:docPackagePath];
            NSString *docVersion = [packageJSONContent notNullObjectForKey:@"version"];
            
            NSString *bundlePackagePath = [bundlePath stringByAppendingPathComponent:@"package.json"];
            NSDictionary *bundlePackageContent = [RZWebKitManager dictionaryWithJSONFile:bundlePackagePath];
            NSString *bundleVersion = [bundlePackageContent notNullObjectForKey:@"version"];
            
            needCopy = bundleVersion.doubleValue > docVersion.doubleValue ? YES : NO;
            
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
            
            NSArray *types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
            NSSet *websiteDataTypes = [NSSet setWithArray:types];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                NSUInteger port = [[RZWebServerManager shareInstance] port];
                NSString *path = [NSString stringWithFormat:@"http://localhost:%lu/Documents/asset/%@.html", (unsigned long)port, self.URL];
                NSURL *url = [NSURL URLWithString:path];
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
                [self.webView loadRequest:request];
            }];
            
        } else {
            NSUInteger port = [[RZWebServerManager shareInstance] port];
            NSString *path = [NSString stringWithFormat:@"http://localhost:%lu/Documents/asset/%@.html", (unsigned long)port, self.URL];
            NSURL *url = [NSURL URLWithString:path];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            [self.webView loadRequest:request];
        }
    }
    
    // 后续如果做在线更新，那要加入第三方库 GCDWebServer（参照云米商城的做法）
}

- (void)addObserver {
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"URL"]) {
        
        //处理白屏问题
        NSURL *newUrl = [change objectForKey:NSKeyValueChangeNewKey];
        NSURL *oldUrl = [change objectForKey:NSKeyValueChangeOldKey];
        
        NSLog(@"newUrl:%@",newUrl);
        NSLog(@"oldUrl:%@",oldUrl);
        
        if ((newUrl == nil || [newUrl isEqual:[NSNull class]]) && !(oldUrl == nil || [oldUrl isEqual:[NSNull class]])) {
            NSLog(@"web reload");
            self.navigationItem.title = @"web reload";
            [self.webView reload];
        };
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationAction");
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    NSLog(@"didReceiveAuthenticationChallenge");
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) return;
    //    [self p_showError:error];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
