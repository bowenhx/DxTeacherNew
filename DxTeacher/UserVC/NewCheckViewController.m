//
//  NewCheckViewController.m
//  DxTeacher
//
//  Created by ligb on 16/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "NewCheckViewController.h"
#import "AppDefine.h"

@interface NewCheckViewController ()
{
    __weak IBOutlet UISegmentedControl *_segmentedCtr;
    
    __weak IBOutlet UIView *_baseView;
    
    __weak IBOutlet UIView *_actionView;
    
    __weak IBOutlet UILabel *_labLine;
    
    
    __weak IBOutlet UIButton *_btnStart;
    
    __weak IBOutlet UIButton *_btnEnd;
    
    __weak IBOutlet UITextView *_textView;
    
    __weak IBOutlet UIButton *_btnSend;
    
    IBOutlet UIView *_datePickViewBg;
    __weak IBOutlet UIDatePicker *_datePickerView;
 
    UIButton *_tempBtn;
}
@end

@implementation NewCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请假条";
}
- (void)loadNewView{
    _segmentedCtr.tintColor = [UIColor colorAppBg];
    _segmentedCtr.selectedSegmentIndex = 0;
    
    NSDictionary *textFontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil];
    [_segmentedCtr setTitleTextAttributes:textFontDic forState:UIControlStateNormal];
//    [_segmentedCtr addTarget:self action:@selector(selectCheckType:) forControlEvents:UIControlEventValueChanged];
    
    _baseView.backgroundColor = @"#f2f2f2".color;
    _actionView.backgroundColor = [UIColor whiteColor];
    _actionView.layer.borderWidth = 1;
    _actionView.layer.borderColor = [UIColor colorLineBg].CGColor;
    _actionView.layer.cornerRadius = 5;
    _labLine.backgroundColor = [UIColor colorLineBg];
    [_btnStart setTitleColor:@"#9fbe85".color forState:0];
    [_btnEnd setTitleColor:@"#9fbe85".color forState:0];
    UIImage *image = [[UIImage imageNamed:@"det_vi_rad"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [_btnSend setBackgroundImage:image forState:0];
    
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor colorLineBg].CGColor;
    _textView.layer.cornerRadius = 5;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    [_btnStart setTitle:strDate forState:0];
    [_btnEnd setTitle:strDate forState:0];
   
    [self pickerDateView];
    
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

- (void)selectCheckType:(UISegmentedControl *)control{
    
}
//选择日志
- (IBAction)didSelectCheckDateAction:(UIButton *)sender {
    _tempBtn = sender;
    [self showDatePickerView];
}
//发布假条
- (IBAction)sendAction:(id)sender {
    
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    if ([@"" isStringBlank:_textView.text]) {
        [self.view showHUDTitleView:@"请填写请假事由" image:nil];
        return;
    }
    NSDictionary *userDic = [SavaData parseDicFromFile:User_File];
    NSDictionary *info = @{
                           @"action":@"doPublishLeave",
                           @"uid":userDic[@"id"],
                           @"leavetype":_segmentedCtr.selectedSegmentIndex == 0 ? @"事假" : @"病假",
                           @"leavestart":_btnStart.titleLabel.text,
                           @"leaveend":_btnEnd.titleLabel.text,
                           @"leavecontent":_textView.text,
                           };
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    
    [[ANet share] post:BASE_URL params:info completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            //请求成功
            [self.view showSuccess:model.message];
            [self performSelector:@selector(tapBackBtn) withObject:nil afterDelay:.7];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
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
