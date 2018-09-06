//
//  THShenPiCell.m
//  yiruantong
//
//  Created by lx on 15/1/28.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "THShenPiCell.h"

@implementation THShenPiCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)layoutSubviews{

    [super layoutSubviews];
    //单号 客户 业务员 创建人 时间信息
    _sptuiHuoDanHao.text = _model.returnno;
    _spkeHuName.text = [NSString stringWithFormat:@"%@ |业务员: %@",_model.custname,_model.saler];
    _creatorLabel.text = [NSString stringWithFormat:@"创建人: %@",_model.creator];

    _timeLabel.text = [NSString stringWithFormat:@"创建时间: %@",_model.applytime];
    
     //审批状态显示
    int m = [_model.spstatus intValue];
    if (m == 1) {
        _spshenPiZhuangTai .text = _model.spnodename;
    }else {
        _spshenPiZhuangTai.text = _model.spnodename;
        _spshenPiZhuangTai.textColor = [UIColor orangeColor];
    }

}


@end
