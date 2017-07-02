//
//  WelcomeViewController.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/7/1.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface WelcomeViewController ()<AVPlayerViewControllerDelegate>
@property (nonatomic,strong) AVPlayerViewController *playVC;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //视频播放
    [self SetupVideoPlayer];
    //进入主界面按钮
    [self setEnterMainBtn];
    
    //淡入
    [self.view setAlpha:0.0];
    [UIView animateWithDuration:3.0 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SetupVideoPlayer{
    self.playVC = [[AVPlayerViewController alloc] init];
    [self.playVC setShowsPlaybackControls:NO];
    [self.playVC setDelegate:self];
    
    AVPlayer *player = [AVPlayer playerWithURL:self.movieURL];
    [self.playVC setPlayer:player];
    [self.playVC.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playVC.player.currentItem];

    [self.view addSubview:self.playVC.view];
    
    WeakSelf(weakSelf);
    [self.playVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(weakSelf.view);
    }];
}

- (void)setEnterMainBtn{
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"立刻体验" forState:UIControlStateNormal];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterMainButton];

    WeakSelf(weakSelf);
    [enterMainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(24);
        make.right.equalTo(weakSelf.view).with.offset(-24);
        make.bottom.equalTo(weakSelf.view).with.offset(-32);
        make.height.mas_equalTo(48);

    }];
}

#pragma mark - Delegates
- (void)playerDidReachEnd:(NSNotification *)notification{
    //self.playVC.player.currentItem  ==  [notification object]
    //重置时间
    [self.playVC.player.currentItem seekToTime:kCMTimeZero];
    [self.playVC.player play];
}

- (void)enterMainAction:(UIButton *)btn {
    NSLog(@"进入应用");
    ViewController *rootTabCtrl = [[ViewController alloc]init];
    self.view.window.rootViewController = rootTabCtrl;
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
