//
//  ZLWaterFlowLayout.h
//  WaterFallView
//
//  Created by long on 16/12/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLWaterFlowLayout;

@protocol ZLWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(ZLWaterFlowLayout *)waterFlowLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface ZLWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger columnCount; //列数default 3
@property (nonatomic, assign) CGFloat columnMargin; //列间距default 10
@property (nonatomic, assign) CGFloat rowMargin; //行间距    default 10
@property (nonatomic, assign) UIEdgeInsets edgeInsets; //边缘间距 default {10,10,10,10}

@property (nonatomic, weak) id <ZLWaterFlowLayoutDelegate> delegate;

@end
