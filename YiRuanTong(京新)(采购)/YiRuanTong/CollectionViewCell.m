//
//  CollectionViewCell.m
//  YiRuanTong
//
//  Created by lx on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell ()

@end
@implementation CollectionViewCell
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
    self.backgroundColor = [UIColor whiteColor];
    _cv_icomImageView = [[UIImageView alloc] init];
    _cv_icomImageView.frame = CGRectMake(32*MYWIDTH, 20*MYWIDTH, self.bounds.size.width-64*MYWIDTH, self.bounds.size.width-64*MYWIDTH);
    _cv_icomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_cv_icomImageView];
    
    _bt_titleLabel = [[UILabel alloc] init];
    _bt_titleLabel.frame = CGRectMake(0, self.bounds.size.width-37*MYWIDTH, self.bounds.size.width, 30*MYWIDTH);
    _bt_titleLabel.font = [UIFont systemFontOfSize:13];
    _bt_titleLabel.numberOfLines = 2;
    _bt_titleLabel.textAlignment = NSTextAlignmentCenter;
    _bt_titleLabel.textColor = UIColorFromRGB(0x333333);
    [self addSubview:_bt_titleLabel];
    
   
}

@end
