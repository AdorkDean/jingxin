//
//  GongGaoCell.m
//  yiruantong
//
//  Created by lx on 15/1/16.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.

#import "GongGaoCell.h"

@implementation GongGaoCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *imageStr = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,_model.folder,_model.autoname];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"zwtp.png"]];
    _neiRongLable.text = [NSString stringWithFormat:@"%@",_model.title];
    _renMingLable.text = [NSString stringWithFormat:@"%@",_model.publisher];
    _publishtime.text = [NSString stringWithFormat:@"%@",_model.publishtime];
    NSString * isvisited =[NSString stringWithFormat:@"%@",_model.isvisited];
    _shiFouYueDu.layer.masksToBounds = YES;
    _shiFouYueDu.layer.cornerRadius = 2.0;

    NSString *two = nil;
    switch ([isvisited intValue]) {
        case 0:
            two = @"未读";
            break;
            
        case 1:
            two = @"已读";
            break;
    }
    if ([two isEqualToString:@"未读"]) {
        _shiFouYueDu.text=two;
        _shiFouYueDu.backgroundColor = UIColorFromRGB(0xdc1616);
    } else {
        _shiFouYueDu.text=two;
        _shiFouYueDu.backgroundColor = UIColorFromRGB(0x3cbaff);
    }




}
@end
