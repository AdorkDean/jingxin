//
//  OtherViewCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/14.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "OtherViewCell.h"

@implementation OtherViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _accountname.text =  _model.accountname;
    _reporttime.text = _model.reporttime;
    _content.text = _model.content;


}
@end
