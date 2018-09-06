//
//  KeHuFaHuoDuiBiCell.m
//  yiruantong
//
//  Created by lx on 15/3/11.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "KeHuFaHuoDuiBiCell.h"

@implementation KeHuFaHuoDuiBiCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
-(void)setModel:(FaHuoTongQiModel *)model{
    _model = model;
    self.keHuMingChen.text = [NSString stringWithFormat:@"客户名称：%@",model.custname];
    self.thisYear.text = [NSString stringWithFormat:@"今年:%@",model.createtime];
    self.thisyearCount.text = [NSString stringWithFormat:@"数量:%@",model.totalcount];
    self.lastYear.text = [NSString stringWithFormat:@"去年:%@",model.upcreatetime];
    self.lastYearCount.text = [NSString stringWithFormat:@"数量:%@",model.uptotalcount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
