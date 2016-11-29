//
//  FMAudioTableViewCell.m
//  DxManager
//
//  Created by Stray on 16/10/17.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FMAudioTableViewCell.h"
#import "AppDefine.h"
#import "FMAudioPlay.h"

@interface FMAudioTableViewCell (){
    UIButton *_tempBut;
    NSString *_tempStr;
}
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property (nonatomic , strong)FMAudioPlay *play;
@end

@implementation FMAudioTableViewCell

- (void)dealloc{
   
    [self removeAudioPlayer];
}
- (void)removeAudioPlayer{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        _audioPlayer = nil;
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.labLineBg.backgroundColor = [UIColor colorLineBg];
    
    self.btnPlay.backgroundColor = [UIColor colorAppBg];
    self.btnPlay.layer.cornerRadius = 3;
    
    
}
- (NSString *)stringByUrlEncoding:(NSString *)string{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (__bridge CFStringRef)string,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8);
}

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSString *string = self.info[@"attach"][0][@"file_path"];
        [_tempBut setTitle:@"正在载入..." forState:UIControlStateNormal];
        [FMAudioPlay audioPlayerURL:string Block:^(NSData *data) {
            if (data) {
                NSError *error;
                //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
                _audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
                //设置播放器属性
                _audioPlayer.numberOfLoops=0;//设置为0不循环
                //        _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];//加载音频文件到缓存
//                [_audioPlayer play];
                [_tempBut setTitle:@"点击暂停" forState:UIControlStateNormal];
            }
            
        }];
        
        
        /*
        
        NSURL *url = [NSString getPathByAppendString:self.info[@"attach"][0][@"file_path"]];
        
        [_tempBut setTitle:@"正在载入..." forState:UIControlStateNormal];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error= %@",error);
            }else{
                //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
                _audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
                //设置播放器属性
                _audioPlayer.numberOfLoops=0;//设置为0不循环
                //        _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];//加载音频文件到缓存
                [_tempBut setTitle:@"点击暂停" forState:UIControlStateNormal];
                
//                [NSKeyedArchiver archiveRootObject:data toFile:_tempStr];   //序列化
//                
//                NSData *tempData = [NSKeyedUnarchiver unarchiveObjectWithFile:_tempStr];
//                
//                if ([data writeToFile:_tempStr atomically:YES]) {
//                    NSLog(@"音频文件保存成功");
//                }else{
//                    NSLog(@"音频文件保存失败");
//                }
            }
        }] resume];*/
        /*
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc] initWithData:data error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
//        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAudioPlayer) name:@"audioPlayCenter" object:nil];
        
    }
    return _audioPlayer;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfo:(NSDictionary *)info{
    _info = info;
    [self.headView img_setImageWithURL:info[@"img_url"] placeholderImage:nil];
    
    self.labName.text = info[@"fields"][@"author"];
    
    //时间
    self.labTime.text = [NSString getDateStringWithString:info[@"add_time"]];
    
    //播放次数
    self.labBrowse.text = [NSString stringWithFormat:@"已浏览%@次",info[@"click"]];
    
    self.labContent.text = info[@"title"];
    
    
}

- (IBAction)playAudioAction:(UIButton *)sender {

//    NSString *string = self.info[@"attach"][0][@"file_path"];
//    
//    FMAudioPlay *play = [FMAudioPlay sharePlay:string];
//    if (play.audioPlayer) {
//        if (play.audioPlayer.isPlaying) {
//            [play.audioPlayer pause];
//            [self.btnPlay setTitle:@"点击播放" forState:0];
//        }else{
//            [play.audioPlayer play];
//            [self.btnPlay setTitle:@"点击暂停" forState:0];
//        }
//        
//    }else{
//        [sender setTitle:@"正在载入..." forState:UIControlStateNormal];
//    }
    
    _tempBut = sender;
   
    //播放
    if (self.audioPlayer) {
        if ([self.audioPlayer isPlaying]) {
            [_audioPlayer pause];
            [self.btnPlay setTitle:@"点击播放" forState:0];
        }else{
            [_audioPlayer play];
            [self.btnPlay setTitle:@"点击暂停" forState:0];
        }
    }else{
       [_btnPlay setTitle:@"正在载入..." forState:UIControlStateNormal];
    }
//        return;
//    }
    
    
     /*
    [sender setTitle:@"正在载入..." forState:UIControlStateNormal];
    
    
    NSString *string = self.info[@"attach"][0][@"file_path"];
    NSString *paths = [[string componentsSeparatedByString:@"/"] lastObject];

    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:paths]];
    
    __block NSError *error;
    
    if (data) {
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        //        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        
        [_audioPlayer play];
        
        return;
    }
    
    [self audioPlayerBlock:^(NSData *data) {
        if (data) {
            //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
            _audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
            //设置播放器属性
            _audioPlayer.numberOfLoops=0;//设置为0不循环
            //        _audioPlayer.delegate = self;
            [_audioPlayer prepareToPlay];//加载音频文件到缓存
            
            [_audioPlayer play];
            
//            [NSKeyedArchiver archiveRootObject:data toFile:@"1111_mp3"];   //序列化
//
//            NSData *tempData = [NSKeyedUnarchiver unarchiveObjectWithFile:@"1111_mp3"];
            
            
            if ([data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:paths] atomically:YES]) {
                NSLog(@"音频文件保存成功");
            }else{
                NSLog(@"音频文件保存失败");
            }

            
            if(error){
                NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            }
        }
    }];
    
   
    
    */
    
}

- (void)audioPlayerBlock:(void (^)(NSData *data))block{
   
    NSURL *url = [NSString getPathByAppendString:self.info[@"attach"][0][@"file_path"]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error= %@",error);
        }else{
            block (data);
        }
    }] resume];
}
@end
