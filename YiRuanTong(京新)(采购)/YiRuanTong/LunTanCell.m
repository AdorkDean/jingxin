//
//  LunTanCell.m
//  yiruantong
//
//  Created by lx on 15/1/29.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "LunTanCell.h"

@implementation LunTanCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    _biaoTi.text = _model.epidemictitle;
    _faBuRen.text = [NSString stringWithFormat:@"%@ | %@", _model.publisher,_model.publishtime];
    

}

@end
