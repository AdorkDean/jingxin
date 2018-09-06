//
//  PPLiuLanDetailproCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "PPLiuLanDetailproCell.h"

@implementation PPLiuLanDetailproCell

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
    self.proCountField.text = [NSString stringWithFormat:@"%@",self.model.mainunitname];
    self.prounitPriceLabel.text = [NSString stringWithFormat:@"%@",self.model.needcount];
    self.proDiscountedPriceLabel.text = [NSString stringWithFormat:@"%@",self.model.freecount];
    self.proDiscountedMoneyLabel.text = [NSString stringWithFormat:@"%@",self.model.plancount];
    NSString* isurgent = [NSString stringWithFormat:@"%@",self.model.isurgent];
    if ([isurgent isEqualToString:@"1"]) {
        self.isSpeed.text = @"是";
    }else if ([isurgent isEqualToString:@"0"]){
        self.isSpeed.text = @"否";
    }else{
        self.isSpeed.text = isurgent;
    }
    self.noteLabel.text = [NSString stringWithFormat:@"%@",self.model.pronote];
}

- (IBAction)proNameBtnClick:(id)sender {
}
- (IBAction)proUnitBtnClick:(id)sender {
}
- (IBAction)proPaytypeBtnClick:(id)sender {
}

@end
