//
//  ScanView.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/13.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//
#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanView ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIImageView *scanView;
@property (nonatomic, strong) UIImageView *lineView;

@end
@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WeakSelf(weakSelf);
        
        _scanView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scanFrame"]];
        [self addSubview:_scanView];
        
        [_scanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.self);
            make.width.height.mas_equalTo(250);
        }];
        
        
        //获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //闪光灯
        if ([device hasFlash] && [device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setFlashMode:AVCaptureFlashModeAuto];
            [device setTorchMode:AVCaptureTorchModeAuto];
            [device unlockForConfiguration];
        }
        //创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        //创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 刷新线程
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        output.rectOfInterest = [self rectOfInterestByScanViewRect:_scanView.frame];
        //初始化连接对象
        _session = [[AVCaptureSession alloc]init];
        
        //采集率
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        if (input) {
            [_session addInput:input];
        }
        
        if (output) {
            [_session addOutput:output];
            //设置扫码支持的编码格式
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
            
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                [array addObject:AVMetadataObjectTypeQRCode];
            }
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
                [array addObject:AVMetadataObjectTypeEAN13Code];
            }
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
                [array addObject:AVMetadataObjectTypeEAN8Code];
            }
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
                [array addObject:AVMetadataObjectTypeCode128Code];
            }
            output.metadataObjectTypes = array;
        }
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.bounds;
        [self.layer insertSublayer:layer above:0];
        [self bringSubviewToFront:_scanView];
        [self setMaskView];
        [_session startRunning];
        [self loopDrawLine];
    }
    return self;
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect))/2/height;
    CGFloat y = (width - CGRectGetWidth(rect))/2/width;
    
    CGFloat w = CGRectGetHeight(rect)/height;
    CGFloat h = CGRectGetWidth(rect)/width;
    
    return CGRectMake(x, y, w, h);
}

#pragma mark - 添加模糊效果
- (void)setMaskView{
    
    WeakSelf(weakSelf);
    UIView *maskView = [[UIView alloc]init];
    [self addSubview:maskView];
    
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [maskView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0){
                make.top.equalTo(weakSelf);
                make.right.equalTo(weakSelf);
                make.left.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf.scanView.mas_top);
            }else if(i == 1){
                make.top.equalTo(weakSelf.scanView);
                make.right.equalTo(weakSelf);
                make.left.equalTo(weakSelf.scanView.mas_right);
                make.bottom.equalTo(weakSelf.scanView);
            }else if(i == 2){
                make.top.equalTo(weakSelf.scanView.mas_bottom);
                make.right.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf);
                make.left.equalTo(weakSelf);
            }else if(i == 3){
                make.top.equalTo(weakSelf.scanView);
                make.right.equalTo(weakSelf.scanView.mas_left);
                make.bottom.equalTo(weakSelf.scanView);
                make.left.equalTo(weakSelf);
            }
        }];
    }
}

#pragma mark - 动画
- (void)loopDrawLine {
    UIImage *lineImage = [UIImage imageNamed:@"scanLine"];
    
    CGFloat x = CGRectGetMinX(_scanView.frame);
    CGFloat y = CGRectGetMinY(_scanView.frame);
    CGFloat w = CGRectGetWidth(_scanView.frame);
    CGFloat h = CGRectGetHeight(_scanView.frame);
    
    CGRect start = CGRectMake(x, y, w, 2);
    CGRect end = CGRectMake(x, y + h - 2, w, 2);
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithImage:lineImage];
        _lineView.frame = start;
        [self addSubview:_lineView];
    }else{
        _lineView.frame = start;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 animations:^{
        _lineView.frame = end;
    } completion:^(BOOL finished) {
        [weakSelf loopDrawLine];
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        if ([_delegate respondsToSelector:@selector(scanView:ScanResult:)]) {
            [_delegate scanView:self ScanResult:metadataObject.stringValue];
        }
    }
}

- (void)startScan{
    _lineView.hidden = NO;
    [_session startRunning];
}

- (void)stopScan{
    _lineView.hidden = YES;
    [_session stopRunning];
}

@end
