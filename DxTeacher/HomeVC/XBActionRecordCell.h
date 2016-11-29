//
//  XBActionRecordCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/22.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBActionRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)actionRecordCellWith:(UITableView *)tableView;

@end
