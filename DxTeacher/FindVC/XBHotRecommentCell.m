//
//  XBHotRecommentCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/14.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBHotRecommentCell.h"
#import "UIImageView+WebCache.h"
#import "XBElephantModel.h"

@interface XBHotRecommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation XBHotRecommentCell

#pragma mark - 重写setter方法给属性赋值
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    [_myImageView sd_setImageWithURL:[NSURL URLWithString:[XBURLHEADER stringByAppendingString:elephantModel.img_url]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed | SDWebImageProgressiveDownload];
    _myLabel.text = elephantModel.title;
}

@end
