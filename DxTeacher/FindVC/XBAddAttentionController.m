//
//  XBAddAttentionController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/23.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBAddAttentionController.h"
#import "XBNetWorkTool.h"
#import <MJRefresh.h>
#import "XBElephantModel.h"
#import <MJRefresh.h>
#import "XBDiscoveryAddCell.h"

@interface XBAddAttentionController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation XBAddAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpRefreshControl];
    
    self.pageIndex = 0;
    
    [self setUpTableView];
}

#pragma mark - 设置刷新控件
- (void)setUpRefreshControl {
    __unsafe_unretained UITableView *tableView = self.tableView;
    __weak typeof(self) Self = self;
    //     下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [Self requestForMyAttention];
    }];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestForData];
    }];
    [tableView.mj_footer beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 获取我的关注
- (void)requestForMyAttention {
    __weak typeof(self) Self = self;
    if (Self.collectionArray.count == 0) {
        return;
    }
    XBElephantModel *elephant = Self.collectionArray[0];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"action" : @"getUNSCList",
                                 @"uid" : userInfo[@"id"],
                                 @"maxid" : elephant.ID};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        if (![dataArray isKindOfClass:[NSNull class]]) {
            NSArray *newData = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newData.count)];
            [Self.collectionArray insertObjects:newData atIndexes:indexSet];
            
            XBLog(@"%@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [Self.tableView reloadData];
                [Self.tableView.mj_header endRefreshing];
            });
            return;
        }
        [Self.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText = @"没有刷新到数据哟!";
            [hud hide:YES afterDelay:3.0];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Self.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"网络繁忙,请稍后再试!";
            [hud hide:YES afterDelay:3.0];
        });
    }];
}

#pragma mark - 上拉请求页面数据
- (void)requestForData {
    __weak typeof(self) Self = self;
    //    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    NSDictionary *parameters = @{@"action" : @"getUNSCList",
                                 @"uid" : userInfo[@"id"],
                                 @"page" : @(++_pageIndex)};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        XBLog(@"-----%@, =======%@", responseObject.allValues, [dataArray class]);
        if (![dataArray isKindOfClass:[NSNull class]]) {
            if (Self.pageIndex == 1) {
                Self.collectionArray = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else if(Self.pageIndex >= 2) {
                [Self.collectionArray addObjectsFromArray:[XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            }
            
            XBLog(@"%@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:Self.navigationController.view animated:YES];
                [Self.tableView reloadData];
                [Self.tableView.mj_footer endRefreshing];
            });
            return;
        }
        [self.tableView.mj_footer endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            Self.pageIndex--;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Self.navigationController.view animated:YES];
            hud.labelText = @"没有刷新到数据哟!";
            [hud hide:YES afterDelay:3.0];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            //            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
            hud.labelText = @"网络繁忙,请稍后再试!";
            [hud hide:YES afterDelay:3.0];
        });
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _collectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBDiscoveryAddCell *cell = [XBDiscoveryAddCell discoveryAddCellWith:tableView];
    cell.tag = indexPath.row;
    __weak typeof(self) Self = self;
    cell.buttonBlock = ^(NSInteger index) {
//        [Self requestForCollectionArtistWith:Self.dataList[index]];
    };
    
    cell.elephantModel = _collectionArray[indexPath.row];
    return cell;
}

#pragma mark - 设置UI
- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 50;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.title = @"关注";
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
