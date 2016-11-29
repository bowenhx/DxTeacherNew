//
//  UIView+Extension.h
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

- (UIView *(^)(CGFloat param))xb_width;
- (UIView *(^)(CGFloat param))xb_height;
- (UIView *(^)(CGFloat param))xb_x;
- (UIView *(^)(CGFloat param))xb_y;
- (UIView *(^)(CGFloat param))xb_centerX;
- (UIView *(^)(CGFloat param))xb_centerY;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)centerX;
- (CGFloat)centerY;

@end
