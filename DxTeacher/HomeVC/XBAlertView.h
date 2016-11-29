//
//  XBAlertView.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^cancelBlock)();
typedef void(^confirmBlock)(NSString *content);

#import <UIKit/UIKit.h>

@interface XBAlertView : UIView

+ (void)showAlertViewWith:(NSString *)title placeHolderString:(NSString *)placeHolder cancelButtonBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock;

@end
