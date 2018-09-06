//
//  KeHuHuiKuanCell.m
//  yiruantong
//
//  Created by lx on 15/3/9.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "KeHuHuiKuanCell.h"

@implementation KeHuHuiKuanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _keHuMingCheng.text = [NSString stringWithFormat:@"客户名称：%@",_model.custname];
    _jinNianTongQi.text = [NSString stringWithFormat:@"今年同期：%@ | 去年同期：%@",_model.returnmoney,_model.lastyear];
   




}

@end
