//
//  CardView.h
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/11.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UICollectionView

/**
 *  Callback Function : Handle the Click Event
 */
@property (nonatomic, copy) void (^onTapBlock)(NSIndexPath * indexPath);

@property (nonatomic, copy) NSArray *viewData;

@end
