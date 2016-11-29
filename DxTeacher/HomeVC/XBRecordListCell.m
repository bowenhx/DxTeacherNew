//
//  XBRecordListCell.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBRecordListCell.h"
#import "UIButton+WebCache.h"

@interface XBRecordListCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation XBRecordListCell

#pragma mark - 重写setter方法给属性赋值
- (void)setListModel:(XBRecordListModel *)listModel {
    _listModel = listModel;
    _nameLabel.text = listModel.user_name;
    
    if (listModel.isHideLabel) {
        [_iconButton setImage:[UIImage imageNamed:@"dte_vi_Add_1"] forState:UIControlStateNormal];
        _numberLabel.hidden = YES;
    }else {
        [_iconButton sd_setImageWithURL:[NSURL URLWithString:[XBURLHEADER stringByAppendingString:listModel.avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
        _numberLabel.hidden = NO;
        _numberLabel.text = listModel.xingweijilu;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.borderColor = XBColor(235, 235, 235, 1.0).CGColor;
    self.contentView.layer.borderWidth = 1.0;
    
    CGFloat width = (kScreenWidth - 80) / 3 - 50;
    _iconButton.layer.cornerRadius = width * 0.5;
    _iconButton.layer.masksToBounds = YES;
    
    _numberLabel.layer.cornerRadius = 8;
    _numberLabel.layer.masksToBounds = YES;
}

@end
