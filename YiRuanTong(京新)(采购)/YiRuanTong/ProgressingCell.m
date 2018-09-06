//
//  ProgressingCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProgressingCell.h"

@implementation ProgressingCell

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
- (IBAction)cangkuAction:(id)sender {
    if (_cangkuBtnBlock) {
        self.cangkuBtnBlock();
    }
}
- (IBAction)piciAction:(id)sender {
    if (_piciBtnBlock) {
        self.piciBtnBlock();
    }
}

-(void)setModel:(ProFinishModel *)model{
    _model = model;
    [self.wuliaoname setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
    self.wuliaoSpe.text = [NSString stringWithFormat:@"%@",model.mtsize];
    self.wuliaodanwei.text = [NSString stringWithFormat:@"%@",model.mtunitname];
    self.standcount.text = [NSString stringWithFormat:@"%@",model.mtcount];
//    self.keyongCount.text = [NSString stringWithFormat:@"%@",model.mtcount];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
//    NSInteger mtcount = [[NSString stringWithFormat:@"%@",_model.mtcount] integerValue];
//    NSInteger plancount = [[NSString stringWithFormat:@"%@",_model.plancount] integerValue];
//    NSInteger count = mtcount*plancount;
//    self.needCount.text = [NSString stringWithFormat:@"%ld",(long)count];
    
}

@end
