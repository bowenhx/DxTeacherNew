//
//  XBAddWeedMonthController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBAddWeedMonthController.h"
#import "XBHeaderView.h"
#import "XBElephantModel.h"
#import "XBNetWorkTool.h"
#import "XBAddWeekRecordCell.h"
#import "XBActionView.h"
#import <TZImagePickerController.h>
#import "XBAddWeekRecordModel.h"
#import "XBAddMonthActionRecordController.h"
#import "XBAddMonthRecordController.h"

@interface XBAddWeedMonthController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (nonatomic, weak) UIButton *lastButton;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) NSInteger sectionIndex;
//@property (nonatomic, weak) XBAddMonthActionRecordController *monthRecordVC;
@property (nonatomic, strong) XBAddMonthRecordController *monthRecordVC;

@end

@implementation XBAddWeedMonthController

#pragma mark - target事件
- (IBAction)weekButtonClick:(UIButton *)sender {
    [self.lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:XBThemeColor forState:UIControlStateNormal];
    self.lastButton = sender;
    self.monthRecordVC.view.hidden = YES;
}

- (IBAction)monthButtonClick:(UIButton *)sender {
    [self.lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:XBThemeColor forState:UIControlStateNormal];
    self.lastButton = sender;
    self.monthRecordVC.view.hidden = NO;
}

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavItem];
    
    [self weekButtonClick:_weekButton];
    
    [self setUpTableView];
    
    [self addChildViewControllers];
    
    [XBNotificationCenter addObserver:self selector:@selector(test:) name:@"test" object:nil];
}

- (void)test:(NSNotification *)notification {
    XBLog(@"%@====%@", notification.object, notification.userInfo);
    NSInteger section = [notification.userInfo[@"tag"] integerValue];
    self.dataDictionary[[NSString stringWithFormat:@"%@", notification.userInfo[@"tag"]]] = notification.object;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    [self.view layoutIfNeeded];
}

#pragma mark - 请求页面数据
- (void)requestForDataWith:(NSString *)week indexForSection:(NSInteger)section selectButton:(UIButton *)button {
    __weak typeof(self) Self = self;
    [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    NSDictionary *parameters = @{@"action" : @"getChildWeekActionReport",
                                 @"uid" : userInfo[@"id"],
                                 @"childid" : _childID,
                                 @"week" : week};
    
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            Self.dataDictionary[[NSString stringWithFormat:@"%ld", section]]= [XBElephantModel mj_objectWithKeyValues:responseObject[@"data"]];
            [Self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            XBLog(@"%@=====%@", error.userInfo.description, error);
            if ([error.userInfo[@"NSDebugDescription"] isEqualToString:@"Invalid value around character 8."]) {
                Self.dataDictionary[[NSString stringWithFormat:@"%ld", section]]= [[XBElephantModel alloc] init];
                [Self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            }else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"网络繁忙,请稍后再试!";
                [hud hide:YES afterDelay:3.0];
            }
        });
    }];
}

- (void)requestForSaveDataWith:(NSString *)content images:(NSArray *)images xid:(NSString *)ID week:(NSString *)week sectionIndex:(NSInteger)sectionIndex {
    __weak typeof(self) Self = self;
    [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    NSDictionary *parameters = nil;
    if (ID.length) {
        parameters = @{@"action" : @"doCreateXWJLWeek",
                       @"uid" : userInfo[@"id"],
                       @"childid" : Self.childID,
                       @"weeks" : week,
                       @"content" : content,
                       @"filecount" : @(images.count - 1),
                       @"xid" : ID};
    }else {
        parameters = @{@"action" : @"doCreateXWJLWeek",
                       @"uid" : userInfo[@"id"],
                       @"childid" : Self.childID,
                       @"weeks" : week,
                       @"content" : content,
                       @"filecount" : @(images.count - 1)};

    }
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:images.count - 1];
    for (int i = 0; i < images.count - 1; i++) {
        XBAddWeekRecordModel *model = images[i];
        NSData *data = UIImageJPEGRepresentation(model.iconImage, 0.5);
        [dataArray addObject:data];
    }
    
    [[XBNetWorkTool shareNetWorkTool] POST:XBURLPREFIXX parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (dataArray.count) {
            for (int i = 0; i < dataArray.count; i++) {
                NSData *data = dataArray[i];
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%d", i + 1] fileName:[NSString stringWithFormat:@"image%d.jpg", i + 1] mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:Self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
            hud.labelText = @"成功!";
            [hud hide:YES afterDelay:3.0];
            // 把内容收起来
            [Self.dataDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld", sectionIndex]];
            [Self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:Self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Self.view animated:YES];
            hud.labelText = @"网络繁忙,请稍后再试!";
            [hud hide:YES afterDelay:3.0];
        });
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataDictionary.allKeys.count == 0) {
        return 0;
    }else {
        for (NSString *key in self.dataDictionary.allKeys) {
            XBLog(@"我是第%@个", key);
            if (key.integerValue == section) {
                return 1;
            }
            continue;
        }
        return 0;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    cell.backgroundColor = [UIColor redColor];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) Self = self;
    XBAddWeekRecordCell *cell = [XBAddWeekRecordCell addWeekRecordCellWith:tableView];
    cell.tag = indexPath.section;
    cell.buttonBlock = ^(NSInteger tag, NSArray *imagesArray) {
        [Self.imagesArray removeAllObjects];
        Self.sectionIndex = tag;
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
        [Self requestForSaveDataWith:content images:images xid:ID week:week sectionIndex:sectionIndex];
    };
    if (indexPath.section == 0) {
        cell.elephantModel = _dataDictionary[@"0"];
    }else if (indexPath.section == 1) {
        cell.elephantModel = _dataDictionary[@"1"];
    }else if (indexPath.section == 2) {
        cell.elephantModel = _dataDictionary[@"2"];
    }else {
        cell.elephantModel = _dataDictionary[@"3"];
    }
    cell.chooseImages = self.imagesArray.copy;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self) Self = self;
    XBHeaderView *headerView = [XBHeaderView headerViewWith:tableView];
    headerView.tag = section;
    headerView.buttonBlock = ^(NSString *week, UIButton *button) {
        if (button.isSelected) {
            // 把内容收起来, 清空缓存
            [Self.imagesArray removeAllObjects];
            Self.imagesArray = nil;
            [Self.dataDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld", section]];
            [Self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        }else {
            [Self requestForDataWith:week indexForSection:section selectButton:button];
            [Self.imagesArray removeAllObjects];
        }
    };
    if (section == 0) {
        headerView.titleLabel.text = @"第四周";
        headerView.elephantModel = _dataDictionary[@"0"];
    }else if (section == 1) {
        headerView.titleLabel.text = @"第三周";
        headerView.elephantModel = _dataDictionary[@"1"];
    }else if (section == 2) {
        headerView.titleLabel.text = @"第二周";
        headerView.elephantModel = _dataDictionary[@"2"];
    }else if (section == 3) {
        headerView.titleLabel.text = @"第一周";
        headerView.elephantModel = _dataDictionary[@"3"];
    }
    return headerView;
}

#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    __weak typeof(self) Self = self;
    UIImage *pickerImage = info[UIImagePickerControllerOriginalImage];
    //    [self.photosView addImageWith:pickerImage];
    XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
    model.iconImage = pickerImage;
    [Self.imagesArray insertObject:model atIndex:0];
    // 选中图片以后应该把图片显示在photosview上
    XBLog(@"%@", info);
    // 这里刷新对应组
    [Self.tableView reloadSections:[NSIndexSet indexSetWithIndex:Self.sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    
    [Self dismissViewControllerAnimated:YES completion:nil];
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
        // 这里刷新对应组
        [Self.tableView reloadSections:[NSIndexSet indexSetWithIndex:Self.sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [Self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 设置导航栏
- (void)setUpNavItem {
    self.title = @"添加周月记录";
    [self.rightBtn setTitle:@"历史" forState:UIControlStateNormal];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
}

// 添加子控制器
- (void)addChildViewControllers {
    XBAddMonthRecordController *monthRecordVC = [[XBAddMonthRecordController alloc] init];
    _monthRecordVC = monthRecordVC;
    monthRecordVC.childid = _childID;
    monthRecordVC.view.hidden = YES;
    monthRecordVC.view.frame = CGRectMake(0, 103, self.view.width, self.view.height - 111);
    [self.view addSubview:monthRecordVC.view];
    [self addChildViewController:monthRecordVC];
}

#pragma mark -懒加载
- (NSMutableDictionary *)dataDictionary {
    if (!_dataDictionary) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

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

- (void)dealloc {
    XBLog(@"%s", __func__);
    [XBNotificationCenter removeObserver:self];
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
