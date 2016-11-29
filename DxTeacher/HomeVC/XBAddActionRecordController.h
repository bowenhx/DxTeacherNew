//
//  XBAddActionRecordController.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^finishBlock)();

#import "BaseViewController.h"

@interface XBAddActionRecordController : BaseViewController

@property (nonatomic, copy) finishBlock finishBlock;
@property (nonatomic, copy) NSString *childName;

/**
 给小孩发布记录的时候用,用来判断是否是小孩
 */
@property (nonatomic, copy) NSString *childID;

@end
