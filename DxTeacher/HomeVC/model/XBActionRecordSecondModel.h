//
//  XBActionRecordSecondModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface XBActionRecordSecondModel : NSObject
/*"Id": 103,
 "Name": "改善维度3",
 "Contentcount": 1,
 "Itemcontents": [],
 "Parentid": 100,
 "Parentname": */
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Contentcount;
@property (nonatomic, strong) NSArray *Itemcontents;
@property (nonatomic, copy) NSString *Parentid;
@property (nonatomic, copy) NSString *Parentname;

@end
