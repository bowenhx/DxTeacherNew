//
//  XBInteractionCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/27.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBInteractionCell.h"
#import "UIImageView+WebCache.h"

@interface XBInteractionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation XBInteractionCell

#pragma mark - target事件
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (_deleteBlock) {
        self.deleteBlock(self.tag);
    }
}

#pragma mark - 重写setter方法给属性赋值
- (void)setRecordModel:(XBAddWeekRecordModel *)recordModel {
    _recordModel = recordModel;
    
    if (recordModel.imagePath) { // 服务器返回的图片
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:recordModel.imagePath] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
        _selectButton.hidden = YES;
    }else { // 本地的图片,需要显示隐藏按钮
        _iconImageView.image = recordModel.iconImage;
        _selectButton.hidden = recordModel.isSelect;
    }
//    if (interactionModel.isSelect) {
//        _selectButton.hidden = YES;
//    }else {
//        _selectButton.hidden = NO;
//    }
}

@end
