//
//  XBDiscoveryAddCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/21.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBDiscoveryAddCell.h"
#import "XBElephantModel.h"

@interface XBDiscoveryAddCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XBDiscoveryAddCell

#pragma mark - 重写setter方法给属性赋值
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    _titleLabel.text = elephantModel.title;
    _contentLabel.text = elephantModel.zhaiyao;
}

- (IBAction)addButtonClick:(UIButton *)sender {
    if (_buttonBlock) {
        self.buttonBlock(self.tag);
    }
}

#pragma mark - 私有方法
+ (instancetype)discoveryAddCellWith:(UITableView *)tableView {
    XBDiscoveryAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBDiscoveryAddCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBDiscoveryAddCell" owner:nil options:nil] firstObject];
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
