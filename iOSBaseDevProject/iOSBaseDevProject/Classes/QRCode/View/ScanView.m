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
@property (nonatomic, strong) UIImageView *loopView;

@end
@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame
                     scanSize:(CGSize)scanSize
                 initCallback:(void (^)(NSError *))initCallback{
    self = [super initWithFrame:frame];
   
    if (self) {
        CGFloat viewW = WIDTH(self);
        CGFloat viewH = HEIGHT(self);
        CGFloat scanW = scanSize.width;
        CGFloat scanH = scanSize.height;
        
        //获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //闪光灯
        if ([device hasFlash] && [device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setFlashMode:AVCaptureFlashModeAuto];
            [device setTorchMode:AVCaptureTorchModeAuto];
            [device unlockForConfiguration];
        }
        //创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        //设置识别区域
        output.rectOfInterest = CGRectMake((viewH - scanH)/2/viewH,
                                           (viewW - scanW)/2/viewW,
                                           scanH/viewH,
                                           scanW/viewW);
        //设置识别类型
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
        [output setMetadataObjectTypes:array];
        //设置代理
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //创建输入流
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input) {
            //初始化连接对象
            self.session = [[AVCaptureSession alloc]init];
            //采集率
            self.session.sessionPreset = AVCaptureSessionPresetHigh;
            
            [self.session addInput:input];
            [self.session addOutput:output];
            [self.session startRunning];
            
            AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            layer.frame = self.bounds;
            [self.layer insertSublayer:layer above:0];
        }
       
        [self initScanView:scanSize];
        [self initMaskView];
        [self initLoopView:scanSize];
        
        if(initCallback){
            initCallback(error);
        }
    }
    return self;
}

#pragma mark - Views
- (void)initScanView:(CGSize)scanSize{
    WeakSelf(weakSelf);
    self.scanView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scanFrame"]];
    [self addSubview:self.scanView];
    
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.self);
        make.size.mas_equalTo(scanSize);
    }];
}
- (void)initMaskView{
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
                //上
                make.top.equalTo(weakSelf);
                make.right.equalTo(weakSelf);
                make.left.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf.scanView.mas_top);
            }else if(i == 1){
                //右
                make.top.equalTo(weakSelf.scanView);
                make.right.equalTo(weakSelf);
                make.left.equalTo(weakSelf.scanView.mas_right);
                make.bottom.equalTo(weakSelf.scanView);
            }else if(i == 2){
                //下
                make.top.equalTo(weakSelf.scanView.mas_bottom);
                make.right.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf);
                make.left.equalTo(weakSelf);
            }else if(i == 3){
                //左
                make.top.equalTo(weakSelf.scanView);
                make.right.equalTo(weakSelf.scanView.mas_left);
                make.bottom.equalTo(weakSelf.scanView);
                make.left.equalTo(weakSelf);
            }
        }];
    }
}
- (void)initLoopView:(CGSize)scanSize{
    WeakSelf(weakSelf);
    self.loopView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scanLine"]];
    [self addSubview:self.loopView];
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.scanView);
        make.height.mas_equalTo(2);
        make.top.equalTo(weakSelf.scanView);
    }];
    [self loopLine:scanSize.height];
}

- (void)loopLine:(CGFloat)depth {
    WeakSelf(weakSelf);
    
    [self.loopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scanView);
    }];
    [self layoutIfNeeded];      //强制约束生成
    
    [UIView animateWithDuration:2 animations:^{
        [self.loopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scanView).with.offset(depth);
        }];
        [self layoutIfNeeded];  //强制约束生成
    } completion:^(BOOL finished) {
        [weakSelf loopLine:depth];
    }];
}

#pragma mark - Delegates
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        if ([self.delegate respondsToSelector:@selector(scanView:scanResult:)]) {
            [self.delegate scanView:self scanResult:metadataObject.stringValue];
        }
    }
}

#pragma mark - Interface
- (void)startScan{
    _loopView.hidden = NO;
    [self.session startRunning];
}

- (void)stopScan{
    _loopView.hidden = YES;
    [self.session stopRunning];
}

@end
