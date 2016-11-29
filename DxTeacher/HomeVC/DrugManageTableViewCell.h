//
//  DrugManageTableViewCell.h
//  DxTeacher
//
//  Created by Stray on 16/10/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrugManageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *drugView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *lineV;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnUse;

@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UILabel *labDrugName;

@property (weak, nonatomic) IBOutlet UILabel *labNum;

@property (weak, nonatomic) IBOutlet UILabel *labUseTime;

@property (weak, nonatomic) IBOutlet UILabel *labPerson;

@property (weak, nonatomic) IBOutlet UIButton *btnUseDrug;



@property (nonatomic , copy) NSDictionary *info;







@end
