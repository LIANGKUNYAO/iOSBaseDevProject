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

@interface QRHandlerViewController ()<ScanViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) ScanView* scanView;
@end

@implementation QRHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    self.scanView = [[ScanView alloc]initWithFrame:self.view.bounds];
    self.scanView.delegate = self;
    [self.view addSubview:self.scanView];
}

#pragma mark - Delegates
- (void)scanView:(ScanView *)scanView ScanResult:(NSString *)result{
    [scanView stopScan];
    
    NSRange range = [result rangeOfString:RegularExpressionURL options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *urlString = [result substringWithRange:range];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *xmlData = [NSData dataWithContentsOfURL:url];
        NSString *xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
        // 异常处理
        if (![MFMailComposeViewController canSendMail]) {
            [scanView startScan];
        }else{
            MFMailComposeViewController *mailVc = [[MFMailComposeViewController alloc] init];
            // 设置邮件主题
            [mailVc setSubject:result];
            // 设置邮件内容
            [mailVc setMessageBody:xmlString isHTML:NO];
            // 设置收件人列表
            [mailVc setToRecipients:@[@"liangkunyao@hotmail.com"]];
            // 设置代理
            mailVc.mailComposeDelegate = self;
            // 显示控制器
            [self presentViewController:mailVc animated:YES completion:nil];
        }
    }
}
//Email发送Controller回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.scanView startScan];
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
