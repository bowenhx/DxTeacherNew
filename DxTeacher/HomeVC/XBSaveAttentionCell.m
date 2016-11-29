//
//  XBSaveAttentionCell.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBSaveAttentionCell.h"

@interface XBSaveAttentionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation XBSaveAttentionCell

#pragma mark - target事件
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[XBURLHEADER stringByAppendingString:elephantModel.img_url]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    _nameLabel.text = elephantModel.fields.childname;
    _actionLabel.text = elephantModel.title;
    _dateLabel.text = elephantModel.add_timeString;
}

#pragma mark - target事件
- (IBAction)checkButtonClick:(UIButton *)sender {
    if (_buttonBlock) {
        self.buttonBlock(self.tag);
    }
}

#pragma mark - 初始化方法
+ (instancetype)saveAttentionCellWith:(UITableView *)tableView {
    XBSaveAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBSaveAttentionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBSaveAttentionCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _checkButton.layer.borderWidth = 1.0;
    _checkButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _checkButton.layer.cornerRadius = 2.0;
    _checkButton.layer.masksToBounds = YES;
    
    _iconImageView.layer.cornerRadius = 30.0;
    _iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
