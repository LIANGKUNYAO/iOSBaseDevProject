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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 控制器实例
    HomeViewController *homeView = [[HomeViewController alloc] init];
    UINavigationController *nv1 = [[UINavigationController alloc] initWithRootViewController:homeView];
    // 标签栏图标
    nv1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"ekg.png"] tag:0];
    [self addChildViewController:nv1];
    
    WebViewController *webView = [[WebViewController alloc] init];
    webView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"ekg.png"] tag:1];
    [self addChildViewController:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
