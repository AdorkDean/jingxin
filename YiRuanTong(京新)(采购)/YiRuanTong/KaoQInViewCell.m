//
//  KaoQInViewCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KaoQInViewCell.h"

@implementation KaoQInViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initView{
    _ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    [self.contentView addSubview:_ImageView];
    _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, KscreenWidth - 70, 40)];
    [self.contentView addSubview:_TitleLabel];
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    _ImageView.frame = CGRectMake(15, 10, 30, 30);
    _TitleLabel.frame = CGRectMake(60, 5, KscreenWidth - 70, 40);


}
@end
