//
//  GrowLogViewController.m
//  DxTeacher
//
//  Created by ligb on 16/11/15.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define SPACE 20  //图片间隔20
#import "GrowLogViewController.h"
#import "ItemViewBtn.h"
#import "GrowLogDetailViewController.h"
#import "GrowLogCollectionViewCell.h"

@interface GrowLogViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *_collectionView;
    
}
@end

@implementation GrowLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"成长日志";
    
}
- (void)loadNewView{
    float layoutW = (self.screen_W - 4 * SPACE) / 3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(layoutW , layoutW);
    flowLayout.minimumLineSpacing = SPACE;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = SPACE;
    _collectionView.collectionViewLayout = flowLayout;
    UINib *cellNib = [UINib nibWithNibName:@"GrowLogCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"growLogViewCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(20, 19, 20, 19);

}

- (void)loadNewData{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getChildList",@"uid":info[@"id"]} completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
         
            //[self loadItemView:model.data];
            [self.dataSource setArray:model.data];
            [_collectionView reloadData];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GrowLogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"growLogViewCell" forIndexPath:indexPath];
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GrowLogDetailViewController *growDetailVC = [[GrowLogDetailViewController alloc] initWithNibName:@"GrowLogDetailViewController" bundle:nil];
    growDetailVC.title = [NSString stringWithFormat:@"%@的成长日志",self.dataSource[indexPath.row][@"user_name"]];
    growDetailVC.aidIndex = [self.dataSource[indexPath.row][@"childid"] integerValue];
    [self.navigationController pushViewController:growDetailVC animated:YES];
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
