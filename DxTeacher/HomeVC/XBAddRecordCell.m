//
//  XBAddRecordCell.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBAddRecordCell.h"

@interface XBAddRecordCell ()

@property (weak, nonatomic) IBOutlet UIButton *labelButton;

@end

@implementation XBAddRecordCell

#pragma mark - target事件
- (IBAction)buttonClick:(UIButton *)sender {
    if (_buttonClick) {
        self.buttonClick(sender.currentTitle);
    }
}

#pragma mark - 重写sette方法给属性赋值
- (void)setActionActionModel:(XBAddActionRecordModel *)actionActionModel {
    _actionActionModel = actionActionModel;
    
    [_labelButton setTitle:actionActionModel.title forState:UIControlStateNormal];
}

#pragma mark - 初始化方法
+ (instancetype)addRecordCellWith:(UITableView *)tableView {
    XBAddRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBAddRecordCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBAddRecordCell" owner:nil options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    _labelButton.layer.cornerRadius = (kAddRecordCellHeight - 16) * 0.5;
    _labelButton.layer.masksToBounds = YES;
    _labelButton.layer.borderWidth = 1.0;
    _labelButton.layer.borderColor = [UIColor colorWithRed:253 / 255.0 green:137 / 255.0 blue:106 / 255.0 alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
