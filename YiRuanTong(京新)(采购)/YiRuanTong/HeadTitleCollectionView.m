//
//  HeadTitleCollectionView.m
//  YiRuanTong
//
//  Created by apple on 17/7/21.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "HeadTitleCollectionView.h"

@implementation HeadTitleCollectionView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    UIImageView *headview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, self.bounds.size.height-1.5)];
    headview.image = [UIImage imageNamed:@"mainHead.PNG"];
    [self addSubview:headview];
    
    _titleHead = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, KscreenWidth-30, 25)];
    _titleHead.textColor = UIColorFromRGB(0x000000);
    _titleHead.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleHead];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
