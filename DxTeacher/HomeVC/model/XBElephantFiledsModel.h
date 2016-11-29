//
//  XBElephantFiledsModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/27.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBElephantFiledsModel : NSObject
/*"AuthorID": "0",
 "grade_name": "大一班",
 "fm_type": "视频",
 "author": "王园长"*/
@property (nonatomic, copy) NSString *AuthorID;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, copy) NSString *fm_type;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *video_src;
@property (nonatomic, copy) NSString *childname;
@property (nonatomic, copy) NSString *childid;

@end
