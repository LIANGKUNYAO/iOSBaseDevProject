//
//  HomeViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+KYLECategory.h"
#import "MJRefresh.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIImageView* headerView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景色
    //self.view.backgroundColor = UIColorFromHex(0xF0F0F0);
    //设置导航栏颜色
    //self.navigationController.navigationBar.barTintColor = UIColorFromHex(0xBE0A14);
    //self.navigationController.navigationBar.translucent = NO;
    //设置导航栏背景为空
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉导航条底部横线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //设置导航栏字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //self.title = @"首页";
    //直接设置导航栏标题
    self.navigationItem.title = @"首页";
    
    __weak __typeof__(self) weakSelf = self;
    self.contentView = [self getScrollContentViewWithBgColor:0xF0F0F0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.contentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(250);
    }];
    
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor blueColor]];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(800);
    }];
}

#pragma mark - UIs
//ScrollView
- (UIView *)getScrollContentViewWithBgColor:(int)bgColor{
    __weak __typeof__(self) weakSelf = self;
    
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
    UIColor *color = UIColorFromHexWithAlpha(0xBE0A14,y/100);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage jk_imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    
    __weak __typeof__(self) weakSelf = self;
    
//    if(y<0){
//        [_headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.view);
//            make.left.right.equalTo(weakSelf.contentView);
//            make.height.mas_equalTo(250-y);
//        }];
//    }else{
//        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.contentView);
//            make.left.right.equalTo(weakSelf.contentView);
//            make.height.mas_equalTo(250);
//        }];
//    }
}


-(UIImage *)imageWithBgColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
