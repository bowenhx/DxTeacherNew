//
//  CollectViewController.m
//  DxTeacher
//
//  Created by ligb on 16/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "CollectViewController.h"
#import "FindTableViewCell.h"

@interface CollectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的收藏";
}

- (void)loadNewData{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    [[ANet share] post:BASE_URL params:@{@"action":@"getFavorite",@"type":@(1),@"uid":info[@"id"]} completion:^(BNetData *model, NSString *netErr) {
        
        NSLog(@"data = %@",model.data);
        
        if (model.status == 0) {
            [self.dataSource setArray:model.data];
            [self.tableView reloadData];
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
    static NSString *xibName = @"FindTableViewCell";
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
    }
    
    cell.info = self.dataSource[indexPath.section];
    cell.collect.tag = indexPath.section;
    cell.collect.selected = YES;
    [cell.collect addTarget:self action:@selector(cancelCollectAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)cancelCollectAction:(UIButton *)btn{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    //取消收藏
    NSDictionary *dict = @{@"action":@"doFavorite",
                 @"uid":info[@"id"],
                 @"fid":self.dataSource[btn.tag][@"id"]
                 };
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:dict completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        NSLog(@"data = %@",model.data);
        
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else if (model.status == 0) {
            [self.view showSuccess:model.message];
            [self performSelector:@selector(loadNewData) withObject:nil afterDelay:.7];
            
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];

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
