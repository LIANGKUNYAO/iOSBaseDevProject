//
//  ScanView.h
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/13.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanViewDelegate <NSObject>

- (void)scanView:(UIView *)scanView scanResult:(NSString *)result;

@end


@interface ScanView : UIView

@property(nonatomic,assign) id<ScanViewDelegate> delegate;
@property(nonatomic,assign,readonly) CGRect scanViewFrame;

- (instancetype)initWithFrame:(CGRect)frame scanSize:(CGSize)scanSize initCallback:(void (^)(NSError *))initCallback;
- (void)startScan;
- (void)stopScan;
- (void)startTorch;
- (void)stopTorch;

@end
