//
//  FMAudioPlay.m
//  DxTeacher
//
//  Created by Stray on 16/11/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "FMAudioPlay.h"
#import "AppDefine.h"

@implementation FMAudioPlay

+ (FMAudioPlay *)sharePlay:(NSString *)url{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithAudioURL:url];
    });
    return sharedInstance;
}
- (instancetype)initWithAudioURL:(NSString *)url{
    self = [super init];
    if (self) {
        [FMAudioPlay audioPlayerURL:url Block:^(NSData *data) {
            if (data) {
                NSError *error;
                //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
                _audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
                //设置播放器属性
                _audioPlayer.numberOfLoops = 0;//设置为0不循环
                //        _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];//加载音频文件到缓存
                
            }
        }];
    }
    return self;
}

+ (void)audioPlayerURL:(NSString *)vudioURL Block:(void (^)(NSData *data))block{
    
    NSString *paths = [[vudioURL componentsSeparatedByString:@"/"] lastObject];
    
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:paths]];
    
    if (data) {
        block (data);
        return;
    }
    
    NSURL *url = [NSString getPathByAppendString:vudioURL];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error= %@",error);
        }else{
           
            if ([data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:paths] atomically:YES]) {
                NSLog(@"音频文件保存成功");
            }else{
                NSLog(@"音频文件保存失败");
            }

            block (data);
        }
    }] resume];
}


@end
