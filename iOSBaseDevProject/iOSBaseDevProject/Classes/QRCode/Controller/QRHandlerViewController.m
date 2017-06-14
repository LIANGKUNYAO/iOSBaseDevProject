//
//  QRHandlerViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/13.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "QRHandlerViewController.h"
#import "ScanView.h"

@interface QRHandlerViewController ()<ScanViewDelegate>

@end

@implementation QRHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    ScanView *scanView = [[ScanView alloc]initWithFrame:self.view.bounds];
    scanView.delegate = self;
    [self.view addSubview:scanView];
}

#pragma mark - Delegates
- (void)scanView:(ScanView *)scanView ScanResult:(NSString *)result{
    [scanView stopScan];
    
    NSRange range = [result rangeOfString:RegularExpressionURL options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSLog(@"%@",result);
        [scanView startScan];
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
