//
//  PlanProDetailCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/12.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "PlanProDetailCell.h"

@implementation PlanProDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCount:(NSString *)count{
    _count = count;
}
- (IBAction)delBtnClieked:(id)sender {
    if (_delBtnBlock) {
        self.delBtnBlock();
    }
}

-(void)setModel:(PlanProDetailModel *)model{
    _model = model;
    [self.proname setTitle:[NSString stringWithFormat:@"%@",model.proname] forState:UIControlStateNormal];
    self.prospe.text = [NSString stringWithFormat:@"%@",model.specification];
    self.prodanwei.text = [NSString stringWithFormat:@"%@",model.prounitname];
    self.plancount.text = [NSString stringWithFormat:@"%@",model.maincount];
    self.isUrgent.text = @"是";
    self.note.text = [NSString stringWithFormat:@"%@",model.note];
}


@end
