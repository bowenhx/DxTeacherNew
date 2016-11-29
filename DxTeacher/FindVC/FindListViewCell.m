//
//  FindListViewCell.m
//  DxTeacher
//
//  Created by Stray on 16/10/28.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "FindListViewCell.h"
#import "AppDefine.h"

@implementation FindListViewCell

#pragma mark - 重写setter方法给属性赋值
- (void)setElephantModel:(XBElephantModel *)elephantModel {
    _elephantModel = elephantModel;
    
    _labTitle.text = elephantModel.title;
}

#pragma mark - target事件
- (IBAction)moreButtonClick:(UIButton *)sender {
    if (_moreBlock) {
        self.moreBlock();
    }
}

- (IBAction)addAttentionButtonClick:(UIButton *)sender {
    if (_addBlock) {
        self.addBlock();
    }
}

+ (instancetype)findListViewCell{
    FindListViewCell *findView = [[[NSBundle mainBundle] loadNibNamed:@"FindListViewCell" owner:nil options:nil] lastObject];
    //[findView setW:[UIScreen mainScreen].bounds.size.width];
    return findView;
}

+ (instancetype)findListImgView{
    FindListViewCell *findView = [[[NSBundle mainBundle] loadNibNamed:@"FindListImgView" owner:nil options:nil] lastObject];
    //[findView setW:[UIScreen mainScreen].bounds.size.width];
    return findView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labType.clipsToBounds = YES;
    self.labType.backgroundColor = [UIColor colorAppBg];
    self.labType.layer.cornerRadius = 2;
    self.labType.textColor = [UIColor whiteColor];
    self.labType.font = [UIFont systemFontOfSize:13];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        FindListViewCell *findView = [[[NSBundle mainBundle] loadNibNamed:@"FindListViewCell" owner:nil options:nil] lastObject];
        self = findView;
        self.frame = frame;
    }
    return self;
}
- (void)layoutSubviews{
    self.frame = CGRectMake(0, self.y + 1, self.screen_W, 70);
}

- (UILabel *)labLine{
    if (!_labLine) {
        _labLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.h-1, self.screen_W, 1)];
        _labLine.backgroundColor = @"#cccccc".color;
        [self addSubview:_labLine];
    }
    return _labLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
