//
//  XBAddWeekRecordCell.m
//  DxTeacher
//
//  Created by 周旭斌 on 2016/11/20.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//
#define XBItemWidth (kScreenWidth - 64) / 3

#import "XBAddWeekRecordCell.h"
#import "XBAddWeekRecordModel.h"
#import "XBInteractionCell.h"

@interface XBAddWeekRecordCell () <UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, assign) CGFloat lastHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonHeight;

@end

@implementation XBAddWeekRecordCell

- (void)setChooseImages:(NSArray *)chooseImages {
    _chooseImages = chooseImages;
    // 确定collectionView的高度
    if (_imagesArray.count == 0) {
        _collectionViewHeight.constant = 1;
    }else if (_imagesArray.count <= 3) {
        _collectionViewHeight.constant = XBItemWidth;
    }else if (_imagesArray.count <= 6) {
        _collectionViewHeight.constant = 2 * XBItemWidth + 8;
    }else {
        _collectionViewHeight.constant = 3 * XBItemWidth + 8;
    }
    _textViewHeight.constant = _collectionViewHeight.constant + _textView.contentSize.height + 47;
    [_imagesArray insertObjects:chooseImages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, chooseImages.count)]];
    [self.collectionView reloadData];
}

#pragma mark - target事件
- (IBAction)saveButtonClick:(UIButton *)sender {
    NSString *week = nil;
    if (self.tag == 0) {
        week = @"四";
    }else if (self.tag == 1) {
        week = @"三";
    }else if (self.tag == 2) {
        week = @"二";
    }else {
        week = @"一";
    }
    if (_saveBlock) {
        self.saveBlock(_textView.text, _imagesArray, _elephantModel.ID, week, self.tag);
    }
}

#pragma mark - 重写setter方法给属性赋值
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    _textView.text = elephantModel.content;
    if (elephantModel.title.length == 0) {
        _saveButton.hidden = NO;
        _saveButtonHeight.constant = 30;
        [_imagesArray removeAllObjects];
        _imagesArray = nil;
        // 添加照片
        _imagesArray = [NSMutableArray array];
        XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
        model.iconImage = [UIImage imageNamed:@"dte_vi_add"];
        model.select = YES;
        [_imagesArray addObject:model];
        _textView.userInteractionEnabled = YES;
        
    }else {
        _saveButton.hidden = YES;
        _saveButtonHeight.constant = 1;
        _textView.userInteractionEnabled = NO;
        //    _saveButton.hidden = elephantModel;
        
        // 确定输入框的高度
        CGFloat textViewH = _textView.contentSize.height;
        
        // 添加照片
        _imagesArray = [NSMutableArray array];
        //    XBAddWeekRecordModel *model = [[XBAddWeekRecordModel alloc] init];
        //    model.iconImage = [UIImage imageNamed:@"dte_vi_add"];
        //    model.select = YES;
        //    [_imagesArray addObject:model];
        
        // 这里要把albumemodel转换成XBAddWeekRecordModel
        for (XBAlbumsModel *albumModel in elephantModel.albums) {
            XBAddWeekRecordModel *recordModel = [[XBAddWeekRecordModel alloc] init];
            recordModel.imagePath = [XBURLHEADER stringByAppendingString:albumModel.thumb_path];
            [_imagesArray insertObject:recordModel atIndex:0];
        }
        //
        //    [_imagesArray insertObjects:elephantModel.albums atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, elephantModel.albums.count)]];
        
        // 确定collectionView的高度
        if (_imagesArray.count == 0) {
            _collectionViewHeight.constant = 1;
        }else if (_imagesArray.count <= 3) {
            _collectionViewHeight.constant = XBItemWidth;
        }else if (_imagesArray.count <= 6) {
            _collectionViewHeight.constant = 2 * XBItemWidth + 8;
        }else {
            _collectionViewHeight.constant = 3 * XBItemWidth + 8;
        }
        _textViewHeight.constant = _collectionViewHeight.constant + textViewH + 47;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self layoutIfNeeded];
        });
        
    }
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XBInteractionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XBInteractionCell" forIndexPath:indexPath];
    XBAddWeekRecordModel *model = _imagesArray[indexPath.item];
    cell.recordModel = model;
    cell.tag = indexPath.item;
    __weak typeof(self) Self = self;
    cell.deleteBlock = ^(NSInteger tag) {
        //        if (model.isVideo) {
        //            Self.uploadData = nil;
        //        }
        [Self.imagesArray removeObjectAtIndex:tag];
        // 确定collectionView的高度
        if (Self.imagesArray.count <= 3) {
            Self.collectionViewHeight.constant = XBItemWidth;
        }else if (_imagesArray.count <= 6) {
            Self.collectionViewHeight.constant = 2 * XBItemWidth + 8;
        }else {
            Self.collectionViewHeight.constant = 3 * XBItemWidth + 8;
        }
        [Self.collectionView reloadData];
    };
    return cell;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _imagesArray.count - 1) {
        [self endEditing:YES];
        if (_buttonBlock) {
            self.buttonBlock(self.tag, [self.imagesArray subarrayWithRange:NSMakeRange(0, self.imagesArray.count - 1)]);
        }
    }
}

#pragma mark - textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        XBLog(@"%@", textView.text);
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat contentHeight = textView.contentSize.height;
    self.elephantModel.content = textView.text;
    if (contentHeight > 35) {
        if (contentHeight > self.lastHeight) {
            _textViewHeight.constant = _collectionViewHeight.constant + contentHeight + 47;
            XBLog(@"%f", _textViewHeight.constant);
            dispatch_async(dispatch_get_main_queue(), ^{
                [XBNotificationCenter postNotificationName:@"test" object:self.elephantModel userInfo:@{@"images" : self.imagesArray,
                                                                                                        @"tag" : @(self.tag)}];
            });
        }else {
            
        }
    }
}

#pragma mark - 初始化方法
+ (instancetype)addWeekRecordCellWith:(UITableView *)tableView {
    XBAddWeekRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XBAddWeekRecordCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XBAddWeekRecordCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //  2*8 40
    
    _flowLayout.itemSize = CGSizeMake(XBItemWidth, XBItemWidth);
    _flowLayout.minimumLineSpacing = 8;
    _flowLayout.minimumInteritemSpacing = 4;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"XBInteractionCell" bundle:nil] forCellWithReuseIdentifier:@"XBInteractionCell"];
    
    _textView.delegate = self;
    
    _saveButton.layer.cornerRadius = 5.0;
    _saveButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
