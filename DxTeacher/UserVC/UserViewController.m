//
//  UserViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "UserViewController.h"
#import "AppDefine.h"
#import "UIViewController+MMDrawerController.h"
#import "XBActionView.h"
#import <TZImagePickerController.h>
#import "XBNetWorkTool.h"
#import "AppDelegate.h"

@interface UserViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIImageView *headerImageView;

@end

@implementation UserViewController

#pragma mark - target事件
- (void)changeHeaderImage {
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

- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *images, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self requestForChangeIconWith:images.firstObject];
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

#pragma mark - 更换头像
- (void)requestForChangeIconWith:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    [[XBNetWorkTool shareNetWorkTool] POST:XBURLPREFIXX
                                parameters:@{@"action" : @"doChangeAvatar",
                                             @"uid" : userInfo[@"id"]}
                 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                     [formData appendPartWithFileData:data name:@"file" fileName:@"image1.jpg" mimeType:@"image/jpeg"];
                 }
                                  progress:^(NSProgress * _Nonnull uploadProgress) {}
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           _headerImageView.image = image;
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


+ (UserViewController *)share{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataSource setArray:@[@"通讯录",@"我的审核",@"我的特色班",@"我的考勤",@"园所通知",@"教学计划",@"我的收藏",@"和睦家庭",@"退出登录"]];
    
    [self.tableView setTableHeaderView:[self headView]];
}
- (UIView *)headView{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    NSLog(@"info = %@",info);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 220)];
    headView.backgroundColor = [UIColor clearColor];
    //头像
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake((headView.w - 80)/2, 70, 80, 80)];
    headImg.userInteractionEnabled = YES;
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 40;
    //headImg.layer.borderWidth = 1;
    [headImg img_setImageWithURL:info[@"avatar"] placeholderImage:[UIImage imageNamed:@"userDefineIcon"]];
    [headView addSubview:headImg];
    _headerImageView = headImg;
    [headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)]];
    
    //用户名
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(headImg.x, headImg.max_Y + 5, headImg.w, 25)];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.textColor = [UIColor whiteColor];
    userName.text = info[@"nick_name"];
    [headView addSubview:userName];
    //内容电话
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(userName.x - 50, userName.max_Y, userName.w + 100, 25)];
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor whiteColor];
    textLab.text = [NSString stringWithFormat:@"%@ 大象顺义园所",info[@"mobile"]];
    [headView addSubview:textLab];
    
    return headView;
}

- (void)loadNewView{
//    UIView *backView = [[UIView alloc] init];
//    backView.backgroundColor = @"#3399fe".color;
//    self.tableView.backgroundView = backView;
    self.tableView.backgroundColor = @"#3399fe".color;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = @"#3399fe".color;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

    if (indexPath.row == self.dataSource.count - 1) {
        //这里是退出登录
         [[[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        return;
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"selectActionTypeNotification" object:@{@"row":@(indexPath.row)}];
//        });
//    });
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *centVC = [storyBoard instantiateInitialViewController];
//    [self.mm_drawerController setCenterViewController:centVC withCloseAnimation:YES completion:nil];
   

   
}
//退出登陆
- (void)logOutAction {
    //标记登陆
    [[SavaData shareInstance] savaDataInteger:1 KeyString:@"finishGuide"];
    
    //退出登陆代理
    [[AppDelegate getAppDelegate] showLoginVC];
    
    //清除用户信息
    [SavaData writeDicToFile:@{} FileName:User_File];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self logOutAction];
    }
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
