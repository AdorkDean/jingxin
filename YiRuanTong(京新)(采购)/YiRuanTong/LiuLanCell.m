//
//  LiuLanCell.m
//  yiruantong
//
//  Created by lx on 15/1/19.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "LiuLanCell.h"

@implementation LiuLanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _keHuName2.text = _model.custname;
    NSString *visitor  = _model.visitor;
    if (visitor.length == 0) {
        visitor = @"业务员未知";
    }
    NSString *date = _model.visitedate;
    if (date.length == 0) {
        date = @"时间未知";
    }
    
    _baiFangMuDi2.text = [NSString stringWithFormat:@"%@ | %@",visitor,date];
    
    NSString *spstatus =[NSString stringWithFormat:@"%@",_model.spstatus];
    if ([spstatus isEqualToString:@"0"]) {
        _shenPiZhuangTai.text = @"未批复";
    } else if ([spstatus isEqualToString:@"1"])
    {
        _shenPiZhuangTai.text = @"已批复";
        _shenPiZhuangTai.textColor = [UIColor blackColor];
    }



}
@end
