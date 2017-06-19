//
//  HomeViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+KYLECategory.h"
#import "CardView.h"
#import "QRHandlerViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIImageView* headerView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏标题，同时改变tabBar中的文字
    //self.title = @"首页123";
    //只设置导航栏标题
    [self.navigationItem setTitle:@"首页"];
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"qrScan"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemOnClick:)];
    [rBtn setTag:0];
    [self.navigationItem setRightBarButtonItem:rBtn];
    
    self.contentView = [self getScrollContentViewWithBgColor:0xF0F0F0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WeakSelf(weakSelf);
    [self.contentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(250);
    }];
    
    CardView *view = [[CardView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(8000);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setTranslucent:YES];
    //通过设置barStyle来改变statusBar的字体颜色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack]; //default UIBarStyleDefault
    //设置导航栏背景为空
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉导航条底部横线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //设置导航字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置导航按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - UIs
//ScrollView
- (UIView *)getScrollContentViewWithBgColor:(int)bgColor{
    
    WeakSelf(weakSelf);
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = UIColorFromHex(bgColor);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.view);
    }];
    scrollView.delegate = self;
    
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(scrollView);
        //留出部分冗余
        make.bottom.equalTo(scrollView).with.offset(-64);
        //水平方向不滚动
        make.width.equalTo(scrollView);
    }];
    return contentView;
}
//HeaderView
- (UIImageView *)headerView{
    if(!_headerView){
        _headerView = [[UIImageView alloc]init];
        [_headerView setImage:[UIImage imageNamed:@"bgRed"]];
        [_headerView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _headerView;
}


#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    
    //禁止向上延伸
    scrollView.bounces = (y <= 0) ? NO : YES;
    //向下时设置导航栏颜色
    UIColor *color = UIColorFromHexWithAlpha(0xBE0A14,y/100);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage jk_imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - Private Methods
- (void)barItemOnClick:(id)sender{
    switch([sender tag]) {
        case 0:{
            QRHandlerViewController *vc = [[QRHandlerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:{
            NSLog(@"unknown button");
        }
    }
}


#pragma mark - LifeCycle
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
