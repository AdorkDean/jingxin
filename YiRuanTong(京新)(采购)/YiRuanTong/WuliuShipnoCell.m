//
//  WuliuShipnoCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/19.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "WuliuShipnoCell.h"

@implementation WuliuShipnoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.wuliuBtn.layer.masksToBounds = YES;
    self.wuliuBtn.layer.cornerRadius = 5;
    [self.wuliuBtn setBackgroundColor:COLOR(35, 150, 249, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)wuliuBtnClick:(id)sender {
    if (_transValue) {
        _transValue(YES);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.shipnoLabel.text = [NSString stringWithFormat:@"%@",_model.shipno];
    self.logistNoLabel.text = [NSString stringWithFormat:@"%@",_model.logisticsno];
    if (IsEmptyValue(_model.logisticsno)) {
        self.wuliuBtn.enabled = NO;
        [self.wuliuBtn setBackgroundColor:[UIColor grayColor]];
    }else{
        self.wuliuBtn.enabled = YES;
        [self.wuliuBtn setBackgroundColor:COLOR(35, 150, 249, 1)];
    }
//    if (self.wuliuBtn.enabled) {
//        if ([_model.select isEqualToString:@"1"]) {
//            self.backgroundColor = [UIColor grayColor];
//        }else{
//            self.backgroundColor = [UIColor clearColor];
//        }
//    }

}


@end
