//
//  HomeViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import "UIImage+KYLECategory.h"
#import "KyleCollectionView.h"
#import "QRHandlerViewController.h"

#import "FinanceCellView.h"
#import "FinanceInfo.h"
#import "MenuCellView.h"
#import "MenuInfo.h"

#define ITEMPERLINE 4

@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headerView;
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
    
    WeakSelf(weakSelf);
    self.scrollView = [self getScrollContentViewWithBgColor:0xF0F0F0];
    
    UIView *contentView = [[UIView alloc]init];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(weakSelf.scrollView);
        make.bottom.equalTo(weakSelf.scrollView).with.offset(-64);   //留出部分冗余
        make.width.equalTo(weakSelf.scrollView);                     //水平方向不滚动
    }];
    
    [contentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(250);
    }];
    
    //推介信息
    KyleCollectionView *financeView = [[KyleCollectionView alloc]initWithFrame:CGRectZero];
    [financeView setBackgroundColor:[UIColor whiteColor]];
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
    [contentView addSubview:financeView];
    [financeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(110);
    }];
    
    //菜单信息
    KyleCollectionView *MenuView = [[KyleCollectionView alloc]initWithFrame:CGRectZero];
    [MenuView setBackgroundColor:[UIColor clearColor]];
    [MenuView setScrollEnabled:NO];
    [MenuView.layout setItemSize:CGSizeMake((SCREEN_WIDTH-ITEMPERLINE+1)/ITEMPERLINE, 82)];
    [MenuView.layout setMinimumLineSpacing:1];
    [MenuView.layout setMinimumInteritemSpacing:1];
    [MenuView.layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [MenuView.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [MenuView setShowsVerticalScrollIndicator:NO];
    [MenuView setShowsHorizontalScrollIndicator:NO];
    [MenuView setCellClass:[MenuCellView class]];
    NSArray *menuViewData = [self getMenuData];
    NSArray *menuData = [menuViewData objectAtIndex:0];
    //向上取整 ceil()
    //向下取整 floor()
    NSUInteger lineNum = ceil((float)menuData.count/ITEMPERLINE);
    [MenuView setViewData:menuViewData];
    [MenuView setDidSelectItem:^(NSIndexPath *indexPath){
        NSLog(@"-->%ld -->%ld",(long)indexPath.section,(long)indexPath.row);
        [SVProgressHUD show];
        if (indexPath.section == 0 && indexPath.row == 0) {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UIViewController *vc = [[UIViewController alloc]init];
            vc.title = [NSString stringWithFormat:@"UITableCellView %zd",indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        }
    }];
    [MenuView setWillDisplayCell:^(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath, NSArray<__kindof NSArray *> *viewData){
        MenuInfo *model = [[viewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        UIImage *menuImg = [UIImage imageNamed:model.imgName];
        if (!menuImg) {
            menuImg = [UIImage imageNamed:@"defaultMenuItem"];
        }
        [(MenuCellView *)cell setCellTitle:model.menuName withImage:menuImg];
    }];
    [contentView addSubview:MenuView];
    [MenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(financeView.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(82*lineNum);
        make.bottom.equalTo(contentView);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
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
    
    [self scrollViewDidScroll:self.scrollView];
}

#pragma mark - UIs
//ScrollView
- (UIScrollView *)getScrollContentViewWithBgColor:(int)bgColor{
    WeakSelf(weakSelf);
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = UIColorFromHex(bgColor);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.view);
    }];
    scrollView.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        [scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return scrollView;
}
//HeaderView
- (UIImageView *)headerView{
    if (!_headerView) {
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
            vc.hidesBottomBarWhenPushed = YES;
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

- (NSArray *)getMenuData{
    NSMutableArray *menuArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *menuArray1 = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 23; i++) {
        MenuInfo *model = [[MenuInfo alloc]init];
        //栏目名称
        if (i == 0) {
            model.menuName = [NSString stringWithFormat:@"UIWebView"];
        } else {
            model.menuName = [NSString stringWithFormat:@"栏目%d",i];
        }
        //栏目编号
        model.menuId= [NSString stringWithFormat:@"%d",i];
        //栏目图片
        model.imgName = [NSString stringWithFormat:@"menuItem%08d",i];
        [menuArray1 addObject:model];
    }
    [menuArray addObject:menuArray1];
    return menuArray;
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
