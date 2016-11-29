//
//  DeedViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
//
#define SPACE 20  //图片间隔20
#import "DeedViewController.h"
#import "AppDefine.h"
#import "ItemViewBtn.h"
#import "XBAddActionRecordController.h"
#import "XBNetWorkTool.h"
#import "XBRecordListCell.h"
#import "XBActionRecordController.h"

@interface DeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation DeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行为记录";
    
    // 默认插入第一个
    _dataList = [NSMutableArray arrayWithCapacity:1];
    XBRecordListModel *listModel = [[XBRecordListModel alloc] init];
    listModel.user_name = @"全班";
    listModel.hideLabel = YES;
    [_dataList addObject:listModel];
    
    [self requestForData];
}

#pragma mark - 请求页面数据
- (void)requestForData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:@{@"action" : @"getChildList",
                                                                    @"uid" : userInfo[@"id"]}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.dataList addObjectsFromArray:[XBRecordListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.collectionView reloadData];
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

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XBRecordListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XBRecordListCell" forIndexPath:indexPath];
    cell.listModel = _dataList[indexPath.row];
    return cell;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XBRecordListModel *listModel = _dataList[indexPath.row];
    if (listModel.isHideLabel) {
        XBAddActionRecordController *addVC = [[XBAddActionRecordController alloc] init];
        addVC.finishBlock = ^() {
            [self.dataList removeObjectsInRange:NSMakeRange(1, self.dataList.count - 1)];
            [self requestForData];
        };
        [self.navigationController pushViewController:addVC animated:YES];
    }else {
        XBActionRecordController *recordVC = [[XBActionRecordController alloc] init];
        recordVC.childID = listModel.childid;
        recordVC.name = listModel.user_name;
        recordVC.requestBlock = ^() {
            [self.dataList removeObjectsInRange:NSMakeRange(1, self.dataList.count - 1)];
            [self requestForData];
        };
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

//- (void)loadNewView{
//    [self.rightBtn setImage:[UIImage imageNamed:@"dte_vi_Add_1"] forState:0];
//    [self.rightBtn setTitle:@"添加" forState:0];
//    
//   
//   
//    
//    NSArray *items = @[@[@"vi_xwjl_add",@"全班"]];
//    
//    [self addItemView:items];
//    
//}

//- (void)addItemView:(NSArray *)items{
//    float btn_wh = (self.screen_W - SPACE * 4) / 3;
//    for (int i= 0; i<items.count; i++) {
//        float addBtnX = SPACE + (SPACE + btn_wh) * (i%3);
//        float addBtnY = 84 + (SPACE + btn_wh) * (i/3);
//        
//        ItemViewBtn *iView = [[ItemViewBtn alloc] initWithFrame:CGRectMake(addBtnX, addBtnY, btn_wh, btn_wh)];
//        iView.itemImgs = items[i][0];
//        iView.titles = items[i][1];
//        iView.tag = i;
//        [self.view addSubview:iView];
//        iView.itemBtn.tag = i;
//        [iView.itemBtn addTarget:self action:@selector(didSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
//        [iView.labTitle setY:iView.labTitle.y + 15];
//        iView.itemBtn.layer.borderWidth = 1;
//        iView.itemBtn.layer.borderColor = [UIColor colorLineBg].CGColor;
//        iView.itemBtn.layer.cornerRadius = 2;
//    }
//}

//- (void)didSelectIndex:(UIButton *)btn{
//    XBAddActionRecordController *addVC = [[XBAddActionRecordController alloc] init];
//    [self.navigationController pushViewController:addVC animated:YES];
//}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 4 * SPACE) / 3, (kScreenWidth - 4 * SPACE) / 3);
        flowLayout.minimumLineSpacing = SPACE;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = SPACE;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"XBRecordListCell" bundle:nil] forCellWithReuseIdentifier:@"XBRecordListCell"];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
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
