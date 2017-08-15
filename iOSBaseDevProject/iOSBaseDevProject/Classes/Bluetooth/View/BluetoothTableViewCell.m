//
//  BluetoothTableViewCell.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/8/15.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "BluetoothTableViewCell.h"

@interface BluetoothTableViewCell ()

@end

@implementation BluetoothTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected stateTextLabel
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.stateTextLabel = [[UILabel alloc] init];
        [self.stateTextLabel setFont:self.detailTextLabel.font];
        WeakSelf(weakSelf);
        [self addSubview:self.stateTextLabel];
        [self.stateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.detailTextLabel.mas_right).with.mas_offset(10);
            make.right.equalTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.detailTextLabel);
            make.height.equalTo(weakSelf.detailTextLabel);
        }];
        
    }
    return self;
}

@end
