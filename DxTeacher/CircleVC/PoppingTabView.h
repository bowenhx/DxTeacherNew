//
//  PoppingTabView.h
//  BKMobile
//
//  Created by Guibin on 15/11/16.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
#import <UIKit/UIKit.h>


@protocol PoppingTabViewDelegate <NSObject>

- (void)selectItem:(id)obj index:(NSInteger)index;

@end


@interface PoppingTabView : UIView <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , assign) id<PoppingTabViewDelegate> delegate;
@property (nonatomic , strong) NSArray *itemArrs;
@property (nonatomic , strong) UITableView *tableView;
@property BOOL isTaxis;
- (void)refreshTab;
@end
