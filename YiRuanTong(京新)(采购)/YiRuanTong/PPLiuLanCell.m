//
//  PPLiuLanCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "PPLiuLanCell.h"

@implementation PPLiuLanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.borderWidth = 0.5;
    self.btn.layer.borderColor = [UIColor blackColor].CGColor;
}
-(void)setModel:(ProPlanListModel *)model{
    _model = model;
    self.proNoLabel.text = [NSString stringWithFormat:@"生产计划单号:%@",model.planno];
    self.proNameLabel.text = [NSString stringWithFormat:@"计划制定人：%@",model.creator];
    self.proDateLabel.text = [NSString stringWithFormat:@"计划日期:%@",model.plantime];
    if ([model.iscreatedbom isEqualToString:@"0"]) {
        self.isbomLabel.text = @"BOM单状态：未生成";
    }else if ([model.iscreatedbom isEqualToString:@"1"]){
        self.isbomLabel.text = @"BOM单状态：已生成";
    }
    model.prostatus = [NSString stringWithFormat:@"%@",model.prostatus];
    if ([model.prostatus isEqualToString:@"0"]) {
        self.isexportLabel.text = @"生产出库状态：未生成";
    }else if ([model.prostatus isEqualToString:@"1"]){
        self.isexportLabel.text = @"生产出库状态：已生成";
    }
    self.btn.hidden = YES;
    self.spStatus.text = [NSString stringWithFormat:@"%@",model.spnodename];
    NSInteger sp = [model.spstatus integerValue];
    if (sp == 1) {
        self.btn.hidden = NO;
    }else{
        self.btn.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(id)sender {
    if (_transValue) {
        _transValue(YES,_model.Id);
    }
}
@end
