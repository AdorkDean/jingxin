//
//  FYBaoXiaoLiuLanCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "FYBaoXiaoLiuLanCell.h"

@implementation FYBaoXiaoLiuLanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    self.baoXiaoRen.text = [NSString stringWithFormat:@"报销人：%@",self.model.applyer];
    self.baoXiaoBianHao.text = [NSString stringWithFormat:@"报销编号：%@",self.model.reimno];
    self.baoXiaoPrice.text = [NSString stringWithFormat:@"报销金额：%@",self.model.applymoney];
    self.baoXiaoDate.text = [NSString stringWithFormat:@"报销时间：%@",self.model.applytime];
    self.baoXiaoType.text = [NSString stringWithFormat:@"报销分类：%@",self.model.tongji];
    NSString* isreimStr = [NSString stringWithFormat:@"%@",self.model.isreim];
    if ([isreimStr integerValue] == 0) {
        self.baoXiaoStatus.text =@"是否发放：否";
    }else if([isreimStr integerValue] == 1){
        self.baoXiaoStatus.text =@"是否发放：是";
    }
    self.shenPiLabel.text = [NSString stringWithFormat:@"%@",self.model.spnodename];
    
    
}

@end
