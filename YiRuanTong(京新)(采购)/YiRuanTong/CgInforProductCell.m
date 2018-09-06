//
//  CgInforProductCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CgInforProductCell.h"

@implementation CgInforProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CgInformationDetailModel *)model{
    _model = model;
    [self.btn1 setTitle:[NSString stringWithFormat:@"%@",self.model.proname] forState:UIControlStateNormal];
    self.btn2.text = [NSString stringWithFormat:@"%@",self.model.prono];
    self.btn3.text = [NSString stringWithFormat:@"%@",self.model.specification];
    self.btn4.text = [NSString stringWithFormat:@"%@",self.model.mainunitname];
    self.btn5.text = [NSString stringWithFormat:@"%@",self.model.singleprice];
    self.btn6.text = [NSString stringWithFormat:@"%@",self.model.procount];
    self.btn7.text = [NSString stringWithFormat:@"%@",self.model.money];
}
-(void)setCount:(NSString *)count{
    _count = count;
    self.label1.text = [NSString stringWithFormat:@"【物料名称(%@)】",self.count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
