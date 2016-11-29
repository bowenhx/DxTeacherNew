//
//  XBLeaveCell.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^buttonBlock)(NSInteger tag);

#import <UIKit/UIKit.h>
#import "XBLeaveModel.h"

@interface XBLeaveCell : UITableViewCell

@property (nonatomic, strong) XBLeaveModel *leaveModel;
@property (nonatomic, copy) buttonBlock buttonBlock;

+ (instancetype)leaveCellWith:(UITableView *)tableView;

@end
