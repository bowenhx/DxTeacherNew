//
//  XBDiscoveryAddCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/21.
//  Copyright © 2016年 周旭斌. All rights reserved.
//
typedef void(^addButtonClick)(NSInteger index);

#import <UIKit/UIKit.h>
@class XBElephantModel;

@interface XBDiscoveryAddCell : UITableViewCell

@property (nonatomic, copy) addButtonClick buttonBlock;
@property (nonatomic, strong) XBElephantModel *elephantModel;

+ (instancetype)discoveryAddCellWith:(UITableView *)tableView;

@end
