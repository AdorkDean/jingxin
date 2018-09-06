//
//  QLKeHuDetailCell.m
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "QLKeHuDetailCell.h"

@implementation QLKeHuDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(FKDetailModel *)model{
    _model = model;
    _name.text = [NSString stringWithFormat:@"%@",_model.custname];
    
    NSString *time  = [NSString stringWithFormat:@"%@",_model.createtime];
    if (_model.createtime.length != 0) {
        NSRange  range = {0,10};
        time = [time substringWithRange:range];
    }
    _time.text = time;
    _danjuhao.text = [NSString stringWithFormat:@"单据号:%@",_model.danjuhao];
    _zhaiyao.text = [NSString stringWithFormat:@"摘要:%@",_model.zhaiyao];
    _qichu.text = [NSString stringWithFormat:@"期初:%@",_model.qichujine];
    _yingshou.text = [NSString stringWithFormat:@"本期应收:%@",_model.yingfashengjine];
    _shouhui.text = [NSString stringWithFormat:@"本期收回:%@",_model.fashengjine];
    _yue.text = [NSString stringWithFormat:@"余额:%@",_model.yue];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
