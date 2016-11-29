//
//  XBElephantModel.h
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/27.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "XBElephantFiledsModel.h"
#import "XBAttachModel.h"
#import "XBAlbumsModel.h"

@interface XBElephantModel : NSObject
/* "id": 113,
 "channel_id": 15,
 "category_id": 67,
 "call_index": "",
 "title": "测试视频",
 "link_url": "",
 "img_url": "/upload/201610/17/201610172154537301.png",
 "seo_title": "",
 "seo_keywords": "",
 "seo_description": "",
 "zhaiyao": "测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视频呢测试视…",
 "content": "",
 "sort_id": 99,
 "click": 0,
 "status": 0,
 "is_msg": 0,
 "is_top": 0,
 "is_red": 0,
 "is_hot": 0,
 "is_slide": 0,
 "is_sys": 1,
 "user_name": "admin",
 "add_time": "/Date(1476712494000)/",
 "update_time": null,
 "fields": {},
 "albums": [ ],
 "attach": [
 {}
 ],
 "group_price": [ ],
 "comment": [ ]
 "shoucangcount": 0,
 "dianzancount": 1*/
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *call_index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *seo_title;
@property (nonatomic, copy) NSString *seo_keywords;
@property (nonatomic, copy) NSString *seo_description;
@property (nonatomic, copy) NSString *zhaiyao;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sort_id;
@property (nonatomic, copy) NSString *click;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *is_msg;
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *is_red;
@property (nonatomic, copy) NSString *is_hot;
@property (nonatomic, copy) NSString *is_slide;
@property (nonatomic, copy) NSString *is_sys;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *add_time;
/** 转换过后的时间串 */
@property (nonatomic, copy) NSString *add_timeString;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, strong) XBElephantFiledsModel *fields;
@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) NSArray *attach;
@property (nonatomic, strong) NSArray *group_price;
@property (nonatomic, strong) NSArray *comment;
@property (nonatomic, copy) NSString *shoucangcount;
@property (nonatomic, copy) NSString *dianzancount;
@property (nonatomic, strong) NSArray *supportArray;
@property (nonatomic, strong) NSArray *article_zan;

@end
