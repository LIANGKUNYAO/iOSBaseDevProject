//
//  FinanceCellView.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/23.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "FinanceCellView.h"

@interface FinanceCellView()

@property (strong, nonatomic) UILabel *rateLb;
@property (strong, nonatomic) UIView *tagView;
@property (strong, nonatomic) UILabel *titleLb;

@end

@implementation FinanceCellView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WeakSelf(weakSelf);
        
        //设置背景色
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //设置背景阴影
        self.contentView.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.contentView.layer.shadowOpacity = 0.5;
        self.contentView.layer.masksToBounds = NO;
        
        //收益率
        self.rateLb = [[UILabel alloc]init];
        [self.rateLb setTextColor:UIColorFromHex(0XC70000)];
        [self.rateLb setFont:[UIFont systemFontOfSize:18]];
        
        //标签
        self.tagView = [[UIView alloc]init];

        //理财产品名称
        self.titleLb = [[UILabel alloc]init];
        [self.titleLb setFont:[UIFont systemFontOfSize:11]];
        [self.titleLb setTextAlignment:NSTextAlignmentCenter];
        [self.titleLb setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [self.titleLb setTextColor:UIColorFromHex(0X333333)];
        
        [self.contentView addSubview:self.rateLb];
        [self.contentView addSubview:self.tagView];
        [self.contentView addSubview:self.titleLb];
        
        
        [self.rateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.tagView.mas_top).with.offset(-10);
            make.height.mas_equalTo(20);
        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.top.equalTo(weakSelf.mas_centerY);
            make.height.mas_equalTo(13);
        }];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView).with.offset(5);
            make.right.equalTo(weakSelf.contentView).with.offset(-5);
            make.top.equalTo(weakSelf.tagView.mas_bottom).with.offset(10);
            make.height.mas_equalTo(15);
        }];
    }
    
    return self;
}

#pragma mark - Interface
- (void)setCellTitle:(NSString *)title tags:(NSArray *)tags withRate:(NSString *)rate {
    WeakSelf(weakSelf);
    
    NSMutableAttributedString* textLabelStr = [[NSMutableAttributedString alloc]initWithString:rate];
    [textLabelStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]} range:NSMakeRange(0,1)];
    [self.rateLb setAttributedText:textLabelStr];
    
    [self.titleLb setText:title];
    
    [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger length = tags.count;
    for(int i = 0 ; i < length ; i++){
        UILabel *tagLb = [[UILabel alloc]init];
        [tagLb setFont:[UIFont systemFontOfSize:8]];
        [tagLb setText:tags[i]];
        [tagLb setTextColor:UIColorFromHex(0xC70000)];
        [tagLb setTextAlignment:NSTextAlignmentCenter];
        tagLb.layer.cornerRadius = 2.5;
        tagLb.layer.borderColor = [UIColorFromHex(0xC70000) CGColor];
        tagLb.layer.borderWidth = 0.5f;
        [self.tagView addSubview:tagLb];
    }
    
    //循环添加约束
    for(int i = 0 ; i < length ; i++){
        [self.tagView.subviews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_centerY);
            make.height.mas_equalTo(13);
        }];
        if( i > 0 && i < length - 1){
            [self.tagView.subviews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf.tagView.subviews[i+1]);
                make.left.equalTo(weakSelf.tagView.subviews[i-1].mas_right).with.offset(5);
                make.right.equalTo(weakSelf.tagView.subviews[i+1].mas_left).with.offset(-5);
            }];
        }else if(i == 0){
            //第一条数据基于边框定位
            [self.tagView.subviews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf.tagView.subviews[i+1]);
                make.left.equalTo(weakSelf.mas_left).with.offset(5);
                make.right.equalTo(weakSelf.tagView.subviews[i+1].mas_left).with.offset(-5);
            }];
        }else if(i == length - 1){
            //最后一条基于边框定位
            [self.tagView.subviews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf.tagView.subviews[0]);
                make.left.equalTo(weakSelf.tagView.subviews[i-1].mas_right).with.offset(5);
                make.right.equalTo(weakSelf.mas_right).with.offset(-5);
            }];
        }
    }
   
}


@end

