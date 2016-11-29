//
//  UIColor+app.h
//  BKMobile
//
//  Created by Guibin on 15/1/23.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//
/**
 *  这里设置app 所有UI 渲染颜色变化
 */

#import <UIKit/UIKit.h>
#import "NSString+UIColor.h"
#define RGB(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

@interface UIColor (AppUIColor)

//app 全局主色调，包括导航背景 （红）
+ (UIColor *)colorAppBg;

//底部tabbar 背景
+ (UIColor *)colorTabBar;

//设置cell中间的线的颜色
+ (UIColor *)colorCellLineBg;

//设置cell head view 背景
+ (UIColor *)colorCellHeadBg;


+ (UIColor *)colorLineBg;

//取随机色
+ (UIColor *)randomColor;


@end

@interface UIImage (BImage_Color)

/**
 *  根据颜色和尺寸返回一个image
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
