//
//  DetailViewController.m
//  DxTeacher
//
//  Created by ligb on 16/10/31.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDefine.h"
#import "ItemVIewsHeight.h"
#import "ReportTableViewCell.h"
#import "BKReplyInputView.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,InputDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    NSInteger       _commentId;
}
@property (nonatomic , strong)BKReplyInputView *replyView;
@end

@implementation DetailViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reportNotificationCenter" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    
    //添加互动投诉 回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"reportNotificationCenter" object:nil];
}
- (void)loadNewData{
    _commentId = 0;
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
- (BKReplyInputView *)replyView{
    if (!_replyView) {
        _replyView = [[BKReplyInputView alloc] initWithFrame:CGRectMake(0, self.screen_H- 300, self.screen_W, 300)];
        _replyView.delegate = self;
        [self.view addSubview:_replyView];
        
       
    }
    return _replyView;
}
- (void)handleNotification:(NSNotification *)notification{
    NSDictionary *info = [notification object];
    NSLog(@"info -= %@",info);
    [self.replyView setY:self.screen_H - 300];
    self.replyView.replyTag = [info[@"inputID"] integerValue];
    _commentId = [info[@"commentid"] integerValue];
    
    [self.replyView.textView becomeFirstResponder];
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
    static NSString *xibName = @"ReportTableViewCell";
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.dataSource[indexPath.row];
    cell.btnCheck.tag = indexPath.row;
    cell.imagesView.viewController = self;
    //添加回复button
    [cell.btnCheck addTarget:self action:@selector(didDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
    
}
- (void)didDetailAction:(UIButton *)btn{
    //回复互动投诉
    self.replyView.replyTag = [self.dataSource[btn.tag][@"id"] integerValue];
    [self.replyView.textView becomeFirstResponder];
    
}
- (CGFloat)itemsImages:(NSDictionary *)item{
    NSArray *items = item[@"albums"];
    return [ItemVIewsHeight loadItmesCounts:items.count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self itemsImages:self.dataSource[indexPath.row]];
    NSArray *comment = self.dataSource[indexPath.row][@"comment"];
    float comH = comment.count * 25;
    return 195 + height + comH;
}
#pragma mark  回复
#pragma mark InputDeledate
//发表回复
- (void)replyInputWithText:(NSString *)replyText appendTag:(NSInteger)inputTag{
    if ([@"" isStringBlank:replyText]) {
        [self.view showHUDTitleView:@"请添加描述文字再评论" image:nil];
        return;
    }
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File];
    NSDictionary *info = @{@"action":@"doNewsComment",
                           @"id":@(inputTag),
                           @"commentid":@(_commentId),
                           @"userid":userInfo[@"id"],
                           @"username":userInfo[@"nick_name"],
                           @"content":replyText
                           };
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:info completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        //提示
        [self.view showHUDTitleView:model.message image:nil];
        if (model.status == 0) {
            //重新载入互动投诉接口id
            [self performSelector:@selector(loadNewData) withObject:nil afterDelay:.7];
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
