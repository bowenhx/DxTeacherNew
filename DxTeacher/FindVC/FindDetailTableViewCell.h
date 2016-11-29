//
//  FindDetailTableViewCell.h
//  DxTeacher
//
//  Created by Stray on 16/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface FindDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UILabel *labClass;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labDescription;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;


@property (weak, nonatomic) IBOutlet CustomImageView *imagesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesHeight;


@property (nonatomic  , copy) NSDictionary *info;

@end
