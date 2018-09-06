//
//  SPLLCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "SPLLCell.h"

@implementation SPLLCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{

    [super layoutSubviews];

    
    _shangBaoRen.text = _model.creator;
    _shangBaoRen.font = [UIFont systemFontOfSize:17];
    NSString *reportdate  = _model.createtime;
    
    if (reportdate.length != 0) {
         reportdate= [_model.createtime substringToIndex:10];
    }
   
    
    _shangBaoLeiXing.text = [NSString stringWithFormat:@"%@ | %@",_model.sptypename,reportdate];
    
    NSString *isreply = [NSString stringWithFormat:@"%@",_model.spstatus];
    NSInteger i = [isreply intValue];
    _zhuangTai.adjustsFontSizeToFitWidth = YES;
    if (i == 0) {
        _zhuangTai.text = @"未审批";
        _zhuangTai.textColor = [UIColor greenColor];
    } else if(i == 1) {
        _zhuangTai.text = @"审批通过";
        _zhuangTai.textColor = [UIColor cyanColor];
    } else if (i == -1){
        _zhuangTai.text = @"审批拒绝";
        _zhuangTai.textColor = [UIColor redColor];
    }else{
        _zhuangTai.text = @"审批中";
        _zhuangTai.textColor = [UIColor orangeColor];
    }


}

@end
