//
//  ChanPinFaHuoCell.m
//  yiruantong
//
//  Created by lx on 15/3/6.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "ChanPinFaHuoCell.h"

@implementation ChanPinFaHuoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _chanPinMingCheng.text = [NSString stringWithFormat:@"产品名称:%@",_model.proname];
    _faHuoShuLiang.text = [NSString stringWithFormat:@"销售数量：%@ |销售金额： %@",_model.totalcount,_model.totalmoney ];
   



}

@end
