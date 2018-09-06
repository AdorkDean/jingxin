//
//  DDShenPiCell.m
//  yiruantong
//
//  Created by lx on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "DDShenPiCell.h"

@implementation DDShenPiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _shenPiID.text = _model.orderno;
    _shenPiName.text = [NSString stringWithFormat:@"%@ |业务员: %@",_model.custname,_model.saler];
    //是否审批完成
    NSString *spStatus = [NSString stringWithFormat:@"%@",_model.spstatus];
    if ([spStatus isEqualToString:@"0"]||[spStatus isEqualToString:@"2"]) {
        _shenPiState.textColor = [UIColor orangeColor];
    }else{
        _shenPiState.textColor = UIColorFromRGB(0x3cbaff);
    }
    _shenPiState.text = _model.spnodename;
    _creatorLabel.text = [NSString stringWithFormat:@"创建人: %@",_model.creator];

    _TimeLabel.text = [NSString stringWithFormat:@"创建时间: %@",_model.createtime];
    
    NSString *orderStatus = [NSString stringWithFormat:@"%@",_model.orderstatus];
    if ([orderStatus isEqualToString:@"0"]) {
        _orderStatus.text = @"发货状态: 未发货";
    }else if ([orderStatus isEqualToString:@"1"]){
        _orderStatus.text = @"发货状态: 部分发货";
    }else if ([orderStatus isEqualToString:@"2"]){
        _orderStatus.text = @"发货状态: 发货完成";
    }

    

}



@end
