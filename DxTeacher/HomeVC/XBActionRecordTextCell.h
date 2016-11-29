//
//  XBActionRecordTextCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/22.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBActionRecordTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)actionRecordTextCellWith:(UITableView *)tableView;

@end
