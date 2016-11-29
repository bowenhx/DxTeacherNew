//
//  XBSaveAttentionController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBSaveAttentionController.h"
#import "XBNetWorkTool.h"
#import <MJRefresh.h>
#import "XBSaveAttentionCell.h"

@interface XBSaveAttentionController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation XBSaveAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"安全提醒";
    
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
        [Self requestForNewData];
    }];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [Self requestForDataWith];
    }];
    [self.tableView.mj_footer beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 下拉请求页面数据
- (void)requestForNewData {
    if (_dataList.count) {
        XBElephantModel *firstElephantModel = _dataList[0];
//        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
        [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                                   parameters:@{@"action" : @"getNewsList",
                                                @"aid" : @124,
                                                @"maxid" : firstElephantModel.ID,
                                                @"uid" : userInfo[@"id"],
                                                @"page" : @""}
                                     progress:^(NSProgress * _Nonnull downloadProgress) {}
                                      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                                          NSArray *dataArray = responseObject[@"data"];
                                          XBLog(@"-----%@, =======%@", responseObject.allValues, [dataArray class]);
                                          if (![dataArray isKindOfClass:[NSNull class]]) {
                                              NSArray *newData = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                              NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newData.count)];
                                              [self.dataList insertObjects:newData atIndexes:indexSet];
                                              // 请求完数据暂时保存到内存....
                                              //                                          [self.allData setObject:@{@(_pageIndex) : self.dataList} forKey:@(_currentIndex)];
                                              
                                              // 保存最新数据的maxid,和对应的aid
                                              //                                          XBElephantModel *firstModel = _dataList[0];
                                              //                                          [XBUserDefaults setObject:firstModel.ID forKey:[NSString stringWithFormat:@"%ld", _currentIndex]];
                                              
                                              XBLog(@"%@", responseObject);
                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                  [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                              return;
                                          }
                                          [self.tableView.mj_footer endRefreshing];
                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                              hud.labelText = @"没有刷新到数据哟!";
                                              [hud hide:YES afterDelay:3.0];
                                          });
                                      }
                                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.tableView.mj_header endRefreshing];
//                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                              hud.labelText = @"网络繁忙,请稍后再试!";
                                              [hud hide:YES afterDelay:3.0];
                                          });
                                      }];
    }else {
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark - 上拉请求页面数据
- (void)requestForDataWith {
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    XBElephantModel *firstElephantModel = _dataList[0];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    NSDictionary *parameters = @{@"action" : @"getNewsList",
                                 @"aid" : @"124",
                                 @"maxid" : @"",
                                 @"uid" : userInfo[@"id"],
                                 @"page" : @(++_pageIndex)};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:parameters
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        XBLog(@"-----%@, =======%@", responseObject.allValues, [dataArray class]);
        if (![dataArray isKindOfClass:[NSNull class]]) {
            if (_pageIndex == 1) {
                self.dataList = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }else if(_pageIndex >= 2) {
                [self.dataList addObjectsFromArray:[XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            }
            // 请求完数据暂时保存到内存....
//            [self.allData setObject:@{@(_pageIndex) : self.dataList} forKey:@(index)];
            
            // 保存最新数据的maxid,和对应的aid
//            XBElephantModel *firstModel = _dataList[0];
//            [XBUserDefaults setObject:firstModel.ID forKey:[NSString stringWithFormat:@"%ld", index]];
            
            XBLog(@"%@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            });
            return;
        }
        [self.tableView.mj_footer endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText = @"没有刷新到数据哟!";
            [hud hide:YES afterDelay:3.0];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
//            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"网络繁忙,请稍后再试!";
            [hud hide:YES afterDelay:3.0];
        });
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBSaveAttentionCell *cell = [XBSaveAttentionCell saveAttentionCellWith:tableView];
    cell.elephantModel = _dataList[indexPath.row];
    
    return cell;
}

#pragma mark - 设置UI
- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
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
