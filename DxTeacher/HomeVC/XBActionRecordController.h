//
//  XBActionRecordController.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/21.
//  Copyright © 2016年 周旭斌. All rights reserved.
//
typedef void(^requestNewDataBlock)();

#import "BaseViewController.h"

@interface XBActionRecordController : BaseViewController

@property (nonatomic, copy) NSString *childID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) requestNewDataBlock requestBlock;

@end
