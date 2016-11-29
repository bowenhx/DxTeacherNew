//
//  XBHotRecommendController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/23.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBHotRecommendController.h"
#import "XBNetWorkTool.h"
#import "XBElephantModel.h"
#import "XBHotRecommentListCell.h"

@interface XBHotRecommendController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *hotRecommendArray;

@end

@implementation XBHotRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"热门推荐";
    
    [self setUpTableView];
    
    [self setUpRefreshControl];
}

#pragma mark - 设置刷新控件
- (void)setUpRefreshControl {
    __unsafe_unretained UITableView *tableView = self.tableView;
    __weak typeof(self) Self = self;
    //     下拉刷新
//    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [Self requestForNewData];
//    }];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [Self requestForData];
    }];
    [self.tableView.mj_footer beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 请求页面数据
- (void)requestForData {
    __weak typeof(self) Self = self;
    NSDictionary *parameters = @{@"action" : @"geHotList",
                                 @"page" : @(++Self.pageIndex)};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:parameters
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                                      NSArray *dataArray = responseObject[@"data"];
                                      XBLog(@"-----%@, =======%@", responseObject.allValues, [dataArray class]);
                                      if (![dataArray isKindOfClass:[NSNull class]]) {
                                          if (Self.pageIndex == 1) {
                                              Self.hotRecommendArray = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                          }else if(Self.pageIndex >= 2) {
                                              [Self.hotRecommendArray addObjectsFromArray:[XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                                          }
                                          
                                          XBLog(@"%@", responseObject);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //                                              [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                              [Self.tableView reloadData];
                                              [Self.tableView.mj_footer endRefreshing];
                                          });
                                          return;
                                      }
                                      [Self.tableView.mj_footer endRefreshing];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          //                                          [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                          Self.pageIndex--;
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                          hud.labelText = @"没有刷新到数据哟!";
                                          [hud hide:YES afterDelay:3.0];
                                      });
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          //                                          [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                          hud.labelText = @"网络繁忙,请稍后再试!";
                                          [hud hide:YES afterDelay:3.0];
                                      });
                                  }];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hotRecommendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBHotRecommentListCell *cell = [XBHotRecommentListCell hotRecommentListCellWith:tableView];
    cell.elephantModel = _hotRecommendArray[indexPath.row];
    return cell;
}

#pragma mark - 设置UI
- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.rowHeight = 116.0;
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
