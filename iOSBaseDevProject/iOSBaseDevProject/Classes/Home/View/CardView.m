//
//  CardView.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/11.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "CardView.h"

@interface CardView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation CardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0; //列间距
    layout.minimumLineSpacing = 0;      //行间距
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        //隐藏滑块
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置代理
        self.delegate = self;
        self.dataSource = self;
        //设置背景颜色（默认黑色）
        self.backgroundColor = [UIColor whiteColor];
        //注册单元格
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuseId"];
    }
    return self;
}

#pragma Delegates
//返回collection view里区(section)的个数，如果没有实现该方法，将默认返回1：
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回指定区(section)包含的数据源条目数(number of items)，该方法必须实现：
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1 ,1 ,1 ,1 );
}

//点击每个item实现的方法：
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected");
}

@end
