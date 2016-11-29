//
//  XBLeaveModel.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/22.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface XBLeaveModel : NSObject
/*"id": 285,
 "leave_type": "病假",
 "leave_start": "2016-11-18",
 "leave_enddate": "2016-11-20",
 "content"*/
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *leave_type;
@property (nonatomic, copy) NSString *leave_start;
@property (nonatomic, copy) NSString *leave_enddate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *user_name;

@end
