//
//  XBActionRecordController.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/21.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionRecordController.h"
#import "XBActionRecordCell.h"
#import "XBActionRecordNoTitleCell.h"
#import "XBActionRecordTextCell.h"
#import "XBNetWorkTool.h"
#import "XBActionRecordBaseModel.h"
#import "XBActionRecordModel.h"
#import "XBActionRecordDayCell.h"
#import "UIImageView+WebCache.h"
#import "AppDefine.h"
#import "XBAddActionRecordController.h"
//=============子控制器==================
#import "XBActionRecordWeekController.h"
#import "XBActionRecordMonthController.h"

@interface XBActionRecordController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, assign, getter=isShowText) BOOL showText;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;
@property (nonatomic, strong) XBActionRecordBaseModel *baseModel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) XBActionRecordWeekController *weekVC;
@property (nonatomic, weak) XBActionRecordMonthController *monthVC;

@end

@implementation XBActionRecordController

#pragma mark - target事件
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    XBAddActionRecordController *recordVC = [[XBAddActionRecordController alloc] init];
    recordVC.childID = self.baseModel.Childid;
    recordVC.childName = self.baseModel.Childname;
    recordVC.actiontypes = self.baseModel.Actiontypes;
    recordVC.finishBlock = ^() {
        if (_requestBlock) {
            self.requestBlock();
        }
    };
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (IBAction)segmentControlClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        [self.view addSubview:self.weekVC.view];
        [self.monthVC.view removeFromSuperview];
    }else if (sender.selectedSegmentIndex == 2) {
        [self.view addSubview:self.monthVC.view];
        [self.weekVC.view removeFromSuperview];
    }else {
        [self.weekVC.view removeFromSuperview];
        [self.monthVC.view removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavItem];
    
    if (kScreenWidth == 320) {
        for (UILabel *label in self.labelArray) {
            label.font = [UIFont systemFontOfSize:10];
        }
    }
    
    [self setUpTableView];
    
    [self requestForData];
    
    // 添加子控制器
    [self addChildViewControllers];
    
    [self segmentControlClick:nil];
}

- (void)addChildViewControllers {
    XBActionRecordWeekController *weekVC = [[XBActionRecordWeekController alloc] init];
    _weekVC = weekVC;
    weekVC.childID = _childID;
    weekVC.view.frame = CGRectMake(0, 245 + 8, kScreenWidth, kScreenHeight - 245 - 8);
    [self.view addSubview:weekVC.view];
    [self addChildViewController:weekVC];
    
    XBActionRecordMonthController *monthVC = [[XBActionRecordMonthController alloc] init];
    _monthVC = monthVC;
    monthVC.childID = _childID;
    monthVC.view.frame = CGRectMake(0, 245 + 8, kScreenWidth, kScreenHeight - 245 - 8);
    [self.view addSubview:monthVC.view];
    [self addChildViewController:monthVC];
}

#pragma mark - 请求页面数据
- (void)requestForData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:@{@"action" : @"getChildDayActionReport",
                                            @"childid" : _childID}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          self.baseModel = [XBActionRecordBaseModel mj_objectWithKeyValues:responseObject[@"data"]];
                                          // 更新页面数据
                                          [self renewLabelDataWith:self.baseModel];
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

- (void)renewLabelDataWith:(XBActionRecordBaseModel *)baseModel {
    _nameLabel.text = baseModel.Childname;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[XBURLHEADER stringByAppendingString:baseModel.Childavator]] placeholderImage:[UIImage imageNamed:@"占位图"] options:SDWebImageRetryFailed];
    
    for (XBActionRecordModel *actionModel in baseModel.Actiontypes) {
        if ([actionModel.Name isEqualToString:@"性格"]) {
            UILabel *label = _labelArray[3];
            label.text = [NSString stringWithFormat:@"性格%ld项",(long) actionModel.Items.count];
        }else if ([actionModel.Name isEqualToString:@"能力"]) {
            UILabel *label = _labelArray[0];
            label.text = [NSString stringWithFormat:@"能力%ld项",(long)actionModel.Items.count];
        }else if ([actionModel.Name isEqualToString:@"习惯"]) {
            UILabel *label = _labelArray[4];
            label.text = [NSString stringWithFormat:@"习惯%ld项",(long) actionModel.Items.count];
        }else if ([actionModel.Name isEqualToString:@"思维"]) {
            UILabel *label = _labelArray[2];
            label.text = [NSString stringWithFormat:@"思维%ld项",(long) actionModel.Items.count];
        }else if ([actionModel.Name isEqualToString:@"特长"]) {
            UILabel *label = _labelArray[1];
            label.text = [NSString stringWithFormat:@"特长%ld项",(long) actionModel.Items.count];
        }
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _baseModel.Actiontypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XBActionRecordModel *recordModel = _baseModel.Actiontypes[section];
    return recordModel.Items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBActionRecordDayCell *cell = [XBActionRecordDayCell actionRecordDayCellWith:tableView];
    cell.secondModel = (XBActionRecordSecondModel *)[_baseModel.Actiontypes[indexPath.section] Items][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, kScreenWidth, 20.0);
    backView.backgroundColor = [UIColor colorCellHeadBg];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 0, kScreenWidth, 20.0);
    // 61 203 154
    titleLabel.textColor = [UIColor colorWithRed:61 / 255.0 green:203 / 255.0 blue:154 / 255.0 alpha:1.0];
    [backView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:17];
    XBActionRecordModel *actionRecordModel = _baseModel.Actiontypes[section];
    titleLabel.text = actionRecordModel.Name;
    return backView;
}

#pragma mark - 设置UI
- (void)setUpNavItem {
    self.title = [NSString stringWithFormat:@"%@的行为报告", _name];

    for (int i=0; i<5; i++) {
        UIButton *btn = [self.view viewWithTag:20+i];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
    }
    
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _iconImageView.layer.cornerRadius = 30.0;
    _iconImageView.layer.masksToBounds = YES;
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
