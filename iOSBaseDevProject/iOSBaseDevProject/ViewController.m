//
//  ViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 控制器实例
    HomeViewController *vc = [[HomeViewController alloc] init];
    // 把vc加入进去
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    // 标签栏图标
    nv.tabBarItem =[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    
    // 实例的数组
    NSArray *controllersArray = @[nv];
    // 数组加入到标签控制器
    [self setViewControllers:controllersArray animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
