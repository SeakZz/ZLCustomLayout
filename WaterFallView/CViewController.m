//
//  CViewController.m
//  WaterFallView
//
//  Created by long on 16/12/15.
//  Copyright © 2016年 long. All rights reserved.
//

#import "CViewController.h"
#import "ZLBrowseLayout.h"

@interface CViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *v;
@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZLBrowseLayout *layout = [[ZLBrowseLayout alloc] init];
    layout.browseStyle = ZLBrowseStyleLinear;
    layout.scaling = 0.5;
//    layout.rotationAngle = 0.5;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = CGSizeMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 100);
//    layout.itemSize = CGSizeMake(50, 50);
    
    self.v = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.v.delegate = self;
    self.v.dataSource = self;
    self.v.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.v];
    
    [self.v registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor redColor];
//    } else {
//        cell.backgroundColor = [UIColor clearColor];
//    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.contentView.layer.borderWidth = 1.f;
    cell.contentView.layer.borderColor = [UIColor redColor].CGColor;
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 30)];
    l.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    [cell.contentView addSubview:l];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
