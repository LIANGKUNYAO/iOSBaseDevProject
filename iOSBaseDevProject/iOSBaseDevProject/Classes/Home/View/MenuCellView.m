//
//  MenuCellView.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/24.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "MenuCellView.h"

@interface MenuCellView()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLb;

@end

@implementation MenuCellView

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
        //self.contentView.layer.borderWidth = 0.5;
        //self.contentView.layer.borderColor = [UIColorFromHex(0XE9E9E9) CGColor];
        
        self.iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).with.offset(10);
            make.centerX.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.titleLb = [[UILabel alloc]init];
        [self.titleLb setFont:[UIFont systemFontOfSize:12]];
        [self.titleLb setTextAlignment:NSTextAlignmentCenter];
        [self.titleLb setTextColor:UIColorFromHex(0X333333)];
        [self.contentView addSubview:self.titleLb];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-15);
            make.left.right.equalTo(weakSelf.contentView);
        }];
    }
    
    return self;
}

#pragma mark - Interface
- (void)setCellTitle:(NSString *)title withImage:(UIImage *)img{
    self.titleLb.text = title;
    self.iconView.image = img;
}
@end
