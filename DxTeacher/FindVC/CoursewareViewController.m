//
//  CoursewareViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "CoursewareViewController.h"
#import "AppDefine.h"
#import "CustomTableView.h"
#import "CustomItemView.h"

@interface CoursewareViewController ()
@property (weak, nonatomic) IBOutlet CustomItemView *customView;

@property (nonatomic , strong) NSMutableArray *itemViews;

@end

@implementation CoursewareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"教堂与课件";
}
- (void)addHeadItems:(NSArray *)items{
    
    //初始化页面view
    _itemViews = [[NSMutableArray alloc] initWithCapacity:items.count];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (int i =0; i<items.count; i++) {
        CustomTableView *view = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.screen_W, self.screen_H-64)];
        view.homeVC = self;
//        view.layer.borderWidth = 1;
//        view.layer.borderColor = [UIColor redColor].CGColor;
        [_itemViews addObject:view];
    }
    
    
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj[@"title"]];
    }];
    //item 页面布局
    [_customView addItemView:_itemViews title:titles height: self.screen_H-64];
    
    //默认加载首页通知数据
    CustomTableView *iView = _itemViews[0];
    iView.page = 1;
    iView.index = [items[0][@"id"] integerValue];
    
    //item 变化数据加载处理
    _customView.itemsEcentAction = ^(NSInteger index){
        NSLog(@"index = %ld",(long)index);
        
        CustomTableView *iView = _itemViews[index];
        iView.page = 1;
        iView.index = [items[index][@"id"] integerValue];
        
        
        
    };
}
- (void)loadNewData{
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getFind6ChildClass",@"aid":@(_aid)} completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            NSArray *items = model.data;
            if ([items isKindOfClass:[NSArray class]] && items.count) {
                [self addHeadItems:items];
            }else{
                [self.view showHUDTitleView:@"暂无内容" image:nil];
            }
            
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
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
