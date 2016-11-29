//
//  XBActionRecordBaseModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/18.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface XBActionRecordBaseModel : NSObject
/*Childid": "8",
 "Childname": "小青",
 "Childavator": "/upload/201611/18/201611181252142767.jpg",
 "Actiontypes*/
@property (nonatomic, copy) NSString *Childid;
@property (nonatomic, copy) NSString *Childname;
@property (nonatomic, copy) NSString *Childavator;
@property (nonatomic, strong) NSArray *Actiontypes;

@end
