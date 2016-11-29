//
//  XBFindHotRecommendView.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/24.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "XBFindHotRecommendView.h"
#import "XBHotRecommentCell.h"

@interface XBFindHotRecommendView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation XBFindHotRecommendView

#pragma mark - 重写setter方法给属性赋值
- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    
    [self.collectionView reloadData];
}

#pragma mark - target事件
- (IBAction)moreButtonClick {
    if (_moreBlock) {
        self.moreBlock();
    }
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XBHotRecommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XBHotRecommentCell" forIndexPath:indexPath];
    cell.elephantModel = _dataList[indexPath.item];
    return cell;
}

#pragma mark - 初始化方法
+ (instancetype)findHotRecommendView {
    return [[[NSBundle mainBundle] loadNibNamed:@"XBFindHotRecommendView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 配置item
    CGFloat margin = 8.0;
    CGFloat itemW = (kScreenWidth - 5 * margin) / 4;
    _flowLayout.itemSize = CGSizeMake(itemW, itemW + 20);
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"XBHotRecommentCell" bundle:nil] forCellWithReuseIdentifier:@"XBHotRecommentCell"];
    
    _titleLabel.layer.cornerRadius = 2;
    _titleLabel.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
