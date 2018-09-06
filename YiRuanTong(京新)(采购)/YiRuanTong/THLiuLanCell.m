//
//  THLiuLanCell.m
//  yiruantong
//
//  Created by lx on 15/1/28.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "THLiuLanCell.h"
#import "UIViewExt.h"
@implementation THLiuLanCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}


- (void)layoutSubviews{

    [super layoutSubviews];
    //单号 客户 业务员 创建人 时间信息
    _tuiHuoDanHao.text = _model.returnno;
    _keHuName.text = [NSString stringWithFormat:@"%@ |业务员: %@",_model.custname,_model.saler];
    _creatorLabel.text = [NSString stringWithFormat:@"创建人: %@ ",_model.creator];

    _timeLabel.text = [NSString stringWithFormat:@"创建时间: %@",_model.applytime];
        //审批状态显示
    
    _shenPiZhuangTai.text = _model.spnodename;
    
    NSString *spStatus = [NSString stringWithFormat:@"%@",_model.spstatus];
    
    if ([spStatus isEqualToString:@"0"]||[spStatus isEqualToString:@"2"]) {
        _shenPiZhuangTai.textColor = [UIColor orangeColor];
    }else{
        _shenPiZhuangTai.textColor = UIColorFromRGB(0x3cbaff);
    }


}

@end
