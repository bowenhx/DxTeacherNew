//
//  XBAddActionRecordController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBAddActionRecordController.h"
#import "XBAddRecordCell.h"
#import "XBNetWorkTool.h"
#import "XBAlertView.h"
#import "AppDefine.h"
#import "XBAddWeedMonthController.h"
#import "XBActionRecordModel.h"

@interface XBAddActionRecordController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *improveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, weak) UIButton *lastButton;


@end

@implementation XBAddActionRecordController

- (NSString *)valueTagString:(UIButton *)btn{
    UILabel *tempLab = [self.view viewWithTag:btn.tag - 10];
    return tempLab.text;
}

#pragma mark - target事件
- (IBAction)abilityButtonClick:(UIButton *)sender { // 能力
    _lastButton.selected = NO;
    sender.selected = YES;
    _lastButton = sender;
    [self requestForDataWith:[self valueTagString:sender]];
}

- (IBAction)customButtonClick:(UIButton *)sender { // 特长
    _lastButton.selected = NO;
    sender.selected = YES;
    _lastButton = sender;
    [self requestForDataWith:[self valueTagString:sender]];
}

- (IBAction)natureButtonClick:(UIButton *)sender { // 思维
    _lastButton.selected = NO;
    sender.selected = YES;
    _lastButton = sender;
    [self requestForDataWith:[self valueTagString:sender]];
}

- (IBAction)healthButtonClick:(UIButton *)sender { //性格
    _lastButton.selected = NO;
    sender.selected = YES;
    _lastButton = sender;
    [self requestForDataWith:[self valueTagString:sender]];
}

- (IBAction)improveButtonClick:(UIButton *)sender { // 习惯
    _lastButton.selected = NO;
    sender.selected = YES;
    _lastButton = sender;
    [self requestForDataWith:[self valueTagString:sender]];
}

// 右边导航栏点击事件
- (void)tapRightBtn {
    XBAddWeedMonthController *addVC = [[XBAddWeedMonthController alloc] init];
    addVC.childID = _childID;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    _improveButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self setUpTableView];
    
    // 第一次进入的时候调用
    [self abilityButtonClick:_improveButton];
}

#pragma mark - 请求页面数据
- (void)requestForDataWith:(NSString *)string {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"action" : @"getXWJLChildNames",
                                 @"name" : string};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.dataList = [XBAddActionRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

#pragma mark - 发布记录行为
- (void)requestForDataWith:(NSString *)ID content:(NSString *)content {
    __weak typeof(self) Self = self;
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:@{
                                                                   @"action":@"doCreateXWJLDayByGradeID",
                                                                   @"uid" : userInfo[@"id"],
                                                                   @"aid" : ID,
                                                                   @"content" : content}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [MBProgressHUD hideHUDForView:Self.view animated:YES];
                                                                  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
                                                                  hud.labelText = @"发布成功!";
                                                                  [hud hide:YES afterDelay:2.0];
                                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                      if (Self.finishBlock) {
                                                                          Self.finishBlock();
                                                                      }
                                                                  });
                                                              });
                                                                   }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                      hud.labelText = @"网络繁忙,请稍后再试!";
                                                                      [hud hide:YES afterDelay:3.0];
                                                                  });
                                                                   }];
}

#pragma mark - 发布小孩记录行为
- (void)requestForDataWithSingleChild:(NSString *)ID content:(NSString *)content {
    __weak typeof(self) Self = self;
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    NSDictionary *parameters = @{@"action" : @"doCreateXWJLDay",
                                 @"uid" : userInfo[@"id"],
                                 @"aid" : ID,
                                 @"content" : content,
                                 @"childid" : Self.childID};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:Self.view animated:YES];
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
                                          hud.labelText = @"发布成功!";
                                          [hud hide:YES afterDelay:2.0];
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                              if (Self.finishBlock) {
                                                  Self.finishBlock();
                                              }
                                          });
                                      });
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                          hud.labelText = @"网络繁忙,请稍后再试!";
                                          [hud hide:YES afterDelay:3.0];
                                      });
                                  }];
}

#pragma mark -tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) Self = self;
    XBAddActionRecordModel *recordModel = _dataList[indexPath.row];
    XBAddRecordCell *cell = [XBAddRecordCell addRecordCellWith:tableView];
    cell.actionActionModel = _dataList[indexPath.row];
    cell.buttonClick = ^(NSString *title) {
        [XBAlertView showAlertViewWith:title placeHolderString:@"请输入文字~" cancelButtonBlock:^{} confirmBlock:^(NSString *content) {
            if (Self.childID) {
                [Self requestForDataWithSingleChild:recordModel.ID content:content];
            }else {
                [Self requestForDataWith:recordModel.ID content:content];
            }
        }];
    };
    return cell;
}

#pragma mark - 设置UI
- (void)setUpTableView {
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.contentInset = UIEdgeInsetsMake(50, 0, 50, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 65;
    
    self.title = _childName ? [NSString stringWithFormat:@"为%@添加", _childName] : @"为全班添加";
    if (!_childID) {
        self.rightBtn.hidden = YES;
    }
    [self.rightBtn setImage:[UIImage imageNamed:@"dte_vi_Add_1"] forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    
    for (int i=0; i<self.actiontypes.count; i++) {
        XBActionRecordModel *actionModel = self.actiontypes[i];
        UILabel *label = [self.view viewWithTag:10+i];
        if (label) {
            label.text = actionModel.Name;
        }
    }
    
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
