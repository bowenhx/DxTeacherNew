//
//  XBActionRecordDayCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBActionRecordSecondModel.h"

@interface XBActionRecordDayCell : UITableViewCell

/**
 数据源
 */
@property (nonatomic, strong) XBActionRecordSecondModel *secondModel;

+ (instancetype)actionRecordDayCellWith:(UITableView *)tableView;

@end
