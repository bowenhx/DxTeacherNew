//
//  XBSaveAttentionCell.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^checkButtonBlock)(NSInteger tag);

#import <UIKit/UIKit.h>
#import "XBElephantModel.h"

@interface XBSaveAttentionCell : UITableViewCell

@property (nonatomic, copy) checkButtonBlock buttonBlock;
@property (nonatomic, strong) XBElephantModel *elephantModel;

+ (instancetype)saveAttentionCellWith:(UITableView *)tableView;

@end
