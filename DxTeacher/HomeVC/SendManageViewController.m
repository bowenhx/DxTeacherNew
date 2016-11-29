//
//  SendManageViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define SPACE 20  //图片间隔20
#import "SendManageViewController.h"
#import "AppDefine.h"
#import "ItemViewBtn.h"
#import "SendMegViewController.h"
@interface SendManageViewController ()
{
    NSInteger _aidIndex;
    NSArray *_images;
}
@end

@implementation SendManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布管理";
    
    
}

- (void)loadNewView{
    _images = @[
                @[@"tztg_unpressed",@"tztg_pressed",@"通知通告"],
                @[@"jcsj_unpressed",@"jcsj_pressed",@"精彩瞬间"],
                @[@"mzsp_unpressed",@"mzsp_pressed",@"每周食谱"],
                @[@"kcjh_unpressed",@"kcjh_pressed",@"课程计划"],
                @[@"ysaq_unpressed",@"ysaq_pressed",@"园所安全"]
                ];
    
    [self addItemView:_images];
    
}

- (void)addItemView:(NSArray *)items{
    float btn_wh = (self.screen_W - SPACE * 4) / 3;
    for (int i= 0; i<items.count; i++) {
        float addBtnX = SPACE + (SPACE + btn_wh) * (i%3);
        float addBtnY = 84 + (SPACE + btn_wh) * (i/3);
        
        ItemViewBtn *iView = [[ItemViewBtn alloc] initWithFrame:CGRectMake(addBtnX, addBtnY, btn_wh, btn_wh)];
        iView.items = items[i];
        iView.tag = i;
        [self.view addSubview:iView];
        iView.itemBtn.tag = i;
        [iView.itemBtn addTarget:self action:@selector(didSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        [iView.labTitle setY:iView.labTitle.y + 15];
        iView.itemBtn.layer.borderWidth = 1;
        iView.itemBtn.layer.borderColor = [UIColor colorLineBg].CGColor;
        iView.itemBtn.layer.cornerRadius = 3;
    }
}
- (void)didSelectIndex:(UIButton *)btn{
    if (btn.tag == 0) {
        _aidIndex = 52;
    }else{
        _aidIndex = btn.tag + 61;
    }
    
    //检查发布权限
    [self sendJurisdictionManageBlock:^(bool bPush) {
        if (bPush == 0) {
            SendMegViewController *sendMegVC = [[SendMegViewController alloc] initWithNibName:@"SendMegViewController" bundle:nil];
            sendMegVC.title = [NSString stringWithFormat:@"发布%@",_images[btn.tag][2]];
            sendMegVC.index = _aidIndex;
            [self.navigationController pushViewController:sendMegVC animated:YES];
        }
    }];
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
