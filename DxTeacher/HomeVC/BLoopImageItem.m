//
//  BLoopImageItem.m
//  BKMobile
//
//  Created by Guibin on 15/1/13.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "BLoopImageItem.h"
#import "UIImageView+WebCache.h"
#import "AppDefine.h"

@implementation BLoopImageItem

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.imgurl = image;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            self.title   = dict[@"title"];
            self.imgurl   = dict[@"imgurl"];
            self.skipurl = dict[@"skipurl"];
            if ([dict[@"type"] integerValue] == 0) {
                self.tid = [dict[@"tid"] integerValue];
            }else
                self.tid = -1;
            //..
        }
    }
    return self;
}

@end
