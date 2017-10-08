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
    [self.navigationController setNavigationBarHidden:YES];
    
    if (!self.bridge) {
        self.view.backgroundColor = UIColorFromHex(0xF7F7F7);
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [webView setBackgroundColor:UIColorFromHex(0xF7F7F7)];
        [self.view addSubview:webView];
        
        //[WebViewJavascriptBridge enableLogging];
        
        //Create a javascript bridge for the given web view.
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
        [self.bridge setWebViewDelegate:self];

        [self registerHandler];
        
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        [webView loadHTMLString:appHtml baseURL:baseURL];
        
        //    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //    [webView loadRequest:request];
        
        //Call a JS handler
        //[self.bridge callHandler:sender data:@{@"name": @"kyle"} responseCallback:^(id responseData) {
        //    NSLog(@"JS RESPONESE: %@", responseData);
        //}];
    }
}

- (void)registerHandler{
    //Register a OC handler
    [self.bridge registerHandler:@"navigationReturn" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


#pragma mark - Delegates
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

@end
