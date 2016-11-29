//
//  XBTeacherCell.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/23.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBElephantModel.h"

@interface XBTeacherCell : UITableViewCell

@property (nonatomic, strong) XBElephantModel *elephantModel;

+ (instancetype)teacherCellWith:(UITableView *)tableView;

@end
