//
//  HomeViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define SPACE 0  //图片间隔20

#import "HomeViewController.h"
#import "BLoopImageView.h"
#import "ItemViewBtn.h"
#import "WorkManageViewController.h"
#import "DeedViewController.h"
#import "SendManageViewController.h"
#import "ClassesViewController.h"
#import "FMViewController.h"
#import "VerifyViewController.h"
#import "AddressViewController.h"
#import "GrowLogViewController.h"
#import "DrugManageViewController.h"
#import "MyCheckViewController.h"
#import "CollectViewController.h"
#import "HYBLoopScrollView.h"
#import "XBWebController.h"
#import "XBNetWorkTool.h"
#import "XBElephantModel.h"
#import "XBSaveAttentionController.h"

@interface HomeViewController ()<BLoopImageViewDelegate>

@property (nonatomic , strong) BLoopImageView *headView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, weak) HYBLoopScrollView *loop;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectUserType:) name:@"selectActionTypeNotification" object:nil];
    
    // 请求首页大图
    [self requestForBanner];
}
- (BLoopImageView *)headView{
    if (!_headView) {
        float height = 0;
        if (self.screen_W > 320){
            height = 200;
        }else{
            height = 170;
        }
        _headView = [[BLoopImageView alloc] initWithFrame:CGRectMake(0, 0, self.screen_W, height) delegate:self imageItems:nil isAuto:YES];
//        _headView.layer.borderColor = [UIColor greenColor].CGColor;
//        _headView.layer.borderWidth = 1;
    }
    return _headView;
}
//处理Head展示图片无限循环
- (void)refreshHeadImages:(NSArray *)images
{
    if (_headView.itemsArr.count) {
        for (UIView *view in _headView.subviews) {
            [view removeFromSuperview];
        }
    }
    //添加最后一张图 用于循环
    int length = (unsigned)images.count;
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1)
    {
//        NSDictionary *dict = images[length-1];
        BLoopImageItem *item = [[BLoopImageItem alloc] initWithTitle:@"" image:images[length-1] tag:-1];//initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSString *img = images[i];
        BLoopImageItem *item = [[BLoopImageItem alloc] initWithTitle:@"" image:img tag:i];//initWithDict:dict tag:i];
        [itemArray addObject:item];
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSString *img = images[0];
        BLoopImageItem *item = [[BLoopImageItem alloc] initWithTitle:@"" image:img tag:length];//initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    [self.headView setItemsArr:itemArray];
}

- (void)addNavLeftItem{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"dte_vi_caidan"];
    item.frame = CGRectMake(0, 0, image.size.width , image.size.height);
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    [item setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [item setImage:image forState:UIControlStateNormal];
    [item addTarget:self action:@selector(showLeftVCAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc] initWithCustomView:item];
    self.navigationItem.leftBarButtonItem = itemLeft;
}
- (void)loadNewView{
//    self.scrollView.layer.borderWidth = 1;
//    self.scrollView.layer.borderColor = [UIColor redColor].CGColor;
    
    [self addNavLeftItem];
    
    //添加循环轮播图片view
//    [self.scrollView addSubview:self.headView];
    [self loopView];
    
    NSArray *images = @[
                        @[@"kqgl_1_unpressed",@"kqgl_1_pressed",@"考勤管理"],
                        @[@"xwjll_1_unpressed",@"xwjll_1_pressed",@"行为记录"],
                        @[@"fbgl_1_unpressed",@"fbgl_1_pressed",@"发布管理"],
                        @[@"jcsj_1_unpressed",@"jcsj_1_pressed",@"精彩瞬间"],
                        @[@"dxfm_1_unpressed",@"dxfm_1_pressed",@"大象FM"],
                        @[@"czrz-_1_unpressed",@"czrz_1_pressed",@"成长日志"],
                        @[@"yytgl_1_unpressed",@"yytgl_1_pressed",@"用药条管理"],
                        @[@"ystz_1_unpressed",@"ystz_1_pressed",@"园所通知"],
                        @[@"wdsh_1_unpressed",@"wdsh_1_pressed",@"我的审核"],
                        @[@"aqtx_1_unpressed",@"aqtx_1_pressed",@"安全提醒"]
                        ];
    
    float btn_wh = (self.screen_W - SPACE * 4) / 3;
    
    float line_Y = 0.0;
    for (int i= 0; i<images.count; i++) {
        float addBtnX = SPACE + (SPACE + btn_wh) * (i%3);
        float addBtnY = self.headView.max_Y + (SPACE + btn_wh) * (i/3);
        
        ItemViewBtn *iView = [[ItemViewBtn alloc] initWithFrame:CGRectMake(addBtnX, addBtnY, btn_wh, btn_wh)];
        iView.items = images[i];
        iView.tag = i;
        [self.scrollView addSubview:iView];
        iView.itemBtn.tag = i;
        [iView.itemBtn addTarget:self action:@selector(didSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        //判断是否变化，当Y值变化时，再画
        if (line_Y != iView.max_Y) {
            //画横线
            UILabel *lineX = [[UILabel alloc] initWithFrame:CGRectMake(0, iView.max_Y, self.screen_W, 1)];
            lineX.backgroundColor = @"#cccccc".color;
            [self.scrollView addSubview:lineX];
        }
       
        line_Y = iView.max_Y;
        
        //只需要画两条就行
        if (i < 2) {
            //画竖线
            UILabel *lineY = [[UILabel alloc] initWithFrame:CGRectMake(iView.max_X, addBtnY, 1, iView.h*4)];
            lineY.backgroundColor = @"#cccccc".color;
            [self.scrollView addSubview:lineY];
        }
        
        
        
        
    }

    _scrollView.contentSize = CGSizeMake(self.screen_W, self.screen_H + 100);
}

- (void)loadNewData{
    NSArray *items = [NSArray arrayWithObjects:
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/903/847d2925-7d03-40dd-90d9-429d13aabab8_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/888/4f564995-a919-4c7f-ae8f-d8d0bda1d7f4_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/869/2ebc752a-5176-4f16-b7b5-2233d4ddcc87_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/888/4f564995-a919-4c7f-ae8f-d8d0bda1d7f4_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/903/847d2925-7d03-40dd-90d9-429d13aabab8_100x100.jpg", nil];
    
    [self refreshHeadImages:items];
}


- (void)didSelectIndex:(UIButton *)btn{
    NSLog(@"btn.tag = %ld",btn.tag);
    switch (btn.tag) {
        case 0:
        {//考勤管理
            WorkManageViewController *workManageVC = [[WorkManageViewController alloc] initWithNibName:@"WorkManageViewController" bundle:nil];
            [self.navigationController pushViewController:workManageVC animated:YES];
        }
            break;
        case 1:
        {//行为记录
            DeedViewController *deedVC = [[DeedViewController alloc] initWithNibName:@"DeedViewController" bundle:nil];
            [self.navigationController pushViewController:deedVC animated:YES];
            
        }
            break;
        case 2:
        {//发布管理
            SendManageViewController *sendManageVC = [[SendManageViewController alloc] initWithNibName:@"SendManageViewController" bundle:nil];
            [self.navigationController pushViewController:sendManageVC animated:YES];
            
        }
            break;
        case 3:
        {//精彩瞬间
            [self classesViewControllerTitle:@"精彩瞬间" index:62];
        }
            break;
        case 4:
        {//大象FM
            FMViewController *fmVC = [[FMViewController alloc] initWithNibName:@"FMViewController" bundle:nil];
            [self.navigationController pushViewController:fmVC animated:YES];
        }
            break;
        case 5:
        {//成长日志
            GrowLogViewController *growLogVC = [[GrowLogViewController alloc] initWithNibName:@"GrowLogViewController" bundle:nil];
            [self.navigationController pushViewController:growLogVC animated:YES];
        }
            break;
        case 6:
        {//用药条管理
            DrugManageViewController *drugManageVC = [[DrugManageViewController alloc] initWithNibName:@"DrugManageViewController" bundle:nil];
            [self.navigationController pushViewController:drugManageVC animated:YES];
        }
            break;
        case 7:
        {//园所通知
            [self classesViewControllerTitle:@"园所通知" index:52];
        }
            break;
        case 8:
        {//我的审核
            VerifyViewController *verifyVC = [[VerifyViewController alloc] initWithNibName:@"VerifyViewController" bundle:nil];
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
            break;
        case 9:
        {//安全提醒
            XBSaveAttentionController *saveVC = [[XBSaveAttentionController alloc] init];
            [self.navigationController pushViewController:saveVC animated:YES];
        }
            break;
            
        default:
            break;
    }
   
    
}
- (void)classesViewControllerTitle:(NSString *)title index:(NSInteger)index{
    ClassesViewController *classesVC = [[ClassesViewController alloc] initWithNibName:@"ClassesViewController" bundle:nil];
    classesVC.index = index;
    classesVC.navigationItem.title = title;
    [self.navigationController pushViewController:classesVC animated:YES];
}
- (void)showLeftVCAction{
      [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)foucusImageFrame:(BLoopImageView *)imageView didSelectItem:(BLoopImageItem *)item{
    NSLog(@"item = %@",item.imgurl);
}
- (void)foucusImageFrame:(BLoopImageView *)imageView currentItem:(int)index{
    
}

- (void)didSelectUserType:(NSNotification *)notification{
    NSDictionary *obj = [notification object];
    NSInteger index = [obj[@"row"] integerValue];
    switch (index) {
        case 0:
        {
            AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
            break;
        case 3:
        {//我的考勤
            MyCheckViewController *checkVC = [[MyCheckViewController alloc] initWithNibName:@"MyCheckViewController" bundle:nil];
            [self.navigationController pushViewController:checkVC animated:YES];
        }
            break;
        case 6:
        {//我的考勤
            CollectViewController *collectVC = [[CollectViewController alloc] initWithNibName:@"CollectViewController" bundle:nil];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
            break;

        default:
            break;
    }
}

#pragma mark - 获取首页大图
- (void)requestForBanner {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:@{@"action" : @"getNewsList",
                                            @"aid" : @"132"}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          self.bannerArray = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                          for (XBElephantModel *elephantModel in self.bannerArray) {
                                              [self.imageUrls addObject:[XBURLHEADER stringByAppendingString:elephantModel.img_url]];
                                          }
                                          _loop.imageUrls = _imageUrls;
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

- (void)loopView {
    __weak typeof(self) Self = self;
    float height = 0;
    if (self.screen_W > 320){
        height = 200;
    }else{
        height = 170;
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, height) imageUrls:_imageUrls timeInterval:2.0 didSelect:^(NSInteger atIndex) {
        XBLog(@"点击了%ld张图", atIndex);
        XBWebController *webVC = [[XBWebController alloc] init];
        webVC.targetUrl = [_bannerArray[atIndex] link_url];
        webVC.navTitle = [_bannerArray[atIndex] title];
        [Self.navigationController pushViewController:webVC animated:YES];
    } didScroll:^(NSInteger toIndex) {
    }];
    loop.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    // page control小圆点太小？可以修改的
    loop.pageControl.size = 10;
    
    _loop = loop;
    [self.scrollView addSubview:loop];
    
    // 不希望显示pagecontrol？
    //  loop.pageControl.hidden = YES;
    // 或者直接
    //  [loop.pageControl removeFromSuperview];
    
    // 默认的是UIViewContentModeScaleAspectFit
    //  loop.imageContentMode = UIViewContentModeScaleToFill;
    loop.imageContentMode = UIViewContentModeScaleAspectFill;
    [loop clearImagesCache];
    
    [loop startTimer];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
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
