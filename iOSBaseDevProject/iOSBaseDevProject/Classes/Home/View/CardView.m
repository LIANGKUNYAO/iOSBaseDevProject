//
//  CardView.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/11.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "CardView.h"
#import "FinanceInfo.h"
#import "FinanceCellView.h"

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
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma Interfaces
- (void)setCellClassName:(NSString *)cellClassName{
    [self registerClass:NSClassFromString(cellClassName) forCellWithReuseIdentifier:@"reuseIdentifier"];
}

#pragma Delegates
//numberOfSectionsInCollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.viewData.count;
}
//numberOfItemsInSection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.viewData objectAtIndex:section].count;
}
//cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
}
//willDisplayCell
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FinanceInfo *model = [[self.viewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [(FinanceCellView *)cell setCellTitle:model.title tags:model.tags withRate:model.rate];
}
//didSelectItemAtIndexPath
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.onTapBlock) {
        self.onTapBlock(indexPath);
    }
}

@end
