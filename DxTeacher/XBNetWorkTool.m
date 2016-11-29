//
//  XBNetWorkTool.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/26.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBNetWorkTool.h"

@implementation XBNetWorkTool

static XBNetWorkTool *_instance;
+ (instancetype)shareNetWorkTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:nil];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        
        [_instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_instance.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [_instance.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _instance.requestSerializer.timeoutInterval = 30.0;
        [_instance.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    });
    return _instance;
}

@end
