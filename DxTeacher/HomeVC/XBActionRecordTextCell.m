//
//  XBActionRecordTextCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/22.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionRecordTextCell.h"

@implementation XBActionRecordTextCell

+ (instancetype)actionRecordTextCellWith:(UITableView *)tableView {
    XBActionRecordTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBActionRecordTextCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBActionRecordTextCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
