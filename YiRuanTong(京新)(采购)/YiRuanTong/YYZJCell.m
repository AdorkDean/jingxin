//
//  YYZJCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "YYZJCell.h"
#import "YYZJModel.h"
@implementation YYZJCell

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
    
    NSString *str = _model.installdate;
    if (_model.installdate.length > 0) {
        
        NSRange range = {0,10};
        str = [str substringWithRange:range];
    
    }
    _salername.text = [NSString stringWithFormat:@"%@ | %@",_model.salername,str];


}

@end
