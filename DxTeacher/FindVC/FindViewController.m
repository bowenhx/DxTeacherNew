//
//  FindViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define SPACE 0  //图片间隔20
#import "FindViewController.h"
#import "ItemViewBtn.h"
#import "BLoopImageView.h"
#import "FindListViewCell.h"
#import "CoursewareViewController.h"
#import "HYBLoopScrollView.h"
#import "XBWebController.h"
#import "XBNetWorkTool.h"
#import "XBHotRecommendController.h"
#import "XBAddAttentionController.h"
#import "XBFindHotRecommendView.h"

@interface FindViewController ()<BLoopImageViewDelegate>
@property (nonatomic , strong) BLoopImageView *headView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, weak) HYBLoopScrollView *loop;
@property (nonatomic, strong) NSArray *collectionArray;
@property (nonatomic, weak) FindListViewCell *listViewCell;
@property (nonatomic, strong) NSArray *hotRecommendArray;
@property (nonatomic, weak) XBFindHotRecommendView *recommendView;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"发现";
    
    [self requestForBanner];
    
    [self requestForMyAttention];
    
    [self requestForHotRecommendData];
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
- (void)loadNewView{
    //添加循环轮播图片view
//    [self.scrollView addSubview:self.headView];
    [self loopView];
}
- (void)loadItemNewViews:(NSArray *)items{

    [self.dataSource setArray:items];
    
    float btn_wh = (self.screen_W - SPACE * 4) / 3;
    
    float line_Y = 0.0;
    for (int i= 0; i<items.count; i++) {
        float addBtnX = SPACE + (SPACE + btn_wh) * (i%3);
        float addBtnY = self.headView.max_Y + (SPACE + btn_wh) * (i/3);
        
        ItemViewBtn *iView = [[ItemViewBtn alloc] initWithFrame:CGRectMake(addBtnX, addBtnY, btn_wh, btn_wh)];
        
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",BASE_IMG_URL,items[i][@"img_url"]];
        
        iView.itemImgs = imageURL;
        iView.titles = items[i][@"title"];
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
            UILabel *lineY = [[UILabel alloc] initWithFrame:CGRectMake(iView.max_X, addBtnY, 1, iView.h*2)];
            lineY.backgroundColor = @"#cccccc".color;
            [self.scrollView addSubview:lineY];
        }
        
        
    }
    
    
     _scrollView.contentSize = CGSizeMake(self.screen_W, self.screen_H + 100);
    
    
    FindListViewCell *listView = [[FindListViewCell alloc] initWithFrame:CGRectMake(0, line_Y, self.screen_W, 70)];
//    listView.layer.borderWidth = 1;
//    listView.layer.borderColor = [UIColor greenColor].CGColor;
    __weak typeof(self) Self = self;
    listView.addBlock = ^() {
        XBAddAttentionController *addAttentionVC = [[XBAddAttentionController alloc] init];
        [Self.navigationController pushViewController:addAttentionVC animated:YES];
    };
    listView.labLine.backgroundColor = @"#cccccc".color;
    _listViewCell = listView;
    [_scrollView addSubview:listView];
    
    XBFindHotRecommendView *hotRecommendView = [XBFindHotRecommendView findHotRecommendView];
    _recommendView = hotRecommendView;
    hotRecommendView.moreBlock = ^() {
        XBHotRecommendController *hotVC = [[XBHotRecommendController alloc] init];
        [Self.navigationController pushViewController:hotVC animated:YES];
    };
    hotRecommendView.frame = CGRectMake(0, listView.max_Y, self.screen_W, (kScreenWidth - 40) / 4 + 70);
    [_scrollView addSubview:hotRecommendView];
}
- (void)loadNewData{
    NSArray *items = [NSArray arrayWithObjects:
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/903/847d2925-7d03-40dd-90d9-429d13aabab8_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/888/4f564995-a919-4c7f-ae8f-d8d0bda1d7f4_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/869/2ebc752a-5176-4f16-b7b5-2233d4ddcc87_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/888/4f564995-a919-4c7f-ae8f-d8d0bda1d7f4_100x100.jpg",
                      @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/903/847d2925-7d03-40dd-90d9-429d13aabab8_100x100.jpg", nil];
    
    [self refreshHeadImages:items];
    
    
    [self loadItemData];
}
- (void)loadItemData{
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getFind6Class"} completion:^(BNetData *model, NSString *netErr) {
       
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            NSArray *items = model.data;
            if ([items isKindOfClass:[NSArray class]] && items.count) {
                [self loadItemNewViews:items];
            }
            
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}
- (void)didSelectIndex:(UIButton *)btn{
    NSLog(@"btn.tag = %ld",btn.tag);

    CoursewareViewController *couresewareVC = [[CoursewareViewController alloc] initWithNibName:@"CoursewareViewController" bundle:nil];
    NSDictionary *info = self.dataSource[btn.tag];
    couresewareVC.aid = [info[@"id"] integerValue];
    couresewareVC.navigationItem.title = info[@"title"];
    [self.navigationController pushViewController:couresewareVC animated:YES];
}

#pragma mark - 获取我的关注
- (void)requestForMyAttention {
    NSDictionary *userInfo = [SavaData parseDicFromFile:User_File]; // 3
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"action" : @"getUNSCList",
                                 @"uid" : userInfo[@"id"],
                                 @"page" : @"1"};
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            self.collectionArray = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            _listViewCell.elephantModel = self.collectionArray[0];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"网络繁忙,请稍后再试!";
            [hud hide:YES afterDelay:3.0];
        });
    }];
}

#pragma mark - 请求热门推荐
- (void)requestForHotRecommendData {
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX parameters:@{@"action" : @"geHotList",
                                                                    @"page" : @1}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.view removeHUDActivity];
                                          //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                          self.hotRecommendArray = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                          _recommendView.dataList = self.hotRecommendArray;
                                      });
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.view removeHUDActivity];
                                          //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                          hud.labelText = @"网络繁忙,请稍后再试!";
                                          [hud hide:YES afterDelay:3.0];
                                      });
                                  }];
}

#pragma mark - 获取首页大图
- (void)requestForBanner {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XBNetWorkTool shareNetWorkTool] GET:XBURLPREFIXX
                               parameters:@{@"action" : @"getNewsList",
                                            @"aid" : @"131"}
                                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                         // [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          self.bannerArray = [XBElephantModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                                          for (XBElephantModel *elephantModel in self.bannerArray) {
                                              [self.imageUrls addObject:[XBURLHEADER stringByAppendingString:elephantModel.img_url]];
                                          }
                                          _loop.imageUrls = _imageUrls;
                                      });
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          //[MBProgressHUD hideHUDForView:self.view animated:YES];
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
