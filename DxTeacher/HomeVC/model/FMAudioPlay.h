//
//  FMAudioPlay.h
//  DxTeacher
//
//  Created by Stray on 16/11/29.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMAudioPlay : NSObject

+ (FMAudioPlay *)sharePlay:(NSString *)url;

- (instancetype)initWithAudioURL:(NSString *)url;

@property (nonatomic , copy) NSString *playURL;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器

+ (void)audioPlayerURL:(NSString *)vudioURL Block:(void (^)(NSData *data))block;

@end
