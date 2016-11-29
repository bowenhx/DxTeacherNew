//
//  XBActionRecordWeekCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionRecordWeekCell.h"
#import "XBActionRecordWeekModel.h"
#import "XBActionRecordMonthModel.h"

@interface XBActionRecordWeekCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XBActionRecordWeekCell

#pragma mark - 重写setter方法给属性赋值
- (void)setWeekModel:(XBActionRecordWeekModel *)weekModel {
    _weekModel = weekModel;
    
    _titleLabel.text = weekModel.title;
    _contentLabel.text = weekModel.content;
}

- (void)setMonthModel:(XBActionRecordMonthModel *)monthModel {
    _monthModel = monthModel;
    
    _titleLabel.text = monthModel.title;
    _contentLabel.text = monthModel.content;
}

#pragma mark - 初始化方法
+ (instancetype)actionRecordWeekCellWith:(UITableView *)tableView {
    XBActionRecordWeekCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBActionRecordWeekCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBActionRecordWeekCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
