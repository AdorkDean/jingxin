//
//  QLChanPinXiaoShouCell.m
//  YiRuanTong
//
//  Created by LONG on 2018/4/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "QLChanPinXiaoShouCell.h"

@implementation QLChanPinXiaoShouCell

-(void)setModel:(ChanPinXiaoShouModel *)model{
    _model = model;
    self.chanPinMingCheng.text = [NSString stringWithFormat:@"产品名称: %@",model.proname];
    self.leixing.text = [NSString stringWithFormat:@"产品类型: %@",model.protypename];
    self.guige.text = [NSString stringWithFormat:@"产品规格: %@",model.specification];
    self.danjia.text = [NSString stringWithFormat:@"产品单价: %@",model.saleprice];
    self.danwei.text = [NSString stringWithFormat:@"产品单位: %@",model.prounitname];
    self.kehuType.text = [NSString stringWithFormat:@"产品编号: %@",model.prono];
    self.faHuoShuLiang.text = [NSString stringWithFormat:@"总数量: %@",model.totalcount];
    self.zongjiage.text = [NSString stringWithFormat:@"总价格: %@",model.totalmoney];
    _depart.text = [NSString stringWithFormat:@"%@",model.departname];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
