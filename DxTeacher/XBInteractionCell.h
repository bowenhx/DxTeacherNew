//
//  XBInteractionCell.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/27.
//  Copyright © 2016年 周旭斌. All rights reserved.
//
typedef void(^deleteBlock)(NSInteger tag);

#import <UIKit/UIKit.h>
#import "XBAddWeekRecordModel.h"

@interface XBInteractionCell : UICollectionViewCell

@property (nonatomic, copy) deleteBlock deleteBlock;
@property (nonatomic, strong) XBAddWeekRecordModel *recordModel;

@end
