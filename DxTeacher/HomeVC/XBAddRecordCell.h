//
//  XBAddRecordCell.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define kAddRecordCellHeight 65

typedef void(^labelButtonBlock)(NSString *title);

#import <UIKit/UIKit.h>
#import "XBAddActionRecordModel.h"

@interface XBAddRecordCell : UITableViewCell

@property (nonatomic, strong) XBAddActionRecordModel *actionActionModel;
@property (nonatomic, copy) labelButtonBlock buttonClick;

+ (instancetype)addRecordCellWith:(UITableView *)tableView;

@end
