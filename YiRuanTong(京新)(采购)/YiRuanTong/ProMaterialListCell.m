//
//  ProMaterialListCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProMaterialListCell.h"

@implementation ProMaterialListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ProMaterialModel *)model{
    _model = model;
    self.bomnoLabel.text = [NSString stringWithFormat:@"BOM单号：%@",model.bomno];
    self.plannoLabel.text = [NSString stringWithFormat:@"生产计划单号：%@",model.planno];
    model.isstockout = [NSString stringWithFormat:@"%@",model.isstockout];
    NSString* str;
    if ([model.isstockout isEqualToString:@"0"]) {
        str = @"未生成";
    }else if ([model.isstockout isEqualToString:@"1"]){
         str = @"部分生产";
    }else if([model.isstockout isEqualToString:@"2"]){
         str = @"已生成";
    }
    self.statusLabel.text = [NSString stringWithFormat:@"生成状态：%@",str];
    self.pronameLabel.text = [NSString stringWithFormat:@"产品名称：%@",model.proname];
    self.creatorLabel.text = [NSString stringWithFormat:@"创建人：%@",model.creator];
    self.creattimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",model.createtime];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
