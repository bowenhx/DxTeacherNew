//
//  HomeCustomTableView.m
//  DxManager
//
//  Created by ligb on 16/9/7.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "HomeCustomTableView.h"
#import "TrendsTableViewCell.h"
#import "AppDefine.h"
#import "ItemVIewsHeight.h"

@interface HomeCustomTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger       _commentId;
   
}

@property (nonatomic , assign) BOOL addNotCent;
@end

@implementation HomeCustomTableView

- (void)dealloc{
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.addNotCent = YES;
        _page = 1;
        [self addSubview:self.tableView];
    }
    return self;
}
- (NSMutableArray *)dataSource{
    if (nil == _dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.layer.borderWidth = 1;
//        _tableView.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        //寬度
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        
        //高度
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];

    }
    return _tableView;
}
- (void)setPage:(NSUInteger)page{
    _page = page;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefreshingAction)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadingAction)];
}

//下拉刷新
- (void)beginRefreshingAction{
    _page = 1;
    self.index = _index;
}
//上拉加载更多
- (void)uploadingAction{
    _page ++;
    self.index = _index;
}
- (void)setIndex:(NSUInteger)index{
    _index = index;
    [self showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":self.action ? self.action : @"getNewsList",@"aid":@(index),@"page":@(_page)} completion:^(BNetData *model, NSString *netErr) {
        [self removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            //请求成功
            NSArray *array = model.data;
            if ( _page == 1 ) {
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    [self.dataSource setArray:model.data];
                    [_tableView.mj_footer resetNoMoreData];
                }
            }else{
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.dataSource addObject:obj];
                    }];
                }else{
                    [self showHUDTitleView:@"没有更多数据" image:nil];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            [_tableView reloadData];
            
            if (self.dataSource.count == 0) {
                [self showHUDTitleView:@"此分类暂无数据" image:nil];
            }
            
        }else{
            [self showHUDTitleView:model.message image:nil];
        }
        
        [_tableView endRefreshing];
        
    }];
    
}
#pragma mark 加载未审核数据（精彩瞬间和用药条管理）
- (void)loadManageDataAction:(NSString *)typeAction{
    _typeAction = typeAction;
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    [self showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":typeAction,@"userid":info[@"id"]} completion:^(BNetData *model, NSString *netErr) {
        [self removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            //请求成功
            [self.dataSource setArray:model.data];
            [_tableView reloadData];
            
            if (self.dataSource.count == 0) {
                [self showHUDTitleView:@"此分类暂无数据" image:nil];
            }
            
        }else{
            [self showHUDTitleView:model.message image:nil];
        }
        
    }];

}
#pragma mark 审核操作
- (void)reviewedActonDictionary:(NSDictionary *)dict{
    [self showHUDActivityView:@"正在加载" shade:NO];
    NSInteger status = [dict[@"status"] integerValue] ? 0 : 2;
    NSDictionary *info = @{@"action":@"doReviewed",
                           @"id":dict[@"id"],
                           @"uid":dict[@"fields"][@"AuthorID"] ? dict[@"fields"][@"AuthorID"] : @"",
                           @"uname":dict[@"user_name"] ? dict[@"user_name"] : @"",
                           @"state":@(status)};
    
    [[ANet share] post:BASE_URL params:info completion:^(BNetData *model, NSString *netErr) {
        [self removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            [self showSuccess:model.message];
            [self loadManageDataAction:_typeAction];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataHomeStatus" object:nil];
//            [self performSelector:@selector(tapBackBtn) withObject:nil afterDelay:.7];
        }else{
            [self showHUDTitleView:model.message image:nil];
        }
        
    }];
}
- (void)handleNotification:(NSNotification *)notification{
    NSDictionary *info = [notification object];
    NSLog(@"info -= %@",info);

}

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *xibName = @"TrendsTableViewCell";
    TrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.dataSource[indexPath.row];
    cell.btnCheck.tag = indexPath.row;
    if ([self.homeVC.title isEqualToString:@"我的审核"]) {
        cell.btnCheck.hidden = YES;
//        [cell.btnCheck setTitle:@"待确认" forState:0];
//        [cell.btnCheck addTarget:self action:@selector(didDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.btnCheck.hidden = YES;
    }
    cell.imagesView.viewController = self.homeVC;
   
    
    return cell;

    
}
- (void)didDetailAction:(UIButton *)btn{
    if ([self.homeVC.title isEqualToString:@"我的审核"]) {
        [self reviewedActonDictionary:self.dataSource[btn.tag]];
    }else{
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)itemsImages:(NSDictionary *)item{
    NSArray *items = item[@"albums"];
    return [ItemVIewsHeight loadItmesCounts:items.count] + [ItemVIewsHeight loadTextContentsMaxWidth:95 string:item[@"zhaiyao"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self itemsImages:self.dataSource[indexPath.row]];
    if (self.index == 68) {//互动投诉 高度
        NSArray *comment = self.dataSource[indexPath.row][@"comment"];
        float comH = comment.count * 25;
        return 115 + height + comH;
    }
    if ([self.homeVC.title isEqualToString:@"我的审核"]) {
        return 95+height;
    }
    return 115 + height;
}
@end
