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
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:homeView];
    // 标签栏图标
    UIImage *homeImage = [[UIImage imageNamed:@"home"] imageWithSize:SquareSize20];
    nvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:homeImage tag:0];
    [self addChildViewController:nvc];
    
    SelfViewController *selfView = [[SelfViewController alloc]init];
    UIImage *selfImage = [[UIImage imageNamed:@"profile"] imageWithSize:SquareSize20];
    selfView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:selfImage tag:2];
    [self addChildViewController:selfView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
