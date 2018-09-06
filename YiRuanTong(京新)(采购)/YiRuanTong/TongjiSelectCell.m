//
//  TongjiSelectCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/7.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "TongjiSelectCell.h"

@implementation TongjiSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TongjiSelectModel *)model{
    _model = model;
    self.date.text = [NSString stringWithFormat:@"%@",model.date];
    self.week.text = [NSString stringWithFormat:@"%@",model.weekday];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
