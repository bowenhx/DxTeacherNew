//
//  XBAddWeekRecordModel.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBAddWeekRecordModel : NSObject <NSCopying>

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, assign, getter=isSelect) BOOL select;
@property (nonatomic, copy) NSString *imagePath;

@end
