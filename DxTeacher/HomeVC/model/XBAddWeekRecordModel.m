//
//  XBAddWeekRecordModel.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBAddWeekRecordModel.h"

@implementation XBAddWeekRecordModel

- (id)copyWithZone:(NSZone *)zone {
    XBAddWeekRecordModel *model = [XBAddWeekRecordModel allocWithZone:zone];
    model.iconImage = _iconImage;
    model.imagePath = _imagePath;
    model.select = _select;
    return model;
}

@end
