//
//  DrugManageViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "DrugManageViewController.h"
#import "DrugManageTableViewCell.h"
#import "AppDefine.h"
#import "NewUseDrugViewController.h"

@interface DrugManageViewController ()
{
    __weak IBOutlet UITableView *_tableView;
    
}
@end

@implementation DrugManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用药条管理";
    
    [self.rightBtn setTitle:@"新建" forState:0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"refreshLoadDrugdata" object:nil];
}

- (void)loadNewData{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    NSLog(@"info = %@",info);
    [[ANet share] post:BASE_URL params:@{@"action":@"getDrugSearch",@"gradeid":info[@"grade_id"]} completion:^(BNetData *model, NSString *netErr) {
        
        NSLog(@"data = %@",model.data);
        
        if (model.status == 0) {
            [self.dataSource setArray:model.data];
            [_tableView reloadData];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];

}
- (void)tapRightBtn{
    NewUseDrugViewController *newUseDrugVC = [[NewUseDrugViewController alloc] initWithNibName:@"NewUseDrugViewController" bundle:nil];
    newUseDrugVC.title = @"新建药条";
    [self.navigationController pushViewController:newUseDrugVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *xibName = @"DrugManageTableViewCell";
    DrugManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.info = self.dataSource[indexPath.section];
    cell.btnUseDrug.tag = indexPath.section;
    cell.btnUse.tag = indexPath.section;
    [cell.btnUse addTarget:self action:@selector(didSelectUserLog:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnUseDrug addTarget:self action:@selector(selectUseAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)selectUseAction:(UIButton *)btn{
    NewUseDrugViewController *newUseDrugVC = [[NewUseDrugViewController alloc] initWithNibName:@"NewUseDrugViewController" bundle:nil];
    newUseDrugVC.dictionary = self.dataSource[btn.tag];
    newUseDrugVC.title = @"用药条";
    [self.navigationController pushViewController:newUseDrugVC animated:YES];
}
- (void)didSelectUserLog:(UIButton *)btn{
    
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
