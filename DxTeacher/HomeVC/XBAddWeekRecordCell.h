//
//  XBAddWeekRecordCell.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^addButtonBlock)(NSInteger tag, NSMutableArray *imagesArray);
typedef void(^saveButtonBlock)(NSString *content, NSArray *images, NSString *ID, NSString *week, NSInteger sectionIndex);

#import <UIKit/UIKit.h>
#import "XBElephantModel.h"

@interface XBAddWeekRecordCell : UITableViewCell

@property (nonatomic, copy) addButtonBlock buttonBlock;
@property (nonatomic, copy) saveButtonBlock saveBlock;
@property (nonatomic, strong) XBElephantModel *elephantModel;
@property (nonatomic, strong) NSArray *chooseImages;

+ (instancetype)addWeekRecordCellWith:(UITableView *)tableView;

@end
