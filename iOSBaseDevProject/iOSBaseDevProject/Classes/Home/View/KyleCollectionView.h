//
//  KyleCollectionView.h
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/11.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KyleCollectionView : UICollectionView

/**
 *  Callback Function : Handle the Click Event
 */
@property (nonatomic, copy) void (^didSelectItem)(NSIndexPath * indexPath);

@property (nonatomic, copy) void (^willDisplayCell)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath, NSArray<__kindof NSArray *> *viewData);

@property (nonatomic, copy) NSArray<__kindof NSArray *> *viewData;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

- (void)setCellClass:(Class)class;

@end
