//
//  SHHFCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "SHHFCell.h"
#import "SHHFMOdel.h"
@implementation SHHFCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _custname.text = _model.custname;
    NSString *str = _model.repairdate;
    if (_model.repairdate.length > 0) {
        NSRange range = {0,10};
        str = [str substringWithRange:range];
    }

    _repairname.text = [NSString stringWithFormat:@"%@ | %@",_model.repairname,str];
}
@end
