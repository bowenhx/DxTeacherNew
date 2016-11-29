//
//  GrowLogCollectionViewCell.h
//  DxTeacher
//
//  Created by ligb on 16/11/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowLogCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labRZ;

@property (weak, nonatomic) IBOutlet UILabel *labSL;

@property (nonatomic , strong) NSDictionary *item;
@end
