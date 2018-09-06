//
//  QLKeHuYSCell.m
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "QLKeHuYSCell.h"

@implementation QLKeHuYSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(KHfukuanModel *)model{
    _model = model;
        _custName.text = [NSString stringWithFormat:@"客户名称:%@(业务员:%@)",_model.custname,_model.saler];
        _xiaoji.text = [NSString stringWithFormat:@"%@",_model.zhaiyao];
        _qichu.text = [NSString stringWithFormat:@"期初:%@",_model.qichujine];
        _yingshou.text = [NSString stringWithFormat:@"本期应收%@",_model.yingfashengjine];
        _shouhui.text = [NSString stringWithFormat:@"本期收回:%@",_model.fashengjine];
        _yue.text = [NSString stringWithFormat:@"余额:%@",_model.yue];

}
@end
