//
//  MyCheckTabCell.h
//  DxTeacher
//
//  Created by ligb on 16/11/21.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCheckTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labNumDay1;


@property (weak, nonatomic) IBOutlet UILabel *labNumDay2;

@property (weak, nonatomic) IBOutlet UILabel *labNumDay3;


@property (nonatomic , copy) NSDictionary *info;


@end
