//
//  VerifyViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/30.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "VerifyViewController.h"
#import "CustomItemView.h"
#import "HomeCustomTableView.h"
#import "AppDefine.h"

@interface VerifyViewController ()
@property (weak, nonatomic) IBOutlet CustomItemView *customView;
@property (nonatomic , strong) NSMutableArray *itemViews;
@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的审核";
    
    
    
}
- (void)loadNewView{
    //初始化页面view
    _itemViews = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i =0; i<2; i++) {
        HomeCustomTableView *view = [[HomeCustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.screen_W, self.screen_H-64)];
        view.homeVC = self;
        view.action = @"doReviewed";
        [_itemViews addObject:view];
    }
    
    //item 页面布局
    [_customView addItemView:_itemViews title:@[@"精彩瞬间",
                                                @"用药管理"] height: self.screen_H-64];
    
    //默认加载首页通知数据
    HomeCustomTableView *iView = _itemViews[0];
    [iView loadManageDataAction:@"getUnCheckNewsList"];
    
    //item 变化数据加载处理
    _customView.itemsEcentAction = ^(NSInteger index){
        NSLog(@"index = %ld",(long)index);
        
        HomeCustomTableView *iView = _itemViews[index];
        if (index == 0) {
            [iView loadManageDataAction:@"getUnCheckNewsList"];
        }else{
            [iView loadManageDataAction:@"getUnCheckDrugSearch"];
        }
        
    };
    

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
