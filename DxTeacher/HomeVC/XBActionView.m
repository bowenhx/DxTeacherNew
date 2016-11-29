//
//  XBActionView.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/29.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBActionView.h"

@interface XBActionView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) selectBlock selectBlock;

@end

@implementation XBActionView

+ (void)showActionViewWithSelectIndex:(selectBlock)selectBlock {
    XBActionView *actionView = [[XBActionView alloc] init];
    actionView.selectBlock = selectBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:actionView];
    actionView.frame = CGRectMake(0, 44 * 3 + 8, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:.25 animations:^{
        actionView.xb_y(0);
    }];
}

- (void)dismissActionView {
    [UIView animateWithDuration:.25 animations:^{
        self.xb_y(44 * 3 + 8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)init {
    if (self == [super init]) {
        UIView *coverView = [[UIView alloc] init];
        [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        coverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:coverView];
        
        UITableView *tableView = [[UITableView alloc] init];
        [self addSubview:tableView];
        tableView.backgroundColor = XBColor(233, 234, 236, 1.0);
        tableView.scrollEnabled = NO;
        tableView.frame = CGRectMake(0, kScreenHeight - 44 * 3 - 8, kScreenWidth, 44 * 3 + 8);
        tableView.dataSource = self;
        tableView.delegate = self;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, kScreenWidth, 44);
        [cell.contentView addSubview:label];
        label.tag = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row].integerValue;
    }
    UILabel *label = [cell viewWithTag:[NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row].integerValue];
    label.textAlignment = NSTextAlignmentCenter;
    if (indexPath.section == 1) {
        label.text = @"取消";
    }else {
        if (indexPath.row == 0) {
            label.text = @"拍照";
        }else {
            label.text = @"从手机相册选择";
        }
//        if (indexPath.row == 0) {
//            label.text = @"小视频";
//        }else if (indexPath.row == 1) {
//            label.text = @"拍照";
//        }else {
//            label.text = @"从手机相册选择";
//        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
    return view;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self dismissActionView];
        return;
    }
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
    [self dismissActionView];
}

#pragma mark - target事件
- (void)tap:(UITapGestureRecognizer *)tap {
    [self dismissActionView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
