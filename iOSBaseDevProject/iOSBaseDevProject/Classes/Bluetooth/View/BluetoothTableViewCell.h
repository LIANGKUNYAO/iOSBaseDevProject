//
//  BluetoothTableViewCell.h
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/8/15.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *stateTextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
