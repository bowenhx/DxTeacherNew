//
//  FindTableViewCell.h
//  DxTeacher
//
//  Created by Stray on 16/10/28.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindListViewCell.h"

@interface FindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *collect;

@property (weak, nonatomic) IBOutlet UILabel *content;

@property (nonatomic , copy) NSDictionary *info;


@end
