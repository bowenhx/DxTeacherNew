//
//  FindDetailViewController.m
//  DxTeacher
//
//  Created by ligb on 16/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "FindDetailViewController.h"
#import "FindDetailTableViewCell.h"
#import "ItemVIewsHeight.h"
#import "AppDefine.h"
@interface FindDetailViewController ()
{
    __weak IBOutlet UITableView *_tableView;
    
}
@end

@implementation FindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
}
- (void)loadNewData{

    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getNewsContent",@"cid":@(_cid)} completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            //请求成功
            [self.dataSource setArray:@[model.data]];
            [_tableView reloadData];
            
            if (self.dataSource.count == 0) {
                [self.view showHUDTitleView:@"此分类暂无数据" image:nil];
            }
            
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
    
}

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *xibName = @"FindDetailTableViewCell";
    FindDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.dataSource[indexPath.row];
    cell.imagesView.viewController = self;
    return cell;
    
    
}

- (CGFloat)itemsImages:(NSDictionary *)item{
    NSArray *items = item[@"albums"];
    
    return [ItemVIewsHeight loadItmesCounts:items.count] + [ItemVIewsHeight loadTextContentsMaxWidth:16 string:item[@"zhaiyao"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self itemsImages:self.dataSource[indexPath.row]];
    return 110 + height;
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
