//
//  WebViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/9.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    if (!_bridge) {
        self.view.backgroundColor = UIColorFromHex(0xF7F7F7);
        
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:webView];
        
        //[WebViewJavascriptBridge enableLogging];
        
        //Create a javascript bridge for the given web view.
        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
        [_bridge setWebViewDelegate:self];
        
        //Register a OC handler
        [self.bridge registerHandler:@"getUserId" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"JS REQUEST: %@", data);
            if (responseCallback) {
                responseCallback(@{@"userId": @"123456"});
            }
        }];
        
        //Call a JS handler
        [self.bridge callHandler:@"showMyName"];
        
        [self renderButtons:webView];
        [self loadPage:webView];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(0, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(90, 400, 100, 35);
    reloadButton.titleLabel.font = font;
    
    UIButton* safetyTimeoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [safetyTimeoutButton setTitle:@"Disable safety timeout" forState:UIControlStateNormal];
    [safetyTimeoutButton addTarget:self action:@selector(disableSafetyTimeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:safetyTimeoutButton aboveSubview:webView];
    safetyTimeoutButton.frame = CGRectMake(190, 400, 120, 35);
    safetyTimeoutButton.titleLabel.font = font;
}

- (void)disableSafetyTimeout {
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}

- (void)callHandler:(id)sender {
    [self.bridge callHandler:@"showMyName" data:@{@"name": @"kyle"} responseCallback:^(id responseData) {
        NSLog(@"JS RESPONESE: %@", responseData);
    }];
}

- (void)loadPage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

@end
