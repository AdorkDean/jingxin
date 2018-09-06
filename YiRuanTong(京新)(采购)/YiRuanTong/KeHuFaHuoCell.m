//
//  KeHuFaHuoCell.m
//  yiruantong
//
//  Created by lx on 15/3/5.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "KeHuFaHuoCell.h"

@implementation KeHuFaHuoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _faHuoShuLiang.frame = CGRectMake(15, 34, KscreenWidth - 25, 21);
    _keHuMingCheng.text= [NSString stringWithFormat:@"客户名称:%@",_model.custname];
    _faHuoShuLiang.text =   [NSString stringWithFormat:@"回款金额:%@ ｜ 所属区域:%@",_model.zongreturnmoney,_model.departname];
  



}
@end
