//
//  QRHandlerViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/13.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "QRHandlerViewController.h"
#import "ScanView.h"
#import <MessageUI/MessageUI.h>
#import "UIImage+KYLECategory.h"
#import "KyleURLProtocol.h"

#define MAILLIST @[@"liangkunyao@hotmail.com"]

@interface QRHandlerViewController ()<ScanViewDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate>
@property (nonatomic, strong) ScanView* scanView;
@property (nonatomic, strong) UIBarButtonItem* torchBtn;
@end

@implementation QRHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置视图从(0,0)开始，而非(0,64)，即使导航条是不透明的
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"扫一扫";
    UIImage *torchImg = [[UIImage imageNamed:@"torch_on"] imageWithScale:0.2];
    self.torchBtn = [[UIBarButtonItem alloc]initWithImage:torchImg style:UIBarButtonItemStylePlain target:self action:@selector(barItemOnClick:)];
    [self.torchBtn setTag:0];
    [self.navigationItem setRightBarButtonItem:self.torchBtn];
    
    self.scanView = [[ScanView alloc]initWithFrame:self.view.bounds scanSize:CGSizeMake(250, 250) initCallback:^(NSError *error) {
        [self showError:error];
    }];
    self.scanView.delegate = self;
    [self.view addSubview:self.scanView];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.scanView startScan];
    //[self.navigationController.navigationBar setTranslucent:NO];
    //通过设置barStyle来改变statusBar的字体颜色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault]; //default UIBarStyleDefault
    //设置导航栏背景为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    //去掉导航条底部横线
    [self.navigationController.navigationBar setShadowImage:nil];
    //设置导航字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置导航按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [NSURLProtocol registerClass:[KyleURLProtocol class]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [NSURLProtocol unregisterClass:[KyleURLProtocol class]];
}

#pragma mark - Delegates
- (void)scanView:(ScanView *)scanView scanResult:(NSString *)result{
    [scanView stopScan];
    [SVProgressHUD show];
    
    if ([result rangeOfString:RegularExpressionURL options:NSRegularExpressionSearch].location != NSNotFound) {
        NSRange urlRange = [result rangeOfString:RegularExpressionURL options:NSRegularExpressionSearch];
        NSString *urlString = [result substringWithRange:urlRange];
        
        BOOL useWebview = YES;
        if(useWebview){
            UIWebView* webView = [[UIWebView alloc] init];
            [self.view addSubview:webView];
            webView.delegate = self;
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
        }else{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
            [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                });
                [self sendEmailWithSubject:urlString message:htmlString recipients:MAILLIST];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                });
                [self showError:error];
            }];
        }
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无法识别的二维码格式" forKey:NSLocalizedDescriptionKey];
        NSString *BundleId = BundleValue(@"CFBundleIdentifier");
        NSError *error = [NSError errorWithDomain:BundleId code:-1 userInfo:userInfo];
        
        [self showError:error];
    }
}
//webview加载完成后的回调
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *JsToGetHTMLSource = @"document.body.innerHTML";
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:JsToGetHTMLSource];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    NSString *search = @"https://www.sgs.gov.cn/notice/query/queryEntInfoMain.do";
    NSString *mstr = webView.request.URL.absoluteString;
    NSRange substr = [mstr rangeOfString:search];
    if (substr.location == NSNotFound) {
        [self sendEmailWithSubject:webView.request.URL.absoluteString message:htmlString recipients:MAILLIST];
    }
}
//webview加载前的回调
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
//Email发送后回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods
- (void)sendEmailWithSubject:(NSString *)subject message:(NSString *)message recipients:(NSArray *)recipients{
    if (![MFMailComposeViewController canSendMail]) {
        [self.scanView startScan];
    }else{
        MFMailComposeViewController *mailVc = [[MFMailComposeViewController alloc] init];
        // 设置邮件主题
        [mailVc setSubject:subject];
        // 设置邮件内容
        [mailVc setMessageBody:message isHTML:NO];
        // 设置收件人列表
        [mailVc setToRecipients:recipients];
        // 设置代理
        mailVc.mailComposeDelegate = self;
        // 显示控制器
        [self presentViewController:mailVc animated:YES completion:nil];
    }
}
- (void)showError:(NSError *)error{
    if(error){
        NSString *errMsg = [error localizedDescription];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.scanView startScan];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self.scanView startScan];
    }
}
- (void)barItemOnClick:(id)sender{
    switch([sender tag]) {
        case 0:{
            [self.scanView startTorch];
            [self.torchBtn setImage:[[UIImage imageNamed:@"torch_off"] imageWithScale:0.2]];
            [self.torchBtn setTag:1];
            break;
        }
        case 1:{
            [self.scanView stopTorch];
            [self.torchBtn setImage:[[UIImage imageNamed:@"torch_on"] imageWithScale:0.2]];
            [self.torchBtn setTag:0];
            break;
        }
        default:{
            NSLog(@"unknown button");
        }
    }
}

#pragma mark - LifeCycles
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
