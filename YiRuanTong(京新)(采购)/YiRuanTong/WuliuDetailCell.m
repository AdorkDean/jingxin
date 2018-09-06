//
//  WuliuDetailCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/20.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "WuliuDetailCell.h"

@implementation WuliuDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dotView.layer.masksToBounds = YES;
    self.dotView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",_model.AcceptStation];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",_model.AcceptTime];
    
}


@end
