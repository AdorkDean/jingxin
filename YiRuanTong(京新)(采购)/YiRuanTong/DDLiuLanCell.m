//
//  DDLiuLanCell.m
//  yiruantong
//
//  Created by lx on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "DDLiuLanCell.h"

@implementation DDLiuLanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wuliuBtn.layer.masksToBounds = YES;
    self.wuliuBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _dingDanBianHao.text = _model.orderno;
    //是否审批完成，spstatus，-1审批拒绝，0，开始审批，1审批通过，2是转特批
    NSString *spStatus = [NSString stringWithFormat:@"%@",_model.spstatus];
    if ([spStatus isEqualToString:@"0"]||[spStatus isEqualToString:@"2"]) {
        _shenPiZhuangTai.textColor = [UIColor orangeColor];
    }else{
        _shenPiZhuangTai.textColor = UIColorFromRGB(0x3cbaff);
        }
    _dingDanKeHu.text = [NSString stringWithFormat:@"%@ ｜ 业务员: %@",_model.custname,_model.saler];
    _shenPiZhuangTai.text= _model.spnodename;
    _creatorLabel.text = [NSString stringWithFormat:@"创建人: %@",_model.creator];

    _TimeLabel.text = [NSString stringWithFormat:@"创建时间: %@",_model.createtime];
    
    NSString *orderStatus = [NSString stringWithFormat:@"%@",_model.orderstatus];
    if ([orderStatus isEqualToString:@"0"]) {
        _orderStatus.text = @"发货状态: 未发货";
    }else if ([orderStatus isEqualToString:@"1"]){
        _orderStatus.text = @"发货状态: 部分发货";
    }else if ([orderStatus isEqualToString:@"2"]){
        _orderStatus.text = @"发货状态: 发货完成";
    }else if ([orderStatus isEqualToString:@"3"]){
        _orderStatus.text = @"发货状态: 预订单";
    }else{
        _orderStatus.text = @"发货状态: 未知";
    }
    
    
}


- (IBAction)wuliuBtnClick:(id)sender {
    
    if (_transVaule) {
        _transVaule(YES);
    }
    
    
}
@end
