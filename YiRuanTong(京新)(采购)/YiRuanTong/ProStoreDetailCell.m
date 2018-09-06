//
//  ProStoreDetailCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProStoreDetailCell.h"

@implementation ProStoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ProStoreDetailModel *)model{
    _model = model;
    [self.btn1 setTitle:[NSString stringWithFormat:@"%@",self.model.mtname] forState:UIControlStateNormal];
    self.btn2.text = [NSString stringWithFormat:@"%@",self.model.mtsize];
    self.btn3.text = [NSString stringWithFormat:@"%@",self.model.mtunitname];
    self.btn4.text = [NSString stringWithFormat:@"%@",self.model.mtneedcount];
    self.btn5.text = [NSString stringWithFormat:@"%@",self.model.storagename];
    self.btn6.text = [NSString stringWithFormat:@"%@",self.model.mtfreecount];
    self.btn7.text = [NSString stringWithFormat:@"%@",self.model.mtstockcount];
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
