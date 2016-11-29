//
//  XBTeacherCell.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/23.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBTeacherCell.h"

@interface XBTeacherCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation XBTeacherCell

#pragma mark - 重写setter方法给属性赋值
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    _titleLabel.text = elephantModel.title;
    _detailLabel.text = elephantModel.zhaiyao;
}

#pragma mark 初始化方法
+ (instancetype)teacherCellWith:(UITableView *)tableView {
    XBTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBTeacherCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBTeacherCell" owner:nil options:nil] firstObject];
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
