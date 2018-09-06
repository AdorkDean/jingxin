//
//  QLXiaoShouHuiZongCell.m
//  YiRuanTong
//
//  Created by LONG on 2018/5/2.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "QLXiaoShouHuiZongCell.h"

@implementation QLXiaoShouHuiZongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(CustSaleModel *)model{
    _model = model;
    self.custname.text = [NSString stringWithFormat:@"%@",model.saler];
    self.proname.text = [NSString stringWithFormat:@"产品名称: %@",model.proname];
    self.sendtime.text = [NSString stringWithFormat:@"发货时间: %@",model.sendtime];
    self.guige.text = [NSString stringWithFormat:@"产品规格: %@",model.specification];
    self.singePrice.text = [NSString stringWithFormat:@"产品单价: %@",model.singleprice];
    self.danwei.text = [NSString stringWithFormat:@"产品单位: %@",model.prounitname];
    self.receiver.text = [NSString stringWithFormat:@"客户名称: %@",model.custname];
    self.totalcount.text = [NSString stringWithFormat:@"总数量: %@",model.allcount];
    self.totalPrice.text = [NSString stringWithFormat:@"总金额: %@",model.allmoney];
//    _depart.text = [NSString stringWithFormat:@"%@",model.departname];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
