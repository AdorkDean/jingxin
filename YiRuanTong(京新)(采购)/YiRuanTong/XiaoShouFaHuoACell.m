//
//  XiaoShouFaHuoACell.m
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/5.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "XiaoShouFaHuoACell.h"

@implementation XiaoShouFaHuoACell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ChanPinFaHuoModel *)model{
    _model = model;
    self.prono.text = [NSString stringWithFormat:@"产品编号: %@",model.prono];
    self.proname.text = [NSString stringWithFormat:@"产品名称: %@",model.proname];
    self.proguige.text = [NSString stringWithFormat:@"产品规格: %@",model.specification];
    self.proPrice.text = [NSString stringWithFormat:@"产品单价: %@",model.singleprice];
    self.proDanwei.text = [NSString stringWithFormat:@"产品单位: %@",model.prounitname];
    self.totalCount.text = [NSString stringWithFormat:@"总数量: %@",model.totalcount];
    self.totalmoney.text = [NSString stringWithFormat:@"总价格: %@",model.totalmoney];
    self.xiaoshoupeople.text = [NSString stringWithFormat:@" %@",model.saler];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
