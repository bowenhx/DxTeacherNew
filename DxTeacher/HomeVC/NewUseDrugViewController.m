//
//  NewUseDrugViewController.m
//  DxTeacher
//
//  Created by Stray on 16/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NewUseDrugViewController.h"
#import "IDImagePickerCoordinator.h"
@interface NewUseDrugViewController ()<UITextFieldDelegate,UIActionSheetDelegate>{
    IBOutlet UIView *_datePickViewBg;
    __weak IBOutlet UIDatePicker *_datePickerView;
    UITextField *_tempField;
    UIButton *_tempBtn;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IDImagePickerCoordinator *imagePickerCoordinator;
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;//视频播放控制器
@property (nonatomic , strong) NSURL *videoURL;
@end

@implementation NewUseDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (NSMutableDictionary *)dictionary{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return _dictionary;
}
- (void)loadNewData{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    self.dictionary[@"action"] = @"doPublishDrug";
    self.dictionary[@"uid"] = info[@"id"];
    [[ANet share] post:BASE_URL params:@{@"action":@"getChildList",@"uid":info[@"id"]} completion:^(BNetData *model, NSString *netErr) {
        
        NSLog(@"data = %@",model.data);
        
        if (model.status == 0) {
            [self.dataSource setArray:model.data];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}
/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
- (MPMoviePlayerViewController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer=[[MPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
        _moviePlayer.view.frame = self.view.bounds;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _moviePlayer.moviePlayer.shouldAutoplay = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_moviePlayer.moviePlayer];
    }
    return _moviePlayer;
}

- (void)loadNewView{
    
    
    NSArray *item = @[@"时        间：",@"宝宝名称：",@"药品名称：",@"数        量：",@"用药时间：",@"送  药  人：",@"责  任  人：",@"病        因："];
    
    float itemY = 20.f;
    for (int i= 0; i<item.count; i++) {
    
        UILabel *labText = [[UILabel alloc] initWithFrame: CGRectMake(10, itemY, 90, 20)];
        labText.textAlignment = NSTextAlignmentRight;
        labText.text = item[i];
        labText.font = [UIFont systemFontOfSize:15];
        
        
        [self.scrollView addSubview:labText];
        
        
        if (i < 2) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(labText.max_X + 5, labText.y - 7, self.screen_W - labText.max_X - 30, 35);
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorLineBg].CGColor;
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor darkGrayColor] forState:0];
            button.tag = 100 +i;
            [self.scrollView addSubview:button];
            [button addTarget:self action:@selector(didSelectItemAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                if ([self.title hasPrefix:@"新建"]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strDate = [formatter stringFromDate:[NSDate date]];
                    [button setTitle:strDate forState:0];
                    self.dictionary[@"drugs_date"] = strDate;
                }else{
                    [self showDataView:button];
                }
            }else{
                if (![self.title hasPrefix:@"新建"]) {
                    [self showDataView:button];
                }
            }
        }else{
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(labText.max_X + 5, labText.y - 7, self.screen_W - labText.max_X - 30, 35)];
            textField.tag = i;
            textField.font = [UIFont systemFontOfSize:17];
            textField.delegate = self;
            textField.layer.borderWidth = 1;
            textField.layer.borderColor = [UIColor colorLineBg].CGColor;
            [self.scrollView addSubview:textField];
            
            if (![self.title hasPrefix:@"新建"]) {
                 [self showDataView:textField];
            }
        }
        
        
        itemY += 50;
        

        if (i == item.count - 1) {
            UILabel *labText = [[UILabel alloc] initWithFrame: CGRectMake(10, itemY + 15, 90, 20)];
            labText.textAlignment = NSTextAlignmentRight;
            labText.text = @"用药视频：";
            labText.font = [UIFont systemFontOfSize:15];
            
            
            [self.scrollView addSubview:labText];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(labText.max_X + 5, labText.y - 20, 70, 70);
            button.tag = 20;
            [self.scrollView addSubview:button];
            
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendBtn.frame = CGRectMake(15, button.max_Y +25 , self.screen_W - 30, 40);
            UIImage *image = [[UIImage imageNamed:@"det_vi_rad"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
            [sendBtn setBackgroundImage:image forState:0];
            sendBtn.titleLabel.font= [UIFont systemFontOfSize:18];
            [sendBtn setTitleColor:[UIColor whiteColor] forState:0];
            [sendBtn setTitle:@"提交" forState:0];
            [self.scrollView addSubview:sendBtn];
            
            if ([self.title hasPrefix:@"新建"]) {
                 [button setBackgroundImage:[UIImage imageNamed:@"dte_vi_add"] forState:0];
            }else{
                [self showDataView:button];
            }
            
            [button addTarget:self action:@selector(addVideoAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [sendBtn addTarget:self action:@selector(sendDrugAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.screen_W, itemY + 150);
    
    [self pickerDateView];
    
}
- (void)showDataView:(id)iView{
    if ([iView isKindOfClass:[UIButton class]]) {
        UIButton *button = iView;
        button.enabled = NO;
        switch (button.tag) {
            case 100:
                [button setTitle:_dictionary[@"drugs_date"] forState:0];
                break;
            case 101:{
                [button setTitle:_dictionary[@"drugs_child"] forState:0];
                self.dictionary[@"childid"] = _dictionary[@"drugs_child"];
            }
                break;
//            case 0:
//                [button setTitle:_dictionary[@"drugs_date"] forState:0];
//                break;
//            case 0:
//                [button setTitle:_dictionary[@"drugs_date"] forState:0];
//                break;
            default:{
                button.enabled = YES;
                NSString *url = _dictionary[@"file_path"];
                if ( ![@"" isStringBlank:url] && ( [url hasSuffix:@"mov"] || [url hasSuffix:@"mp4"])) {
                    self.videoURL = [NSString getPathByAppendString:url];
                    if (self.videoURL) {
                        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
                        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
                        generate1.appliesPreferredTrackTransform = YES;
                        NSError *err = NULL;
                        CMTime time = CMTimeMake(1, 2);
                        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
                        UIImage *image = [[UIImage alloc] initWithCGImage:oneRef];
                        [button setImage:image forState:0];
                    }else{
                        [button setBackgroundImage:[UIImage imageNamed:@"dte_vi_add"] forState:0];
                    }
                }else{
                    [button setBackgroundImage:[UIImage imageNamed:@"dte_vi_add"] forState:0];
                }
                
            }
                break;
        }
    }else if ([iView isKindOfClass:[UITextField class]]){
        UITextField *textF = iView;
        textF.userInteractionEnabled = NO;
        switch (textF.tag) {
            case 2:
                textF.text = _dictionary[@"title"];
                break;
            case 3:
                textF.text = _dictionary[@"drugs_quantum"];
                break;
            case 4:
                textF.text = _dictionary[@"drugs_time"];
                break;
            case 5:
                textF.text = _dictionary[@"drugs_sender"];
                break;
            case 6:
                textF.text = _dictionary[@"drugs_sender"];
                break;
            case 7:
                textF.text = _dictionary[@"drugs_reason"];
                break;
            default:
                break;
        }
    }
//    self.labDrugName.text = info[@"title"];
//    
//    self.labNum.text = info[@"drugs_quantum"];
//    
//    self.labUseTime.text = info[@"drugs_time"];
//    
//    self.labPerson.text = info[@"drugs_sender"];
}
- (void)pickerDateView
{
    /**
     *  设置_datePckerVIew 的frame适应屏幕尺寸
     */
    _datePickViewBg.backgroundColor = [UIColor colorAppBg];
    [_datePickViewBg setW:self.screen_W];
    
    UIView *pickerV = (UIView *)[_datePickViewBg viewWithTag:20];
    for (UIView *label in pickerV.subviews) {
        label.backgroundColor = [UIColor colorAppBg];
    }
    
    [_datePickerView setDatePickerMode:UIDatePickerModeDate];
    [_datePickerView setMaximumDate:[NSDate date]];
}
- (void)didSelectItemAction:(UIButton *)btn{
    _tempBtn = btn;
    if (btn.tag == 100) {
        [self showDatePickerView];
    }else{
        if (self.dataSource.count) {
             UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择宝宝" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [actionSheet addButtonWithTitle:obj[@"user_name"]];
            }];
            
            [actionSheet showInView:self.view];
        }
       
        
        
    }
}

//添加视频
- (void)addVideoAction:(UIButton *)btn{
    if (btn.imageView.image) {
        [self presentViewController:self.moviePlayer animated:YES completion:^{
            
        }];

        [self.moviePlayer.moviePlayer play];
        return;
    }
    self.imagePickerCoordinator = [IDImagePickerCoordinator new];
    [self presentViewController:[_imagePickerCoordinator cameraVC] animated:YES completion:nil];
    @WeakObj(self);
    _imagePickerCoordinator.backImage = ^(UIImage *image,NSURL *url){
        [btn setImage:image forState:0];
        selfWeak.videoURL = url;
    };
    
}
//发送用药信息
- (void)sendDrugAction{
    if ([_tempField isFirstResponder]) {
        [_tempField resignFirstResponder];
    }

    NSInteger filcount = self.videoURL ? 1 : 0;
    self.dictionary[@"filecount"] = @(filcount);
    
    NSDictionary *uploadInfo = nil;
    if ([self.title hasPrefix:@"新建"]) {
        uploadInfo = self.dictionary;
    }else{
        uploadInfo = @{
                       @"action":@"doUploadDrugVideo",
                       @"uid":_dictionary[@"uid"],
                       @"drugid":_dictionary[@"id"],
                       @"filecount":@(filcount)
                        };
    }
    
    
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] upload:BASE_URL params:uploadInfo files:filcount == 1 ? @[@[@"file1",self.videoURL]] : nil precent:^(float precent) {
        
    } completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            
            [self.view showHUDTitleView:model.message image:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLoadDrugdata" object:nil];
            
            [self performSelector:@selector(tapBackBtn) withObject:nil afterDelay:.7];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
    }];

    
}
#pragma mark 选择完成操作PickerDate
- (IBAction)didSelectCancelDateAction:(UIButton *)sender {
    [self didHiddenDatePickerView];
}
#pragma mark 选择完成并保存
- (IBAction)didSelectFinishDateAction:(UIButton *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:_datePickerView.date];
    
    [_tempBtn setTitle:strDate forState:0];
    self.dictionary[@"drugs_date"] = strDate;
    [self didHiddenDatePickerView];
    
}


- (void)showDatePickerView
{
    CGRect rect = _datePickViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = self.screen_H;
    _datePickViewBg.frame = rect;
    if (!_datePickViewBg.superview) {
        [self.view addSubview:_datePickViewBg];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _datePickViewBg.frame;
        frame.origin.y = self.screen_H - _datePickViewBg.h;
        _datePickViewBg.frame = frame;
    }];
    
}
- (void)didHiddenDatePickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _datePickViewBg.frame;
        rect.origin.y = self.screen_H;
        _datePickViewBg.frame = rect;
        
    } completion:^(BOOL finished) {
        [_datePickViewBg removeFromSuperview];
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tempField = textField;
    if (textField.tag >2) {
        [_scrollView setContentOffset:CGPointMake(0, textField.y-50) animated:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 2:
            self.dictionary[@"drugname"] = textField.text;
            break;
        case 3:
            self.dictionary[@"drugs_quantum"] = textField.text;
            break;
        case 4:
            self.dictionary[@"drugs_time"] = textField.text;
            break;
        case 5:
            self.dictionary[@"drugs_sender"] = textField.text;
            break;
        case 6:
            self.dictionary[@"drugs_manager"] = textField.text;
            break;
        case 7:
            self.dictionary[@"drugs_reason"] = textField.text;
            break;
            
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [_tempBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:0];
        self.dictionary[@"childid"] = self.dataSource[buttonIndex-1][@"childid"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_tempField isFirstResponder]) {
        [_tempField resignFirstResponder];
    }

}
-(void)movieFinishedCallback:(NSNotification*)notify{
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [self dismissMoviePlayerViewControllerAnimated];
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
