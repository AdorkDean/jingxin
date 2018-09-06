//
//  MainTableViewCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/7/29.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "MainTableViewCell.h"
#import "UIViewExt.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _imgView.frame = CGRectMake(15, 10, 45, 45);
    _nameLabel.frame = CGRectMake(_imgView.right + 15, 15, KscreenWidth - 75, 35);
    _imgView.image = [UIImage imageNamed:_model.photoName];
    _nameLabel.text = _model.name;
    

}
@end
