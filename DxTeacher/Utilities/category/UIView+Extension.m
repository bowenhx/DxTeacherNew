//
//  UIView+Extension.m
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIView * (^)(CGFloat))xb_width {
    return ^UIView *(CGFloat width) {
        CGRect rect = self.frame;
        rect.size.width = width;
        self.frame = rect;
        return self;
    };
}

- (UIView * (^)(CGFloat))xb_height {
    return ^UIView *(CGFloat height) {
        CGRect rect = self.frame;
        rect.size.height = height;
        self.frame = rect;
        return self;
    };
}

- (UIView * (^)(CGFloat))xb_x {
    return ^UIView *(CGFloat x) {
        CGRect rect = self.frame;
        rect.origin.x = x;
        self.frame = rect;
        return self;
    };
}

- (UIView * (^)(CGFloat))xb_y {
    return ^UIView *(CGFloat y) {
        CGRect rect = self.frame;
        rect.origin.y = y;
        self.frame = rect;
        return self;
    };
}

- (UIView *(^)(CGFloat))xb_centerX {
    return ^UIView *(CGFloat centerX) {
        CGPoint center = self.center;
        center.x = centerX;
        self.center = center;
        return self;
    };
}

- (UIView *(^)(CGFloat))xb_centerY {
    return ^UIView *(CGFloat centerY) {
        CGPoint center = self.center;
        center.y = centerY;
        self.center = center;
        return self;
    };
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

@end
