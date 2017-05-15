//
//  ZLBrowseLayout.h
//  WaterFallView
//
//  Created by long on 16/12/14.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZLBrowseStyle) {
    ZLBrowseStyleLinear = 0,
    ZLBrowseStyleRotary,
    ZLBrowseStylePile1,
    ZLBrowseStylePile2,
    ZLBrowseStyleStereo,
};

@interface ZLBrowseLayout : UICollectionViewLayout

/** cell大小 */   //default {250, 250}
@property (nonatomic, assign) CGSize itemSize;

/** 滚动方向 */   //default vertical
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** 类型 */   //default 0
@property (nonatomic, assign) ZLBrowseStyle browseStyle;

/** 最多同时展示的cell数量 */  //default 5
@property (nonatomic, assign) NSInteger visibleCount;

/** 旋转角度 */    //default 0.5
@property (nonatomic, assign) CGFloat rotationAngle;

/** 缩放比例 */    //default 1/6
@property (nonatomic, assign) CGFloat scaling;

/** cell间空隙参数 */  //default 0.65
@property (nonatomic, assign) CGFloat interspaceParam;

@end
