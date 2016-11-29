//
//  XBFindHotRecommendView.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^moreBlock)();

#import <UIKit/UIKit.h>

@interface XBFindHotRecommendView : UIView

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, copy) moreBlock moreBlock;

+ (instancetype)findHotRecommendView;

@end
