//
//  XBAddMonthRecordController.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define XBImageMargin 20
#define XBItemWidth (kScreenWidth - 60) / 3

#import "XBAddMonthRecordController.h"
#import "XBInteractionCell.h"
#import "XBActionView.h"
#import <TZImagePickerController.h>
#import "XBNetWorkTool.h"
#import "XBElephantModel.h"

@interface XBAddMonthRecordController () <UICollectionViewDataSource, UICollectionViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) XBElephantModel *elephantModel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation XBAddMonthRecordController

#pragma mark - target事件
- (IBAction)saveButtonClick:(UIButton *)sender {
    if (_textView.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"请输入文字~";
        [hud hide:YES afterDelay:3.0];
        return;
    }
    [self saveData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpUI];
    
    [self requestForData];
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
            _textView.text = self.elephantModel.content;
            _saveButton.hidden = YES;
            _textView.userInteractionEnabled = NO;
            _titleLabel.text = self.elephantModel.title;
            [self convertAlbumsToImagesArrayWith:self.elephantModel.albums];
            [self.collectionView reloadData];
        });
    }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      XBLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([error.userInfo[@"NSDebugDescription"] isEqualToString:@"Invalid value around character 8."]) {
                [self requestNoData];
            }else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"网络繁忙,请稍后再试!";
                [hud hide:YES afterDelay:3.0];
            }
        });
    }];
}

// 保存页面数据
- (void)saveData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *dataArray = [NSMutableArray array];
    if (_imagesArray.count > 1) {
        for (int i = 0; i < _imagesArray.count - 1; i++) {
            UIImage *image = [_imagesArray[i] iconImage];
            XBLog(@"======%@", image);
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [dataArray addObject:imageData];
        }
    }
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    NSDictionary *parameters = @{@"action" : @"doCreateXWJLMonth",
                                 @"uid" : userInfo[@"id"],
                                 @"childid" : _childid,
                                 @"title" : _titleLabel.text,
                                 @"content" : _textView.text,
                                 @"filecount" : @(_imagesArray.count - 1)};
    [[XBNetWorkTool shareNetWorkTool] POST:XBURLPREFIXX parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (dataArray.count) {
            for (int i = 0; i < dataArray.count; i++) {
                NSData *data = dataArray[i];
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%d", i + 1] fileName:[NSString stringWithFormat:@"image%d.jpg", i + 1] mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"发送成功!";
            _textView.text = nil;
            [_imagesArray removeAllObjects];
            _imagesArray = nil;
            [hud hide:YES afterDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestForData];
            });
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
    return _imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XBInteractionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XBInteractionCell" forIndexPath:indexPath];
    XBAddWeekRecordModel *model = _imagesArray[indexPath.item];
    cell.recordModel = model;
    cell.tag = indexPath.item;
    __weak typeof(self) Self = self;
    cell.deleteBlock = ^(NSInteger tag) {
        //        if (model.isVideo) {
        //            Self.uploadData = nil;
        //        }
        [Self.imagesArray removeObjectAtIndex:tag];
        // 确定collectionView的高度
        if (Self.imagesArray.count <= 3) {
            Self.collectionViewHeight.constant = XBItemWidth;
        }else if (_imagesArray.count <= 6) {
            Self.collectionViewHeight.constant = 2 * XBItemWidth + 8;
        }else {
            Self.collectionViewHeight.constant = 3 * XBItemWidth + 8;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Self.collectionView reloadData];
        });
    };
    return cell;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.elephantModel) {
        if (indexPath.item == _imagesArray.count - 1) {
            [self.view endEditing:YES];
            [XBActionView showActionViewWithSelectIndex:^(NSInteger index) {
                if (index == 0) { // 拍照
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }else { // 选照片
                    [self pickPhotoButtonClick];
                }
            }];
        }
    }
}

#pragma mark - UINavigationControllerDelegate,UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickerImage = info[UIImagePickerControllerOriginalImage];
    //    [self.photosView addImageWith:pickerImage];
    XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
    model.iconImage = pickerImage;
    [self.imagesArray insertObject:model atIndex:0];
    // 选中图片以后应该把图片显示在photosview上
    XBLog(@"%@", info);
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *images, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in images) {
            XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
            model.iconImage = image;
            [_imagesArray insertObject:model atIndex:0];
        }
        [self.collectionView reloadData];
    }];
    //    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
    //
    //    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & originalPhoto or not
    // 设置是否可以选择视频/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        XBLog(@"%@", textView.text);
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

// 转换图片链接为模型数据
- (void)convertAlbumsToImagesArrayWith:(NSArray *)albums {
    self.imagesArray = [NSMutableArray arrayWithCapacity:albums.count];
    for (XBAlbumsModel *albumModel in albums) {
        XBAddWeekRecordModel *recordModel = [[XBAddWeekRecordModel alloc] init];
        recordModel.imagePath = [XBURLHEADER stringByAppendingString:albumModel.thumb_path];
        [self.imagesArray insertObject:recordModel atIndex:0];
    }
}

// 没有数据的时候
- (void)requestNoData {
    // 添加照片
    _imagesArray = [NSMutableArray array];
    XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
    model.iconImage = [UIImage imageNamed:@"dte_vi_add"];
    model.select = YES;
    [_imagesArray addObject:model];
    _titleLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    [self.collectionView reloadData];
}

#pragma mark - 设置UI
- (void)setUpUI {
    _saveButton.layer.cornerRadius = 5.0;
    _saveButton.layer.masksToBounds = YES;
    
    _flowLayout.itemSize = CGSizeMake(XBItemWidth, XBItemWidth);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XBInteractionCell" bundle:nil] forCellWithReuseIdentifier:@"XBInteractionCell"];
}

#pragma mark - 懒加载
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月";
    }
    return _dateFormatter;
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
