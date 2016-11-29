//
//  XBElephantModel.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/10/27.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBElephantModel.h"

@implementation XBElephantModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"attach" : @"XBAttachModel",
             @"albums" : @"XBAlbumsModel",
             @"comment" : @"XBCommentModel",
             @"article_zan" : @"XBSupportCountModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

#pragma mark - 转换数据
- (NSString *)add_timeString {
    NSTimeInterval timeStamp = [_add_time substringWithRange:NSMakeRange(6, 10)].integerValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    return [dateFormatter stringFromDate:date];
}

@end
