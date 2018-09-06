//
//  DDLiuLanDetailproCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/28.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "DDLiuLanDetailproCell.h"

@implementation DDLiuLanDetailproCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.proDiscountedMoneyLabel.textColor = UIColorFromRGB(0x3cbaff);
    self.proHeaderLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    self.proHeaderLabel.text = [NSString stringWithFormat:@"【产品名称(%@)】",self.count];
    [self.proNameBtn setTitle:[NSString stringWithFormat:@"%@",self.model.proname] forState:UIControlStateNormal];
    self.proSpecLabel.text = [NSString stringWithFormat:@"%@",self.model.specification];
    self.proCountField.text = [NSString stringWithFormat:@"%@%@",self.model.maincount,self.model.prounitname];
    self.model.singleprice = [NSString stringWithFormat:@"%@",self.model.singleprice];
    self.prounitPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",[self.model.singleprice doubleValue]];
    self.model.saledprice = [NSString stringWithFormat:@"%@",self.model.saledprice];
    self.proDiscountedPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",[self.model.saledprice doubleValue]];
    self.model.saledmoney = [NSString stringWithFormat:@"%@",self.model.saledmoney];
    self.proDiscountedMoneyLabel.text = [NSString stringWithFormat:@"￥%.1f",[self.model.saledmoney doubleValue]];
    
}

- (IBAction)proNameBtnClick:(id)sender {
}
- (IBAction)proUnitBtnClick:(id)sender {
}
- (IBAction)proPaytypeBtnClick:(id)sender {
}
@end
