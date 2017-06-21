//
//  UUIImage+KYLECategory.h
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/5/28.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KYLECategory)
/*
    @brief  根据颜色生成纯色图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color;

/* 缩放到指定比率 */
- (UIImage *)imageWithScale:(float)scale;
/* 缩放到指定大小 */
- (UIImage *)imageWithSize:(CGSize)size;
@end
