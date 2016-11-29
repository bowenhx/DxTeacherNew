//
//  XBActionRecordModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

/**
 行为记录最外层
 */
@interface XBActionRecordModel : NSObject
/*"Id": 100,
 "Name": "改善",
 "Itemcount": 1,
 "Items": */
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Itemcount;
@property (nonatomic, strong) NSArray *Items;

@end
