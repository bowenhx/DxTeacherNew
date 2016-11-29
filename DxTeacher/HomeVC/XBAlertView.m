//
//  XBAlertView.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBAlertView.h"

@interface XBAlertView () <UITextViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) cancelBlock cancelBlock;
@property (nonatomic, copy) confirmBlock confirmBlock;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *placeString;
@property (nonatomic, weak) UILabel *placeLabel;
@property (nonatomic, weak) UITextView *textView;

@end

@implementation XBAlertView

#pragma mark - target事件
- (void)tap:(UITapGestureRecognizer *)tap {
    [self endEditing:YES];
}

- (void)confirmButtonClick:(UIButton *)button {
    [self dismissAlertView];
    if (_textView.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.labelText = @"请写下您的新的哟~";
        [hud hide:YES afterDelay:3.0];
        return;
    }
    if (_confirmBlock) {
        self.confirmBlock(_textView.text);
    }
}

- (void)cancelButtonClick:(UIButton *)button {
    [self dismissAlertView];
}

+ (void)showAlertViewWith:(NSString *)title placeHolderString:(NSString *)placeHolder cancelButtonBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock {
    XBAlertView *alertView = [[XBAlertView alloc] init];
    alertView.cancelBlock = cancelBlock;
    alertView.confirmBlock = confirmBlock;
    alertView.title = title;
    alertView.placeString = placeHolder;
    [alertView.textView becomeFirstResponder];
    alertView.frame = kScreenBounds;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
}

#pragma mark - 初始化方法
- (instancetype)init {
    if (self == [super init]) {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [self addSubview:backView];
        
        // 背景
        UIView *alertBackView = [[UIView alloc] init];
        alertBackView.frame = CGRectMake(kScreenWidth * 0.25 * 0.5, kScreenHeight * 0.3 - 20, kScreenWidth * 0.75, kScreenWidth * 0.75 * 0.75);
        alertBackView.backgroundColor = XBThemeColor;
        [self addSubview:alertBackView];
        alertBackView.layer.cornerRadius = 5.0;
        alertBackView.layer.masksToBounds = YES;
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = XBFont(14);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = _title ? _title : @"温馨提示";
        titleLabel.frame = CGRectMake(0, 0, alertBackView.width, alertBackView.height * 0.2);
        [alertBackView addSubview:titleLabel];
        
        // 输入框
        UITextView *textView = [[UITextView alloc] init];
        textView.font = XBFont(14);
        textView.layer.borderColor = [UIColor whiteColor].CGColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 2.0;
        textView.layer.masksToBounds = YES;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = XBThemeColor;
        _textView = textView;
        textView.delegate = self;
        textView.frame = CGRectMake(8, CGRectGetMaxY(titleLabel.frame) + 5, alertBackView.width - 16, alertBackView.height * 0.4);
        [alertBackView addSubview:textView];
        
        // 占位符文字
        UILabel *placeLabel = [[UILabel alloc] init];
        placeLabel.font = XBFont(14);
        placeLabel.textColor = [UIColor whiteColor];
        _placeLabel = placeLabel;
        placeLabel.text = _placeString ? _placeString : @"请输入文字";
        placeLabel.frame = CGRectMake(11, textView.y, textView.width, 30.0);
        [alertBackView addSubview:placeLabel];
        
        // 取消按钮
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.titleLabel.font = XBFont(14);
        cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        cancelButton.layer.borderWidth = 1.0;
        cancelButton.layer.cornerRadius = 5.0;
        cancelButton.layer.masksToBounds = YES;
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(8, CGRectGetMaxY(textView.frame) + 15, textView.width * 0.5 - 10, textView.height * 0.5);
        [alertBackView addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 确定按钮
        UIButton *confirmButton = [[UIButton alloc] init];
        confirmButton.titleLabel.font = XBFont(14);
        confirmButton.layer.borderColor = [UIColor whiteColor].CGColor;
        confirmButton.layer.borderWidth = 1.0;
        confirmButton.layer.cornerRadius = 5.0;
        confirmButton.layer.masksToBounds = YES;
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.frame = CGRectMake(CGRectGetMaxX(textView.frame) - (textView.width * 0.5 - 10), CGRectGetMaxY(textView.frame) + 15, textView.width * 0.5 - 10, textView.height * 0.5);
        [alertBackView addSubview:confirmButton];
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - 私有方法
- (void)dismissAlertView {
    [self endEditing:YES];
    [self removeFromSuperview];
}

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placeLabel.hidden = YES;
    }else {
        _placeLabel.hidden = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
