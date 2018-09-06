//
//  CustomerServicetbCell.m
//  YiRuanTong
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CustomerServicetbCell.h"

@implementation CustomerServicetbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CustomerServiceModel *)model{
    NSString* isdeal;
    if ([model.isdeal integerValue] == 0) {
        isdeal = @"否";
    }else if ([model.isdeal integerValue] == 1){
        isdeal = @"是";
    }
    self.titleLabel.text = [NSString stringWithFormat:@"是否处理：%@",isdeal];
    self.questionLabel.text = [NSString stringWithFormat:@"问题描述：%@",model.question];
    self.creatorLabel.text = [NSString stringWithFormat:@"提问人：%@",model.creator];
    self.creatTimeLabel.text = [NSString stringWithFormat:@"提问时间：%@",model.submittime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
