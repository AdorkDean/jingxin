//
//  YeWuYuanFenXiCell.m
//  yiruantong
//
//  Created by lx on 15/3/11.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "YeWuYuanFenXiCell.h"

@implementation YeWuYuanFenXiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];
    _yeWuYuan.frame = CGRectMake(15, 10, KscreenWidth - 30, 20);
    _yingHuiJinE.frame = CGRectMake(15, 34, KscreenWidth - 30, 20);
    _yeWuYuan.text = [NSString stringWithFormat:@"业务员:%@",_model.saler];
    _yingHuiJinE.text =  [NSString stringWithFormat:@"今年发货：%@ |去年发货：%@",_model.sendmoney,_model.returnmoney];
    


}
@end
