//
//  GrowLogCollectionViewCell.m
//  DxTeacher
//
//  Created by ligb on 16/11/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "GrowLogCollectionViewCell.h"
#import "AppDefine.h"
#import "UIButton+WebCache.h"

@implementation GrowLogCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentView.layer.borderColor = XBColor(235, 235, 235, 1.0).CGColor;
    self.contentView.layer.borderWidth = 1.0;
    
    CGFloat width = (kScreenWidth - 80) / 3 - 50;
    _iconBtn.layer.cornerRadius = width * 0.5;
    _iconBtn.layer.masksToBounds = YES;
    
    _labRZ.layer.cornerRadius = 8;
    _labRZ.layer.masksToBounds = YES;
    
    _labSL.layer.cornerRadius = 8;
    _labSL.layer.masksToBounds = YES;
}
- (void)setItem:(NSDictionary *)item{
    NSURL *icon = [NSString getPathByAppendString:item[@"avatar"]];
    [_iconBtn sd_setBackgroundImageWithURL:icon forState:0];
    
    _labTitle.text = item[@"user_name"];
    
    _labSL.text = [NSString stringWithFormat:@"%@",item[@"siliao"]];
    _labRZ.text =  [NSString stringWithFormat:@"%@",item[@"rizhi"]];
    
}
@end
