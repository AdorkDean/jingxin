//
//  LXTongjiListCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/7.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "LXTongjiListCell.h"

@implementation LXTongjiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TongjiModel *)model{
    _model = model;

    self.name.text = [NSString stringWithFormat:@"姓名:%@",model.name];
    self.shibao.text = [NSString stringWithFormat:@"应报:%@",model.yingbao];
    self.shibao.text = [NSString stringWithFormat:@"实报:%@",model.shibao];
    self.quebao.text = [NSString stringWithFormat:@"缺报:%@",model.quebao];
    
}
- (IBAction)scanBtnClicked:(id)sender {
    if (_scanBtnBlock) {
        self.scanBtnBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
