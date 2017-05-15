//
//  ZLBrowseLayout.m
//  WaterFallView
//
//  Created by long on 16/12/14.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ZLBrowseLayout.h"


@interface ZLBrowseLayout () {
    CGFloat _leadSpace;
    
    CGFloat _collectionViewLength;
    CGFloat _itemLength;
}

@property (nonatomic, assign) NSInteger collectionViewContentOffsetLength;

@end

@implementation ZLBrowseLayout

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _browseStyle = ZLBrowseStyleLinear;
        _itemSize = CGSizeMake(250, 250);
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        _visibleCount = 5;
        _rotationAngle = 0.5;
        _interspaceParam = 0.65;
        _scaling = 1/6;
    }
    return self;
}
- (NSInteger)collectionViewContentOffsetLength {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x;
}


#pragma mark - overwirte
- (void)prepareLayout {
    [super prepareLayout];
    if (_visibleCount < 1) {
        _visibleCount = 5;
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _collectionViewLength = CGRectGetHeight(self.collectionView.frame);
        _itemLength = _itemSize.height;
        _leadSpace = (_collectionViewLength - _itemLength)/2;
        self.collectionView.contentInset = UIEdgeInsetsMake(_leadSpace, 0, _leadSpace, 0);
    } else {
        _collectionViewLength = CGRectGetWidth(self.collectionView.frame);
        _itemLength = _itemSize.width;
        _leadSpace = (_collectionViewLength - _itemLength)/2;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, _leadSpace, 0, _leadSpace);
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = _itemSize;
    
    CGFloat cY = self.collectionViewContentOffsetLength + _collectionViewLength / 2;
    CGFloat attributesY = _itemLength * indexPath.item + _itemLength / 2;
    attrs.zIndex = -ABS(attributesY - cY);
    
    CGFloat delta = cY - attributesY;
    CGFloat ratio =  - delta / _itemLength * _rotationAngle;
    CGFloat scale = 1 - ABS(delta) / _itemLength * _scaling * cos(ratio * M_PI_4);
    attrs.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat centerY = attributesY;
    switch (self.browseStyle) {
        case ZLBrowseStyleRotary:
            attrs.transform = CGAffineTransformRotate(attrs.transform, - ratio * M_PI_4);
            centerY += sin(ratio * M_PI_2) * _itemLength / 2;
            break;
        case ZLBrowseStylePile1:
            centerY = cY + sin(ratio * M_PI_2) * _itemLength * _interspaceParam;
            break;
        case ZLBrowseStylePile2:
            centerY = cY + sin(ratio * M_PI_2) * _itemLength * _interspaceParam;
            if (delta > 0 && delta <= _itemLength / 2) {
                attrs.transform = CGAffineTransformIdentity;
                CGRect rect = attrs.frame;
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    rect.origin.x = CGRectGetWidth(self.collectionView.frame) / 2 - _itemSize.width * scale / 2;
                    rect.origin.y = centerY - _itemLength * scale / 2;
                    rect.size.width = _itemSize.width * scale;
                    CGFloat param = delta / (_itemLength / 2);
                    rect.size.height = _itemLength * scale * (1 - param) + sin(0.25 * M_PI_2) * _itemLength * _interspaceParam * 2 * param;
                } else {
                    rect.origin.x = centerY - _itemLength * scale / 2;
                    rect.origin.y = CGRectGetHeight(self.collectionView.frame) / 2 - _itemSize.height * scale / 2;
                    rect.size.height = _itemSize.height * scale;
                    CGFloat param = delta / (_itemLength / 2);
                    rect.size.width = _itemLength * scale * (1 - param) + sin(0.25 * M_PI_2) * _itemLength * _interspaceParam * 2 * param;
                }
                attrs.frame = rect;
                return attrs;
            }
            break;
        case ZLBrowseStyleStereo: {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0/400.0f;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                transform = CATransform3DRotate(transform, ratio * M_PI_4, 1, 0, 0);
            } else {
                transform = CATransform3DRotate(transform, ratio * M_PI_4, 0, -1, 0);
            }
            attrs.transform3D = transform;
            
        }
            break;
        default:
            break;
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        attrs.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, centerY);
    } else {
        attrs.center = CGPointMake(centerY, CGRectGetHeight(self.collectionView.frame) / 2);
    }
    
    return attrs;
}

- (CGSize)collectionViewContentSize {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(0, cellCount * _itemSize.height);
    } else {
        return CGSizeMake(cellCount * _itemSize.width, 0);
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerY = self.collectionViewContentOffsetLength + _collectionViewLength / 2;
    NSInteger index = centerY / _itemLength;
    NSInteger count = (self.visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat index;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        index = roundf((proposedContentOffset.y + _leadSpace)/_itemSize.height);
        proposedContentOffset.y = _itemSize.height * index +  -_leadSpace;
    } else {
        index = roundf((proposedContentOffset.x + _leadSpace)/_itemSize.width);
        proposedContentOffset.x = _itemSize.width * index +   -_leadSpace;
    }
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end
