//
//  KaoQinHistoryCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/14.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "KaoQinHistoryCell.h"

@implementation KaoQinHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(KaoQinHistoryModel *)model{
    _model = model;
    
    self.name.text = [NSString stringWithFormat:@"员工姓名:%@",model.empname];
    self.late.text = [NSString stringWithFormat:@"迟到次数:%@",model.latecount];
    self.zaotui.text = [NSString stringWithFormat:@"早退次数:%@",model.leaveearlycount];
    self.kaoqin.text = [NSString stringWithFormat:@"考勤次数:%@",model.absentcount];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
