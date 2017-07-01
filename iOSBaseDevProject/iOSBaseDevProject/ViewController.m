//
//  ViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "WebViewController.h"
#import "SelfViewController.h"
#import "UIImage+KYLECategory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 控制器实例
    HomeViewController *homeView = [[HomeViewController alloc] init];
    UINavigationController *nvHomeView = [[UINavigationController alloc] initWithRootViewController:homeView];
    // 标签栏图标
    UIImage *homeImage = [[UIImage imageNamed:@"home"] imageWithSize:SquareSize20];
    nvHomeView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:homeImage tag:0];
    [self addChildViewController:nvHomeView];
    
    SelfViewController *selfView = [[SelfViewController alloc]init];
    UINavigationController *nvSelfView = [[UINavigationController alloc] initWithRootViewController:selfView];
    // 标签栏图标
    UIImage *selfImage = [[UIImage imageNamed:@"profile"] imageWithSize:SquareSize20];
    nvSelfView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:selfImage tag:2];
    [self addChildViewController:nvSelfView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
