//
//  BLoopImageItem.h
//  BKMobile
//
//  Created by Guibin on 15/1/13.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//
/**
 *  创建存储对象 （首页headImage）
 *
 *  @param nonatomic 图片信息
 *  @param retain
 *
 *  @return
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BLoopImageItem : NSObject

@property (nonatomic, copy)     NSString      *title;
@property (nonatomic, strong)   NSString      *imgurl;
@property (nonatomic, strong)   NSString      *skipurl;
@property (nonatomic, assign)   NSInteger     tid;
@property (nonatomic, assign)   NSInteger     tag;
@property (nonatomic , strong)  UIImageView   *imgView;


- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;
- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag;

@end
