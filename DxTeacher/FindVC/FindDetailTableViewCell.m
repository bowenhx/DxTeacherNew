//
//  FindDetailTableViewCell.m
//  DxTeacher
//
//  Created by Stray on 16/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "FindDetailTableViewCell.h"
#import "AppDefine.h"
#import "ItemVIewsHeight.h"

@implementation FindDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 35;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfo:(NSDictionary *)info{
    //头像
    [self.headImg img_setImageWithURL:info[@"img_url"] placeholderImage:nil];
    
    //用户
    self.labName.text = info[@"fields"][@"author"];
    
    //时间
    self.labTime.text = [NSString getDateStringWithString:info[@"add_time"]];
    
    //班级
    self.labClass.text = info[@"fields"][@"source"];
    
   
    
    
    //title
    self.labTitle.text = info[@"title"];
    
    //描述
    self.labDescription.text = info[@"zhaiyao"];
    
    self.descriptionHeight.constant = [ItemVIewsHeight loadTextContentsMaxWidth:16 string:info[@"zhaiyao"]];
    
    
    NSArray *items = info[@"albums"];
    self.imagesView.imgItems = items;
    
    //计算图片height
    self.imagesHeight.constant = [ItemVIewsHeight loadItmesCounts:items.count];
    
   
    
}

@end
