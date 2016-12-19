//
//  FMVideoTableViewCell.m
//  DxTeacher
//
//  Created by Stray on 16/10/30.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FMVideoTableViewCell.h"
#import "FMVideoTableViewCell.h"
#import "AppDefine.h"
#import "FMAudioPlay.h"


@interface FMVideoTableViewCell ()

@property (nonatomic , strong) NSURL *videoURL;
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;//视频播放控制器

@end

@implementation FMVideoTableViewCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labLineBg.backgroundColor = [UIColor colorLineBg];
    
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 35;
    
}
/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
- (MPMoviePlayerViewController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer=[[MPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
        _moviePlayer.view.frame = self.viewController.view.bounds;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _moviePlayer.moviePlayer.shouldAutoplay = NO;
        [self.viewController presentViewController:_moviePlayer animated:YES completion:^{
            
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_moviePlayer.moviePlayer];
    }
    return _moviePlayer;
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
    
    NSString *path = info[@"attach"][0][@"file_path"];
    @WeakObj(self);
    [FMAudioPlay videoPlayerURL:path block:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            selfWeak.imgVideo.image = image;
        });
    }];
    
    self.moreViewBg.items = info[@"article_zan"];
    
    self.btnDZ.selected = [info[@"is_dianzan"] boolValue];
    NSArray *itemDZ =  info[@"article_zan"];
    if ([itemDZ isKindOfClass:[NSArray class]]) {
        self.moreViewBg.items = itemDZ;
        self.labNumDZ.text = [NSString stringWithFormat:@"%ld",(long)itemDZ.count];
    }
}

- (void)setFindInfo:(NSDictionary *)findInfo{
    
    {
        //修改UI
        self.labBrowse.hidden = YES;
        self.moreViewBg.hidden = YES;
        NSInteger status = [findInfo[@"is_shoucang"] integerValue];
        [self.btnVideoImg setImage:[UIImage imageNamed:@"vi_tjgz"] forState:0];
        [self.btnVideoImg setImage:[UIImage imageNamed:@"vi_tjgz_1"] forState:UIControlStateSelected];
        self.btnVideoImg.selected = status;
        if (status) {
            [self.btnVideoImg setTitle:@"取消收藏" forState:0];
        }else{
             [self.btnVideoImg setTitle:@"收藏" forState:0];
        }
    }
    
    
    [self.headView img_setImageWithURL:findInfo[@"img_url"] placeholderImage:nil];
    
    self.labName.text = findInfo[@"fields"][@"author"];
    
    //时间
    self.labTime.text = [NSString getDateStringWithString:findInfo[@"add_time"]];
    
    //播放次数
//    self.labBrowse.text = [NSString stringWithFormat:@"已浏览%@次",info[@"click"]];
    
    self.labContent.text = findInfo[@"title"];
    
    NSString *path = findInfo[@"fields"][@"video_src"];
    @WeakObj(self);
    [FMAudioPlay videoPlayerURL:path block:^(UIImage *image) {
          dispatch_async(dispatch_get_main_queue(), ^{
              selfWeak.imgVideo.image = image;
          });
    }];
}
- (IBAction)playVideoAction:(UIButton *)sender {
    //播放
    [self.moviePlayer.moviePlayer play];
}


-(void)movieFinishedCallback:(NSNotification*)notify{
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [self.viewController dismissMoviePlayerViewControllerAnimated];
}
@end
