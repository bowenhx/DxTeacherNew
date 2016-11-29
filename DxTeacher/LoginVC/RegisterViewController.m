//
//  RegisterViewController.m
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDefine.h"

@interface RegisterViewController ()
{
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    
    
    __weak IBOutlet UIButton *_btnDxName;
    
    __weak IBOutlet UITextField *_textUserName;
    
    __weak IBOutlet UITextField *_textPhoneNum;
    
    __weak IBOutlet UITextField *_textCodeNum;
    
    __weak IBOutlet UIButton *_btnJob;
    
    __weak IBOutlet UITextField *_textEmail;
    
    __weak IBOutlet UITextField *_textPassword;
    
    __weak IBOutlet UIButton *_btnRegister;
    
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    [self setUIView];
    
}
- (void)setUIView{
    
    _btnDxName.layer.borderWidth = .5;
    _btnDxName.layer.borderColor = [UIColor colorLineBg].CGColor;
    _btnDxName.layer.cornerRadius = 3;
    
    _btnJob.layer.borderWidth = .5;
    _btnJob.layer.borderColor = [UIColor colorLineBg].CGColor;
    _btnJob.layer.cornerRadius = 3;
    
    UIImage *img = [[UIImage imageNamed:@"det_vi_rad"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [_btnRegister setBackgroundImage:img forState:0];
    
//    _scrollView.frame = CGRectMake(0, 0, self.screen_W, self.screen_H-64);
//    _scrollView.layer.borderWidth = 1;
    _scrollView.layer.borderColor = [UIColor redColor].CGColor;
    if (self.screen_W <= 414) {
        _scrollView.contentSize = CGSizeMake(self.screen_W, self.screen_H + 50);
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (IBAction)agreementAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    
    
}
- (IBAction)registerAction:(UIButton *)sender {
    
    
    
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
