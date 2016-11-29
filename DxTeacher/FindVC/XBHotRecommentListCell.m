//
//  XBHotRecommentListCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBHotRecommentListCell.h"
#import "XBElephantModel.h"
#import "UIImageView+WebCache.h"

@interface XBHotRecommentListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XBHotRecommentListCell

#pragma mark - 重写setter方法给属性赋值
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[XBURLHEADER stringByAppendingString:elephantModel.img_url]] placeholderImage:[UIImage imageNamed:@"占位图"] options:SDWebImageRetryFailed];
    _titleLabel.text = elephantModel.title;
    _contentLabel.text = elephantModel.zhaiyao;
}

#pragma mark - 初始化方法
+ (instancetype)hotRecommentListCellWith:(UITableView *)tableView {
    XBHotRecommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBHotRecommentListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBHotRecommentListCell" owner:nil options:nil] firstObject];
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
