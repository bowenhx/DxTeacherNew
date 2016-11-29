//
//  FindListViewCell.h
//  DxTeacher
//
//  Created by Stray on 16/10/28.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
typedef void(^moreBlock)();
typedef void(^addAttentionBlock)();

#import <UIKit/UIKit.h>
#import "XBElephantModel.h"

@interface FindListViewCell : UIView

+ (instancetype)findListViewCell;

+ (instancetype)findListImgView;

@property (weak, nonatomic) IBOutlet UILabel *labType;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labAbout;

@property (weak, nonatomic) IBOutlet UILabel *labSection;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (nonatomic , strong) UILabel *labLine;

@property (nonatomic, copy) moreBlock moreBlock;
@property (nonatomic, copy) addAttentionBlock addBlock;
@property (nonatomic, strong) XBElephantModel *elephantModel;

@end
