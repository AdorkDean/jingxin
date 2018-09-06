//
//  ChanPinXiaoShouCell.m
//  yiruantong
//
//  Created by lx on 15/3/9.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "ChanPinXiaoShouCell.h"

@implementation ChanPinXiaoShouCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _chanPinMingCheng.frame = CGRectMake(15, 10, KscreenWidth - 100, 21);
//    _depart.frame = CGRectMake(KscreenWidth - 100, 10, 80, 21);
    _faHuoShuLiang.frame = CGRectMake(15, 34, 260, 21);
    _depart.frame = CGRectMake(KscreenWidth - 70, 10, 60, 21);
    _chanPinMingCheng.text = [NSString stringWithFormat:@"产品名称：%@",_model.proname];
    _faHuoShuLiang.text = [NSString stringWithFormat:@"发货数量：%@ |发货金额：%@",_model.totalcount,_model.totalmoney];
    _depart.text = _model.departname;
   
    



}
@end
