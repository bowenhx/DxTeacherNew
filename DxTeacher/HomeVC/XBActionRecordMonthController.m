//
//  XBActionRecordMonthController.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionRecordMonthController.h"
#import "XBNetWorkTool.h"
#import "XBActionRecordMonthModel.h"
#import "XBActionRecordWeekCell.h"

@interface XBActionRecordMonthController ()

@property (nonatomic, strong) NSArray *montyModelArray;

@end

@implementation XBActionRecordMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self requestForData];
}

#pragma mark - 请求页面数据
- (void)requestForData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:@{@"action" : @"getChildMonthActionReport",
                                            @"childid" : _childID}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          self.montyModelArray = [XBActionRecordMonthModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                          // 更新页面数据
                                          [self.tableView reloadData];
                                      });
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                          hud.labelText = @"网络繁忙,请稍后再试!";
                                          [hud hide:YES afterDelay:3.0];
                                      });
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _montyModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBActionRecordWeekCell *cell = [XBActionRecordWeekCell actionRecordWeekCellWith:tableView];
    cell.monthModel = _montyModelArray[indexPath.row];
    return cell;
}

#pragma mark - 设置UI
- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
