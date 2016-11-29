//
//  XBActionView.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/29.
//  Copyright © 2016年 周旭斌. All rights reserved.
//
typedef void(^selectBlock)(NSInteger index);

#import <UIKit/UIKit.h>

@interface XBActionView : UIView

+ (void)showActionViewWithSelectIndex:(selectBlock)selectBlock;
//+ (void)dismissActionView;

@end
