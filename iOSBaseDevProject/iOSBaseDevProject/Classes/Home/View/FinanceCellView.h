//
//  FinanceCellView.h
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/23.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceCellView : UICollectionViewCell

- (void)setCellTitle:(NSString *)title tags:(NSArray *)tags withRate:(NSString *)rate;

@end
