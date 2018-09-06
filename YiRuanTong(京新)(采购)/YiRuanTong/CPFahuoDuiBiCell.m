//
//  CPFahuoDuiBiCell.m
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CPFahuoDuiBiCell.h"

@implementation CPFahuoDuiBiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(FaHuoTongQiModel *)model{
    _model = model;
    self.proname.text = [NSString stringWithFormat:@"产品名称：%@",model.proname];
    self.prono.text = [NSString stringWithFormat:@"产品编号：%@",model.prono];
    self.thisYear.text = [NSString stringWithFormat:@"今年:%@",model.createtime];
    self.thisYearCount.text = [NSString stringWithFormat:@"数量:%@",model.totalcount];
    self.lastYear.text = [NSString stringWithFormat:@"去年:%@",model.upcreatetime];
    self.lastYearCount.text = [NSString stringWithFormat:@"数量:%@",model.uptotalcount];
    self.guige.text = [NSString stringWithFormat:@"产品规格:%@",model.specification];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
