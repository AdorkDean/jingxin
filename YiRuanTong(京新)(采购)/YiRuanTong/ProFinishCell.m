//
//  ProFinishCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProFinishCell.h"

@implementation ProFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCount:(NSString *)count{
    _count = count;
}
- (IBAction)delBtnClicked:(id)sender {
    if (_delBtnBlock) {
        self.delBtnBlock();
    }
}

-(void)setModel:(ProFinishModel *)model{
    _model = model;
    [self.wuliaoname setTitle:[NSString stringWithFormat:@"%@",model.mtname] forState:UIControlStateNormal];
    self.wuliaoSpe.text = [NSString stringWithFormat:@"%@",model.mtsize];
    self.wuliaodanwei.text = [NSString stringWithFormat:@"%@",model.mtunitname];
    self.standcount.text = [NSString stringWithFormat:@"%@",model.mtnormcount];
    self.standcount.text = [NSString stringWithFormat:@"%@",model.mtnormcount];
    [self.cangku setTitle:[NSString stringWithFormat:@"%@",model.storagename] forState:UIControlStateNormal];
    [self.pici setTitle:[NSString stringWithFormat:@"%@",model.mtbatch] forState:UIControlStateNormal];
    self.stockCount.text = [NSString stringWithFormat:@"%@",model.mtstockcount];
    self.needCount.text = [NSString stringWithFormat:@"%@",model.mtneedcount];
//    self.keyongCount.text = [NSString stringWithFormat:@"%@",model.mtfreecount];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
