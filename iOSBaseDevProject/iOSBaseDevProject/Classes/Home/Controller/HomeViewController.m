//
//  HomeViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+KYLECategory.h"
#import "KyleCollectionView.h"
#import "QRHandlerViewController.h"
#import "FinanceInfo.h"
#import "FinanceCellView.h"

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
    UIImage *rBtnImage = [[UIImage imageNamed:@"qrScan"] imageWithSize:SquareSize20];
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc]initWithImage:rBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(barItemOnClick:)];
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
    
    KyleCollectionView *financeView = [[KyleCollectionView alloc]initWithFrame:CGRectZero];
    [financeView.layout setItemSize:CGSizeMake(110, 90)];
    [financeView.layout setMinimumLineSpacing:10];
    [financeView.layout setSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [financeView.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [financeView setShowsVerticalScrollIndicator:NO];
    [financeView setShowsHorizontalScrollIndicator:NO];
    [financeView setCellClass:[FinanceCellView class]];
    [financeView setViewData:[self getFinanceData]];
    [financeView setDidSelectItem:^(NSIndexPath *indexPath){
        NSLog(@"%ld",(long)indexPath.row);
    }];
    [financeView setWillDisplayCell:^(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath, NSArray<__kindof NSArray *> *viewData){
        FinanceInfo *model = [[viewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [(FinanceCellView *)cell setCellTitle:model.title tags:model.tags withRate:model.rate];
    }];
    [self.contentView addSubview:financeView];
    [financeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(110);
        make.bottom.equalTo(weakSelf.contentView);
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
    
    [self.tabBarController.tabBar setHidden:NO];
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
        make.bottom.equalTo(scrollView).with.offset(-64);   //留出部分冗余
        make.width.equalTo(scrollView);                     //水平方向不滚动
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
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

- (NSArray *)getFinanceData{
    NSMutableArray *financeArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *financeArray1 = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        FinanceInfo *model = [[FinanceInfo alloc]init];
        model.prodid = [NSString stringWithFormat:@"%d",i];
        model.title = [NSString stringWithFormat:@"产品%d",i];
        model.rate = @"3.50%";
        model.tags = @[@"增值",@"保本",@"爱国"];
        [financeArray1 addObject:model];
    }
    [financeArray addObject:financeArray1];
    return financeArray;
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
