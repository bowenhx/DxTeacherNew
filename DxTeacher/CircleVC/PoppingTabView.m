//
//  PoppingTabView.m
//  BKMobile
//
//  Created by Guibin on 15/11/16.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "PoppingTabView.h"
#import "AppDefine.h"

@implementation PoppingTabView
@synthesize itemArrs = _itemArrs;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        _isTaxis = YES; // 順序
    }
    return self;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.backgroundColor = [UIColor colorAppBg];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = @"#31B7B6".color;
//        _tableView.separatorColor = @"#D04476".color;
        _tableView.rowHeight = 40;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
    }
    return _tableView;
}
- (NSArray *)itemArrs
{
    if (!_itemArrs) {
        _itemArrs = [NSArray array];
    }
    return _itemArrs;
}
- (void)layoutSubviews
{
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.bounds));
    
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, self.w-6, self.h-6)];
    UIImage *image = [UIImage imageNamed:@"xinxi"];
    imgBg.image = image;
    _tableView.backgroundView = imgBg;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)refreshTab
{
    [self.tableView reloadData];
}
#pragma mark TableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArrs.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defineCell = @"defineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:defineCell];
    }
//    cell.backgroundColor = [UIColor colorAppBg];
    //cell.imageView.image = [UIImage imageNamed:self.itemArrs[indexPath.row][0]];
    cell.textLabel.text = self.itemArrs[indexPath.row];
   
//    if (indexPath.row == 1) {
//        if (_isTaxis) {
//            cell.imageView.image = [UIImage imageNamed:self.itemArrs[indexPath.row][0]];
//            cell.textLabel.text = self.itemArrs[indexPath.row][1];
//        }else{
//            cell.imageView.image = [UIImage imageNamed:self.itemArrs[indexPath.row][2]];
//            cell.textLabel.text = self.itemArrs[indexPath.row][3];
//        }
//    }
   
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate) {
        [_delegate selectItem:self.itemArrs[indexPath.row] index:indexPath.row];
    }
}
@end
