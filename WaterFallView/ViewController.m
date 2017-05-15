//
//  ViewController.m
//  WaterFallView
//
//  Created by long on 16/12/11.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ViewController.h"
#import "ZLWaterFlowLayout.h"
#import "CViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ZLWaterFlowLayoutDelegate>


@property (nonatomic, strong) UICollectionView *v;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZLWaterFlowLayout *layout = [[ZLWaterFlowLayout alloc] init];
    layout.delegate = self;
//    layout.columnCount = 2;
    
    self.v = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.v.delegate = self;
    self.v.dataSource = self;
    self.v.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.v];
    
    [self.v registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.v registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"fview"];
    [self.v registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"view"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, 100, 90, 30);
    [btn setTitle:@"ssss" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ba:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)ba:(UIButton *)b {
    CViewController *c = [[CViewController alloc] init];
    [self presentViewController:c animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"view" forIndexPath:indexPath];
        
        v.backgroundColor = [UIColor yellowColor];
        
        return v;
    } else {
        UICollectionReusableView *v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"fview" forIndexPath:indexPath];
        
        v.backgroundColor = [UIColor blueColor];
        
        return v;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 100);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 100);
}


- (CGFloat)waterFlowLayout:(ZLWaterFlowLayout *)waterFlowLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    if (indexPath.section == 0) {
        return arc4random_uniform(50);
    } else {
        return arc4random_uniform(50) + 50;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
