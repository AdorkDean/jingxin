//
//  CgInformationLLCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CgInformationLLCell.h"

@implementation CgInformationLLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CgLLManageModel *)model{
    _model = model;
    self.cgNumber.text = [NSString stringWithFormat:@"采购单号:%@",model.purchaseno];
    self.cgArea.text = [NSString stringWithFormat:@"采购区域:%@",model.placename];
    self.cgPeople.text = [NSString stringWithFormat:@"采购员:%@",model.accountname];
    self.cgBumen.text = [NSString stringWithFormat:@"采购部门:%@",model.departname];
    self.PayWay.text = [NSString stringWithFormat:@"付款方式:%@",model.paytype];
    self.cgDate.text = [NSString stringWithFormat:@"采购日期:%@",model.createtime];
    self.spStatus.text = [NSString stringWithFormat:@"%@",model.spnodename];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
