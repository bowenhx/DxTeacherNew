//
//  XBLeaveController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBLeaveController.h"
#import "XBNetWorkTool.h"
#import "XBLeaveCell.h"

@interface XBLeaveController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation XBLeaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpTableView];
    
    [self requestForData];
}

#pragma mark - 请求页面数据
- (void)requestForData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    NSDictionary *parameters = @{@"action" : @"getLeaveList",
                                 @"uid" : userInfo[@"id"]};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.dataList = [XBLeaveModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    XBLeaveCell *cell = [XBLeaveCell leaveCellWith:tableView];
    cell.tag = indexPath.row;
    __weak typeof(self) Self = self;
    cell.buttonBlock = ^(NSInteger tag) {
        XBLeaveModel *model = Self.dataList[tag];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请假理由:" message:model.content delegate:Self cancelButtonTitle:model.user_name otherButtonTitles:nil];
        [alertView show];
    };
    cell.leaveModel = _dataList[indexPath.row];
    return cell;
}

#pragma mark - 设置UI
- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 76;
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
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
