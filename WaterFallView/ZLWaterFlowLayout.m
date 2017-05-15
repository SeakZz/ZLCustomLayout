//
//  ZLWaterFlowLayout.m
//  WaterFallView
//
//  Created by long on 16/12/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ZLWaterFlowLayout.h"

@interface ZLWaterFlowLayout () 

/** 存放所有cell布局属性 */
@property (nonatomic, strong) NSMutableArray *layouts;
/** 存放所有列高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation ZLWaterFlowLayout

#pragma mark - init
- (NSMutableArray *)layouts {
    if (!_layouts) {
        _layouts = [NSMutableArray array];
    }
    return _layouts;
}
- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _columnCount = 3;
        _columnMargin = 10.f;
        _rowMargin = 10.f;
        _edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}


#pragma mark - overwrite
//初始化
- (void)prepareLayout {
    [super prepareLayout];
    
    _contentHeight = 0;
    [self.columnHeights removeAllObjects];
    for (int i = 0; i<_columnCount; i++) {
        [self.columnHeights addObject:@(_edgeInsets.top)];
    }
    
    [self.layouts removeAllObjects];

    for (int j = 0; j<self.collectionView.numberOfSections; j++) {
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:j];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            
            [self.layouts addObject:attrs];
            
            for (int i = 0; i<_columnCount; i++) {
                self.columnHeights[i] = @([self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:j].height + _contentHeight);
            }
        }
        
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:j];
        for (int i = 0; i<cellCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.layouts addObject:attrs];
        }
        for (int i = 0; i<_columnCount; i++) {
            self.columnHeights[i] = @(_contentHeight);
        }

        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:j];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
            [self.layouts addObject:attrs];
            
            for (int i = 0; i<_columnCount; i++) {
                self.columnHeights[i] = @(_contentHeight);
            }
        }
        
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layouts;
}

//indexpath位置的layoutattributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //为这个cell创建布局属性
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionViewW
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    
    //找出高度最短的那一列
    NSInteger column = 0;
    
    //默认第一列的高度最短
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    //遍历数组所有值
    for (NSInteger i = 1; i < _columnCount; i++) {
        
        //取出每一列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        //判断高度
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            //最短列赋值给columnY
            column = i;
        }
        
    }
    
    
    //设置布局
    
    CGFloat w = (collectionViewW - _edgeInsets.left - _edgeInsets.right - (_columnCount - 1)*_columnMargin) / _columnCount;
    
    CGFloat x = _edgeInsets.left + column * (w + _columnMargin);
    
    CGFloat y = minColumnHeight;
    
    //如果不是第一行时
    if (y != _edgeInsets.top) {
        y += _rowMargin;
    }
    
    //高度由外界决定,通过delegate
    CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndexPath:indexPath itemWidth:w];
    
    //设置frame
    attributes.frame = CGRectMake(x, y, w, h);
    
    //更新最短列的高度
    self.columnHeights[column] = @(CGRectGetMaxY(attributes.frame));
    
    //记录最大高度
    CGFloat columHeight = [self.columnHeights[column] doubleValue];
    if (_contentHeight < columHeight) {
        _contentHeight = columHeight;
    }
    
    return attributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            _contentHeight += _edgeInsets.top == 10?0:_edgeInsets.top;
        } else {
            _contentHeight += _rowMargin;
        }
        
        attrs.frame = CGRectMake(0, _contentHeight, [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section].width, [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section].height);
        
        
    } else {
        
        _contentHeight += _rowMargin;
        
        attrs.frame = CGRectMake(0, _contentHeight, [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section].width, [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section].height);
        
        if (indexPath.section == self.collectionView.numberOfSections - 1 || (indexPath.section<self.collectionView.numberOfSections - 1 && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)] && [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section + 1].height>0)) {
            _contentHeight += attrs.frame.size.height - _rowMargin;
        } else {
            _contentHeight += attrs.frame.size.height;
        }
    }
    return attrs;
}

//可滚动范围
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, _contentHeight + _edgeInsets.bottom);
}

@end
