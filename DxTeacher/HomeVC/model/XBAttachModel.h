//
//  XBAttachModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/27.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBAttachModel : NSObject
/*"id": 18,
 "article_id": 113,
 "file_name": "VID_20160616_123403.mp4",
 "file_path": "/upload/201610/17/201610172155129018.mp4",
 "file_size": 18084,
 "file_ext": "mp4",
 "down_num": 0,
 "point": 0,
 "add_time": "/Date(1476712543000)/"*/
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *file_name;
@property (nonatomic, copy) NSString *file_path;
@property (nonatomic, copy) NSString *file_size;
@property (nonatomic, copy) NSString *file_ext;
@property (nonatomic, copy) NSString *down_num;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *add_time;

@end
