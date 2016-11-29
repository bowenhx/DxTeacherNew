//
//  XBLeaveCell.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBLeaveCell.h"

@interface XBLeaveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *leaveTypeButton;

@end

@implementation XBLeaveCell

#pragma mark - 重写setter方法给属性赋值
- (void)setLeaveModel:(XBLeaveModel *)leaveModel {
    _leaveModel = leaveModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[XBURLHEADER stringByAppendingString:leaveModel.img_url]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed | SDWebImageProgressiveDownload];
    _nameLabel.text = leaveModel.user_name;
    _dateLabel.text = [NSString stringWithFormat:@"%@~%@", leaveModel.leave_start, leaveModel.leave_enddate];
    [_leaveTypeButton setTitle:leaveModel.leave_type forState:UIControlStateNormal];
}

#pragma mark - target事件
- (IBAction)typeButtonClick:(UIButton *)sender {
    if (_buttonBlock) {
        self.buttonBlock(self.tag);
    }
}

#pragma mark - 初始化方法
+ (instancetype)leaveCellWith:(UITableView *)tableView {
    XBLeaveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBLeaveCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBLeaveCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImageView.layer.cornerRadius = 30.0;
    _iconImageView.layer.masksToBounds = YES;
    
    _leaveTypeButton.layer.cornerRadius = 2.0;
    _leaveTypeButton.layer.masksToBounds = YES;
    _leaveTypeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _leaveTypeButton.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
