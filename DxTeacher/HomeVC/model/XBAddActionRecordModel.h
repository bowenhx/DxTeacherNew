//
//  XBAddActionRecordModel.h
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface XBAddActionRecordModel : NSObject
/*"id": 109,
 "channel_id": 22,
 "title": "性格维度3",
 "call_index": "",
 "parent_id": 98,
 "class_list": ",96,98,109,",
 "class_layer": 3,
 "sort_id": 99,
 "link_url": "",
 "img_url": "",
 "content": "",
 "seo_title": "",
 "seo_keywords": "",
 "seo_description": */
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *call_index;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *class_list;
@property (nonatomic, copy) NSString *class_layer;
@property (nonatomic, copy) NSString *sort_id;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *seo_title;
@property (nonatomic, copy) NSString *seo_keywords;
@property (nonatomic, copy) NSString *seo_description;

@end
