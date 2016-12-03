//
//  DrugManageTableViewCell.m
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "DrugManageTableViewCell.h"
#import "AppDefine.h"
@implementation DrugManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 35;
    
    self.drugView.layer.borderWidth = 1;
    self.drugView.layer.borderColor = [UIColor colorLineBg].CGColor;
    self.drugView.layer.cornerRadius = 7;
    
    self.lineV.backgroundColor = [UIColor colorLineBg];
    
    self.btnUse.layer.borderWidth = 1;
    self.btnUse.layer.borderColor = [UIColor colorLineBg].CGColor;
    
    UIImage *image = [[UIImage imageNamed:@"det_vi_rad"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [ self.btnUseDrug setBackgroundImage:image forState:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfo:(NSDictionary *)info{
    [self.imgView img_setImageWithURL:info[@"img_url"] placeholderImage:nil];
    
    self.labTitle.text = info[@"drugs_child"];
    
    self.labTime.text = info[@"drugs_date"];
    
    self.labDrugName.text = info[@"title"];
    
    self.labNum.text = info[@"drugs_quantum"];
    
    self.labUseTime.text = info[@"drugs_time"];
    
    self.labPerson.text = info[@"drugs_sender"];
    
    
}
@end
