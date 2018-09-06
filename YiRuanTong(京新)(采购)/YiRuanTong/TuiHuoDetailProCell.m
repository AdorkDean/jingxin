//
//  TuiHuoDetailProCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/31.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "TuiHuoDetailProCell.h"

@implementation TuiHuoDetailProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.proheaderLabel.text = [NSString stringWithFormat:@"产品名称(%@)",self.count];
    self.proNameLabel.text = [NSString stringWithFormat:@"%@",_model.proname];
    self.specLabel.text = [NSString stringWithFormat:@"%@",_model.specification];
    self.countLabel.text = [NSString stringWithFormat:@"%@%@",_model.procount,_model.prounitname];
    _model.singleprice = [NSString stringWithFormat:@"%@",_model.singleprice];
    self.unitpriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.singleprice doubleValue]];
    _model.goodsmoney = [NSString stringWithFormat:@"%@",_model.goodsmoney];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.goodsmoney doubleValue]];
}

@end
