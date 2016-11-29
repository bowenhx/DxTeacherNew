//
//  XBHotRecommentListCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBElephantModel;

@interface XBHotRecommentListCell : UITableViewCell

@property (nonatomic, strong) XBElephantModel *elephantModel;

+ (instancetype)hotRecommentListCellWith:(UITableView *)tableView;

@end
