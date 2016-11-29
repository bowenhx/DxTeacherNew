//
//  XBHeaderView.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBHeaderView.h"
#import "XBElephantModel.h"

@interface XBHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation XBHeaderView

- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    _addButton.selected = elephantModel;
}

#pragma mark - target事件
- (IBAction)addButtonClick:(UIButton *)sender {
    NSString *week = nil;
    if (self.tag == 0) {
        week = @"四";
    }else if (self.tag == 1) {
        week = @"三";
    }else if (self.tag == 2) {
        week = @"二";
    }else {
        week = @"一";
    }
    if (_buttonBlock) {
        self.buttonBlock(week, sender);
    }
}

#pragma mark - 初始化方法
+ (instancetype)headerViewWith:(UITableView *)tableView {
    XBHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XBHeaderView"];
    if (!headerView) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"XBHeaderView" owner:nil options:nil] firstObject];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
    }
    return headerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
