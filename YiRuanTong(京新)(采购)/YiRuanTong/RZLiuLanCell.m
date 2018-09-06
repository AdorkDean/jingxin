//
//  RZLiuLanCell.m
//  yiruantong
//
//  Created by lx on 15/1/23.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "RZLiuLanCell.h"

@implementation RZLiuLanCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
     _shangBaoRen.text = _model.creator;
    NSString * reportdate = _model.reportdate;
    if (_model.reportdate.length > 0) {
        reportdate = [_model.reportdate substringToIndex:10];
        
    }
    
    _shangBaoLeiXing.text = [NSString stringWithFormat:@"%@ | %@",_model.reporttypename,reportdate];
   
    
    
    NSString *isreply = [NSString stringWithFormat:@"%@",_model.isreply];
    NSInteger i = [isreply intValue];
    
    if (i == 0) {
        _zhuangTai.text = @"未批复";
        _zhuangTai.textColor = [UIColor redColor];
    } else if (i == 1) {
        _zhuangTai.text = @"已批复";
        _zhuangTai.textColor = [UIColor blackColor];
    }




}

@end
