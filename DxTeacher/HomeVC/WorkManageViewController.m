//
//  WorkManageViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/27.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "WorkManageViewController.h"
#import "AppDefine.h"
#import "XBLeaveController.h"


@interface WorkManageViewController ()
{
    __weak IBOutlet UISegmentedControl *_segmentedControl;
    
    __weak IBOutlet UITableView *_tableView;
    
}
@property (nonatomic, weak) XBLeaveController *leaveVC;

@end

@implementation WorkManageViewController

#pragma makr - target事件
- (IBAction)segmentClick:(UISegmentedControl *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤管理";
    
    // 添加子控制器
    [self addChildViewControllers];
}

#pragma mark - 私有方法
- (void)addChildViewControllers {
    XBLeaveController *leaveVC = [[XBLeaveController alloc] init];
    leaveVC.view.frame = CGRectMake(0, 134, self.view.width, self.view.height - 134);
    _leaveVC = leaveVC;
    [self.view addSubview:leaveVC.view];
    [self addChildViewController:leaveVC];
}

- (void)loadNewView{
    [super loadNewView];
    _segmentedControl.tintColor = [UIColor colorAppBg];
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
