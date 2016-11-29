//
//  XBAlbumsModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/28.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBAlbumsModel : NSObject
/* "id": 91,
 "article_id": 112,
 "thumb_path": "/upload/201610/17/201610171417523105.png",
 "original_path": "/upload/201610/17/201610171417523105.png",
 "remark": "",
 "add_time": "/Date(1476685082000)/"*/
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *thumb_path;
@property (nonatomic, copy) NSString *original_path;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *add_time;

@end
