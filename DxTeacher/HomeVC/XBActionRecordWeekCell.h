//
//  XBActionRecordWeekCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBActionRecordWeekModel,XBActionRecordMonthModel;

@interface XBActionRecordWeekCell : UITableViewCell

@property (nonatomic, strong) XBActionRecordWeekModel *weekModel;
@property (nonatomic, strong) XBActionRecordMonthModel *monthModel;

+ (instancetype)actionRecordWeekCellWith:(UITableView *)tableView;

@end
