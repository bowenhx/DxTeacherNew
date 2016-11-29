//
//  XBRecordListModel.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface XBRecordListModel : NSObject
/*"childid": 8,
 "user_name": "小青",
 "avatar": "/upload/201611/18/201611181252142767.jpg",
 "grade_id": 104,
 "rizhi": 5,
 "siliao": 0,
 "xingweijilu": 12*/
@property (nonatomic, copy) NSString *childid;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *grade_id;
@property (nonatomic, copy) NSString *rizhi;
@property (nonatomic, copy) NSString *siliao;
@property (nonatomic, copy) NSString *xingweijilu;
@property (nonatomic, assign, getter=isHideLabel) BOOL hideLabel;

@end
