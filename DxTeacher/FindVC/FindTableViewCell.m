//
//  FindTableViewCell.m
//  DxTeacher
//
//  Created by Stray on 16/10/28.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "FindTableViewCell.h"

@interface FindTableViewCell()
{
    
}

@end;
@implementation FindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setInfo:(NSDictionary *)info{
    self.title.text = info[@"title"];
    self.content.text = info[@"zhaiyao"];
    
    NSInteger status = [info[@"is_shoucang"] integerValue];
    [self.collect setImage:[UIImage imageNamed:@"vi_tjgz"] forState:0];
    [self.collect setImage:[UIImage imageNamed:@"vi_tjgz_1"] forState:UIControlStateSelected];
    self.collect.selected = status;
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
