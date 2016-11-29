//
//  XBHeaderView.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^buttonBlock)(NSString *week, UIButton *button);

#import <UIKit/UIKit.h>
@class XBElephantModel;

@interface XBHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) XBElephantModel *elephantModel;
@property (nonatomic, copy) buttonBlock buttonBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)headerViewWith:(UITableView *)tableView;

@end
