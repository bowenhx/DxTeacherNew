//
//  XBActionRecordCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/22.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionRecordCell.h"

@implementation XBActionRecordCell

+ (instancetype)actionRecordCellWith:(UITableView *)tableView {
    XBActionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBActionRecordCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBActionRecordCell" owner:nil options:nil] firstObject];
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
