//
//  FYBaoXiaoDetailCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "FYBaoXiaoDetailCell.h"

@implementation FYBaoXiaoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FYBXDetailModel *)model{
    _model = model;
    [self.typeBtn setTitle:[NSString stringWithFormat:@"%@",_model.costtype] forState:UIControlStateNormal];
    self.countField.text = [NSString stringWithFormat:@"%@",_model.singelnum];
    self.priceField.text = [NSString stringWithFormat:@"%@",_model.applymon];
    self.noteField.text = [NSString stringWithFormat:@"%@",_model.costcause];
}

- (IBAction)delBtnClick:(id)sender {
    if (_delBtnBlock) {
        _delBtnBlock();
    }
}

- (IBAction)typeBtnClick:(id)sender {
    if (_typeBtnBlock) {
        _typeBtnBlock();
    }
}
@end
