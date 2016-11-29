//
//  BLoopImageView.h
//  BKMobile
//
//  Created by Guibin on 15/1/13.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLoopImageItem.h"
@class BLoopImageView;

#pragma mark - SGFocusImageFrameDelegate
@protocol BLoopImageViewDelegate <NSObject>
@optional
- (void)foucusImageFrame:(BLoopImageView *)imageView didSelectItem:(BLoopImageItem *)item;
- (void)foucusImageFrame:(BLoopImageView *)imageView currentItem:(int)index;

@end

@interface BLoopImageView : UIView  <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property BOOL isAutoPlay;
@property (nonatomic, assign) id<BLoopImageViewDelegate> delegate;
@property (nonatomic , strong) NSMutableArray *itemsArr;

- (id)initWithFrame:(CGRect)frame delegate:(id<BLoopImageViewDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto;

- (id)initWithFrame:(CGRect)frame delegate:(id<BLoopImageViewDelegate>)delegate focusImageItems:(BLoopImageItem *)items, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame delegate:(id<BLoopImageViewDelegate>)delegate imageItems:(NSArray *)items;
- (void)scrollToIndex:(int)aIndex;




@end
