//
//  XBActionRecordDayCell.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionRecordDayCell.h"
#import "XBActionRecordThirdModel.h"

@interface XBActionRecordDayCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@end

@implementation XBActionRecordDayCell

#pragma mark - 重写setter方法给属性赋值
- (void)setSecondModel:(XBActionRecordSecondModel *)secondModel {
    _secondModel = secondModel;
    
    _titleLabel.text = secondModel.Name;
    _tableViewH.constant = 30 * secondModel.Itemcontents.count;
    [self.tableView reloadData];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _secondModel.Itemcontents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    XBActionRecordThirdModel *thirdModel = _secondModel.Itemcontents[indexPath.row];
    cell.textLabel.text = thirdModel.Title;
    return cell;
}

#pragma mark - 初始化方法
+ (instancetype)actionRecordDayCellWith:(UITableView *)tableView {
    XBActionRecordDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBActionRecordDayCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBActionRecordDayCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
