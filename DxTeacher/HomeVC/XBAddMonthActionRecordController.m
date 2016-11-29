//
//  XBAddMonthActionRecordController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define XBItemWidth (kScreenWidth - 60) / 3

#import "XBAddMonthActionRecordController.h"
#import "XBInteractionCell.h"
#import "XBActionView.h"
#import <TZImagePickerController.h>
#import "XBNetWorkTool.h"
#import "XBElephantModel.h"
#import "XBAddWeekRecordCell.h"

@interface XBAddMonthActionRecordController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) XBElephantModel *elephantModel;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) CGFloat tabelViewRowHeight;
@property (nonatomic, assign) CGFloat textViewHeight;

@end

@implementation XBAddMonthActionRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self requestForData];
    
    [self setUpTableView];
}

#pragma mark - 请求页面数据
- (void)requestForData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:@{@"action" : @"getChildMonthActionReport",
                                            @"uid" : userInfo[@"id"],
                                            @"childid" : _childid}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          self.elephantModel = [XBElephantModel mj_objectWithKeyValues:responseObject[@"data"]];
                                          [self calculatRowHeightWith:self.elephantModel.content];
                                          [self convertAlbumsToImagesArrayWith:self.elephantModel.albums];
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

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        }
        cell.textLabel.text = @"请叫我周帅";
        return cell;
    }else {
        __weak typeof(self) Self = self;
        XBAddWeekRecordCell *cell = [XBAddWeekRecordCell addWeekRecordCellWith:tableView];
        cell.tag = indexPath.section;
        cell.elephantModel = self.elephantModel;
        cell.buttonBlock = ^(NSInteger tag, NSMutableArray *imageArray) {
//            [Self.imagesArray removeAllObjects];
//            Self.imagesArray = imageArray;
            //        Self.sectionIndex = tag;
            [XBActionView showActionViewWithSelectIndex:^(NSInteger index) {
                if (index == 0) { // 拍照
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = Self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [Self presentViewController:imagePicker animated:YES completion:nil];
                }else { // 选照片
                    [Self pickPhotoButtonClick];
                }
            }];
        };
        
        // 上传图片block
        cell.saveBlock = ^(NSString *content, NSArray *images, NSString *ID, NSString *week, NSInteger sectionIndex) {
            //        [Self requestForSaveDataWith:content images:images xid:ID week:week sectionIndex:sectionIndex];
        };
        cell.chooseImages = self.imagesArray;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30.0;
    }else {
        return (_tabelViewRowHeight + _textViewHeight) ? (_tabelViewRowHeight + _textViewHeight) : (XBItemWidth + 250);
    }
}

#pragma mark - 私有方法- 存储到字典中对应起来
- (void)pickPhotoButtonClick {
    __weak typeof(self) Self = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:Self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *images, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in images) {
            XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
            model.iconImage = image;
            [Self.imagesArray insertObject:model atIndex:0];
        }
//        if (Self.imagesArray.count <= 3) {
//            Self.tabelViewRowHeight = XBItemWidth;
//        }else if (Self.imagesArray.count <= 6) {
//            Self.tabelViewRowHeight = 2 * XBItemWidth + 8;
//        }else {
//            Self.tabelViewRowHeight = 3 * XBItemWidth + 8;
//        }
        // 这里刷新对应组
        [Self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [Self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 私有方法
// 转换图片链接为模型数据
- (void)convertAlbumsToImagesArrayWith:(NSArray *)albums {
    for (XBAlbumsModel *albumModel in albums) {
        XBAddWeekRecordModel *recordModel = [[XBAddWeekRecordModel alloc] init];
        recordModel.imagePath = [XBURLHEADER stringByAppendingString:albumModel.thumb_path];
        [self.imagesArray addObject:albumModel];
    }
    if (_imagesArray.count <= 3) {
        _tabelViewRowHeight = XBItemWidth;
    }else if (_imagesArray.count <= 6) {
        _tabelViewRowHeight = 2 * XBItemWidth + 8;
    }else {
        _tabelViewRowHeight = 3 * XBItemWidth + 8;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)calculatRowHeightWith:(NSString *)content {
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:NULL];
    _textViewHeight = textRect.size.height;
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 懒加载
- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
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
