//
//  KyleCollectionView.m
//  iOSBaseDevProject
//
//  Created by 梁坤尧 on 2017/6/11.
//  Copyright © 2017年 梁坤尧. All rights reserved.
//

#import "KyleCollectionView.h"

@interface KyleCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation KyleCollectionView

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
    }
    return self;
}
#pragma Interfaces
- (void)setCellClass:(Class)class{
    [self registerClass:class forCellWithReuseIdentifier:@"reuseIdentifier"];
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
    if (self.willDisplayCell) {
        self.willDisplayCell(collectionView,cell,indexPath,self.viewData);
    }
}
//didSelectItemAtIndexPath
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectItem) {
        self.didSelectItem(indexPath);
    }
}

@end
