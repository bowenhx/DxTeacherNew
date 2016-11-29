//
//  MyCheckTabCell.m
//  DxTeacher
//
//  Created by ligb on 16/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "MyCheckTabCell.h"
#import "AppDefine.h"
@implementation MyCheckTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labNumDay1.textColor = [UIColor colorAppBg];
    self.labNumDay2.textColor = [UIColor colorAppBg];
    self.labNumDay3.textColor = [UIColor colorAppBg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfo:(NSDictionary *)info{
    self.labTitle.text = info[@"Month"];
    
    self.labNumDay1.text = info[@"Chuqin"];
    self.labNumDay2.text = info[@"Shijia"];
    self.labNumDay3.text = info[@"Bingjia"];
}

@end
