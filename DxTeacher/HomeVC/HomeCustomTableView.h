//
//  HomeCustomTableView.h
//  DxManager
//
//  Created by ligb on 16/9/7.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomTableView : UIView

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *dataSource;

@property (nonatomic , strong) UIViewController *homeVC;

@property (nonatomic , copy) NSString *action;
@property (nonatomic , assign) NSUInteger index;
@property (nonatomic , assign)  NSUInteger   page;

#pragma mark 加载未审核数据（精彩瞬间和用药条管理）
@property (nonatomic , copy)NSString *typeAction;
- (void)loadManageDataAction:(NSString *)typeAction;

@end
