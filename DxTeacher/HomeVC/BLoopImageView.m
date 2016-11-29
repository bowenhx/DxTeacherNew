//
//  BLoopImageView.m
//  BKMobile
//
//  Created by Guibin on 15/1/13.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "BLoopImageView.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"
#define WIDTH(v)      (v).frame.size.width
#define rgb(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

@interface BLoopImageView ()
{
    UIScrollView    *_scrollView;
    UIPageControl   *_pageControl;
}
- (void)setupViews;
- (void)switchFocusImageItems;
@end

static char SG_FOCUS_ITEM_ASS_KEY;

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time


@implementation BLoopImageView 
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<BLoopImageViewDelegate>)delegate focusImageItems:(BLoopImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        BLoopImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, BLoopImageItem *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<BLoopImageViewDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = rgb(240, 239, 245);
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<BLoopImageViewDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES];
}
- (void)setItemsArr:(NSMutableArray *)itemsArr
{
    _itemsArr = itemsArr;
    objc_setAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY, itemsArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupViews];
}
- (void)dealloc
{
    objc_setAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;

}


#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY);
    if (imageItems.count ==0) return;
    
    UIImage *image = [UIImage imageNamed:@"def_iv_Lace"];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), self.frame.size.height-image.size.height)];
    _scrollView.scrollsToTop = NO;
//    _scrollView.layer.borderWidth = 1;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH(_scrollView)-80, _scrollView.frame.size.height -16-10, 80, 20)];
    _pageControl.userInteractionEnabled = NO;
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    
    UIImageView *footImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-image.size.height-5, WIDTH(self), image.size.height)];
    footImageView.image = image;
    [self addSubview:footImageView];
    
    
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = imageItems.count>1?imageItems.count -2:imageItems.count;
    _pageControl.currentPage = 0;
    
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(WIDTH(_scrollView) * imageItems.count, _scrollView.frame.size.height);
    float height = _scrollView.frame.size.height;
    for (int i = 0; i < imageItems.count; i++) {
        BLoopImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH(_scrollView), 0, WIDTH(_scrollView), height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.imgurl] placeholderImage:nil];
        
//        [self loadChangeImageUrl:item.imgurl image:^(UIImage *image) {
//            imageView.image = image;
//        }];
        /*
        UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(i * WIDTH(_scrollView), _scrollView.frame.size.height-35, WIDTH(_scrollView), 35)];
        labText.backgroundColor = [UIColor blackColor];
        labText.alpha = .3f;
        labText.text = item.title; //该字段长度统一由后台决定，前台只负责显示
        labText.textColor = [UIColor whiteColor];
        labText.shadowColor = [UIColor blackColor];
        labText.shadowOffset = CGSizeMake(1, 1);*/
        [_scrollView addSubview:imageView];
    }

    if ([imageItems count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(WIDTH(_scrollView), 0) animated:NO] ;
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
        
    }
    
    
    //objc_setAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)loadChangeImageUrl:(NSString *)imgUrl image:(void(^)(UIImage * image))block{
      dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           float height = _scrollView.frame.size.height;
          [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
            {
                UIImage *image = [UIImage imageWithData:data];
                if (image)
                {
                    NSLog(@"img size :%@",NSStringFromCGSize(image.size));
                    //            if (image.size.height < height) {
                    CGRect thumbnailRect = CGRectZero;
                    
                    CGFloat widthFactor = [UIScreen mainScreen].bounds.size.width / image.size.width;
                    CGFloat heightFactor = height / image.size.height;
                    CGFloat scaleFactor = 0.0;
                    
                    if (widthFactor > heightFactor)
                        scaleFactor = heightFactor; // scale to fit height
                    else
                        scaleFactor = widthFactor; // scale to fit width
                    
                    thumbnailRect.size.width  = image.size.width * scaleFactor;
                    thumbnailRect.size.height = image.size.height * scaleFactor;
                    
                    UIGraphicsBeginImageContext(thumbnailRect.size); // this will crop
                    
                    [image drawInRect:thumbnailRect];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    
                    //pop the context to get back to the default
                    UIGraphicsEndImageContext();
                    
                    //            }
                    NSLog(@">>>>  img size :%@",NSStringFromCGSize(image.size));
                    if (image) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            block (image);
                        });
                    }
                }
                else
                {
                    NSLog(@"getImage error= %@  检查url= %@", error.localizedDescription,imgUrl);
                }
            }] resume];
      });
   

}
- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + WIDTH(_scrollView);
    NSArray *imageItems = objc_getAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY);
    targetX = (int)(targetX / WIDTH(_scrollView)) * WIDTH(_scrollView);
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
    
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x /WIDTH(_scrollView));
    if (page > -1 && page < imageItems.count) {
        BLoopImageItem *item = [imageItems objectAtIndex:page];
        if ([_delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [_delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isAutoPlay) {
        NSLog(@"停止循环图片");
        return;
    }
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>=3)
    {
        if (targetX >= WIDTH(_scrollView) * ([imageItems count] -1)) {
            targetX = WIDTH(_scrollView);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = WIDTH(_scrollView) *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+WIDTH(_scrollView)/2.0) / WIDTH(_scrollView);
    //    NSLog(@"%f %d",_scrollView.contentOffset.x,page);
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = _pageControl.numberOfPages -1;
        }
    }
//    if (page!= _pageControl.currentPage)
//    {
//        if (_delegate && [_delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
//        {
//            [_delegate foucusImageFrame:self currentItem:page];
//        }
//    }
    _pageControl.currentPage = page;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/WIDTH(_scrollView)) * WIDTH(_scrollView);
        [self moveToTargetPosition:targetX];
    }
}


- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, &SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = [imageItems count]-3;
        }
        [self moveToTargetPosition:WIDTH(_scrollView) * (aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}


@end
