//
//  FYShenQingTableCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "FYShenQingTableCell.h"

@implementation FYShenQingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    self.noLabel.text = [NSString stringWithFormat:@"申请编号：%@",self.model.costno];
    self.creatorLabel.text = [NSString stringWithFormat:@"申请人：%@",self.model.applyer];
    self.typeLabel.text = [NSString stringWithFormat:@"申请类型：%@",self.model.costtype];
    self.aimLabel.text = [NSString stringWithFormat:@"申请目的：%@",self.model.applyaim];
    self.timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",self.model.applytime];
    self.priceLabel.text = [NSString stringWithFormat:@"申请金额：%@",self.model.applymoney];
    self.spstatusLabel.text = [NSString stringWithFormat:@"%@",self.model.spnodename];
    
}

@end
