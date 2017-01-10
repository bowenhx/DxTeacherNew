//
//  CircleViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "CircleViewController.h"
#import "TrendsTableViewCell.h"
#import "ItemVIewsHeight.h"
#import "AppDefine.h"
#import "PoppingTabView.h"
#import "SendMegViewController.h"
#import "DetailViewController.h"
@interface CircleViewController ()<PoppingTabViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    UIButton *_titleBtn;//标题title
    NSUInteger _page;
}
@property (nonatomic , strong) PoppingTabView   *popTabView;        //弹窗tabView
@property (nonatomic , strong) UITableView      *typeTabView;
@property (nonatomic , assign) NSInteger aidIndex;
@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     self.navigationItem.title = @"班级圈";
    
    _aidIndex = 52;
}

- (void)loadNewView{
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake(120, 0, self.screen_W - 240, 40);
    [_titleBtn setTitle:@"班级圈" forState:0];
    [_titleBtn addTarget:self action:@selector(selectTitleType:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleBtn;
    [self.rightBtn setImage:[UIImage imageNamed:@"dte_vi_Add_1"] forState:0];
    [self.rightBtn setTitle:@"发布" forState:0];
    
    NSArray *types = @[@"通知通告",@"精彩瞬间",@"每周食谱",@"课程计划",@"园所安全"];
    self.popTabView.itemArrs = types;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefreshingAction)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadingAction)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView.mj_header beginRefreshing];
  
}


#pragma mark popView
- (PoppingTabView *)popTabView{
    if (!_popTabView) {
        _popTabView = [[PoppingTabView alloc] initWithFrame:CGRectMake( (self.screen_W - 100)/2, -200, 100, 200)];
        _popTabView.delegate = self;
        _popTabView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"xinxi"]];
        [self.view addSubview:_popTabView];
//        _popTabView.layer.borderWidth = 1;
//        _popTabView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _popTabView;
}

//下拉刷新
- (void)beginRefreshingAction{
    [self loadViewData];
}
//上拉加载更多
- (void)uploadingAction{
    _page ++;
    self.aidIndex = _aidIndex;
}


#pragma mark 发布
- (void)tapRightBtn{
   
    //检查发布权限
    [self sendJurisdictionManageBlock:^(bool bPush) {
        if (bPush == 0) {
            SendMegViewController *sendMegVC = [[SendMegViewController alloc] initWithNibName:@"SendMegViewController" bundle:nil];
            if ([_titleBtn.titleLabel.text isEqualToString:@"班级圈"]) {
                sendMegVC.title = @"发布通知通告";
            }else{
                sendMegVC.title = [NSString stringWithFormat:@"发布%@",_titleBtn.titleLabel.text];
            }
            sendMegVC.index = _aidIndex;
            [self.navigationController pushViewController:sendMegVC animated:YES];
        }
    }];
}
- (void)selectTitleType:(UIButton *)button{
    [self showPopSubTabView];
}

- (void)showPopSubTabView
{
    [UIView animateWithDuration:.35 animations:^{
         [_popTabView setY:64];
    } completion:^(BOOL finished) {
        [self changeViewStatus:YES];
    }];
    
}
- (void)hiddenPopSubTabView
{
    [UIView animateWithDuration:.35 animations:^{
        [_popTabView setY:-_popTabView.h];
    } completion:^(BOOL finished) {
        [self changeViewStatus:NO];
    }];
    
}
//改变视图状态背景色
- (void)changeViewStatus:(BOOL)status
{
    if (status) {
        _tableView.userInteractionEnabled   = NO;
        self.view.backgroundColor          = [UIColor grayColor];
       _tableView.backgroundColor          = [UIColor grayColor];
        _tableView.alpha                   = .4;
        
    }else{
        _tableView.userInteractionEnabled   = YES;
        self.view.backgroundColor           =  RGB(240, 239, 245);
       _tableView.backgroundColor          =  RGB(240, 239, 245);
       _tableView.alpha                    = 1;
    }
}
//控制点击页面其他位置区域去隐藏选择框操作
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenPopSubTabView];
}
- (void)loadViewData{
    _page = 1;
    self.aidIndex = _aidIndex;

}
//判断发布权限
- (void)sendJurisdictionManageBlock:(void(^)(bool bPush))block{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    NSLog(@"info = %@",info);
    [[ANet share] post:BASE_URL params:@{@"action":@"checkDoPublishAuth",@"uid":info[@"id"],@"categoryid":@(_aidIndex)} completion:^(BNetData *model, NSString *netErr) {
        
        NSLog(@"data = %@",model.data);
        block (model.status);
        if (model.status == 0) {
           
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}
//请求列表数据
- (void)setAidIndex:(NSInteger)aidIndex{
    _aidIndex = aidIndex;
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getNewsList",@"aid":@(aidIndex),@"page":@(_page)} completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            //请求成功
            NSArray *array = model.data;
            if ( _page == 1 ) {
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    [self.dataSource setArray:model.data];
                    [_tableView.mj_footer resetNoMoreData];
                }
            }else{
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.dataSource addObject:obj];
                    }];
                }else{
                    [self.view showHUDTitleView:@"没有更多数据" image:nil];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            [_tableView reloadData];
            
            if (self.dataSource.count == 0) {
                [self.view showHUDTitleView:@"此分类暂无数据" image:nil];
            }
            
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
        [_tableView endRefreshing];
        
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
    static NSString *xibName = @"TrendsTableViewCell";
    TrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.dataSource[indexPath.row];
    cell.btnCheck.tag = indexPath.row;
    cell.imagesView.viewController = self;
    [cell.btnCheck setTitle:@"详情" forState:UIControlStateNormal];
    [cell.btnCheck addTarget:self action:@selector(didDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
        
    
}

- (CGFloat)itemsImages:(NSDictionary *)item{
    NSArray *items = item[@"albums"];
    return [ItemVIewsHeight loadItmesCounts:items.count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [ItemVIewsHeight loadTextContentsMaxWidth:95 string:self.dataSource[indexPath.row][@"zhaiyao"]] + [self itemsImages:self.dataSource[indexPath.row]];
    return 114 + height;
}
- (void)didDetailAction:(UIButton *)btn{
    
    DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detail.cid = [self.dataSource[btn.tag][@"id"] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark PoppingTableViewDelegate
- (void)selectItem:(id)obj index:(NSInteger)index{
    _page = 1;
    if (index == 0) {
        self.aidIndex = 52;
    }else{
        self.aidIndex = index + 61;
    }
    
    [_titleBtn setTitle:obj forState:0];
    [self hiddenPopSubTabView];
    
     NSLog(@"obj = %@,aid = %ld",obj,(long)self.aidIndex);
    
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
