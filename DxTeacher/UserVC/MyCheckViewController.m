//
//  MyCheckViewController.m
//  DxTeacher
//
//  Created by ligb on 16/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "MyCheckViewController.h"
#import "MyCheckTabCell.h"
#import "NewCheckViewController.h"

@interface MyCheckViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end

@implementation MyCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤";
    
    [self.rightBtn setTitle:@"新建" forState:0];
}

- (void)tapRightBtn{
    NewCheckViewController *newCheckVC = [[NewCheckViewController alloc] initWithNibName:@"NewCheckViewController" bundle:nil];
    [self.navigationController pushViewController:newCheckVC animated:YES];
}

- (void)loadNewData{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    [[ANet share] post:BASE_URL params:@{@"action":@"getSelfLeaveReport",@"uid":info[@"id"]} completion:^(BNetData *model, NSString *netErr) {
        
        NSLog(@"data = %@",model.data);
        
        if (model.status == 0) {
            [self.dataSource setArray:model.data];
            [self.tableVIew reloadData];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *xibName = @"MyCheckTabCell";
    MyCheckTabCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.info = self.dataSource[indexPath.section];
    return cell;
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
