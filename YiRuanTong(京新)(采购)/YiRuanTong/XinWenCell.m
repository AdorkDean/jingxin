//
//  XinWenCell.m
//  yiruantong
//
//  Created by lx on 15/1/16.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "XinWenCell.h"

@implementation XinWenCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)layoutSubviews{

    [super layoutSubviews];
    NSString *imageStr = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,_model.folder,_model.autoname];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"zwtp.png"]];
    _biaoTiLable.text = [NSString stringWithFormat:@"%@",_model.title];
    _fabuName.text = [NSString stringWithFormat:@"%@",_model.publisher];
    _leiXingLable.text = [NSString stringWithFormat:@"%@",_model.publishtime];
    
    NSString * isvisited =[NSString stringWithFormat:@"%@",_model.isvisited];
    NSString * two = nil;
    switch ([isvisited intValue]) {
        case 1:
            two = @"已读";
            break;
            
        case 0:
            two = @"未读";
            break;
    }
    _shiFouYueDu.layer.masksToBounds = YES;
    _shiFouYueDu.layer.cornerRadius = 2.0;

    if ([two isEqualToString:@"未读"]) {
        _shiFouYueDu.text = two;
        _shiFouYueDu.backgroundColor = UIColorFromRGB(0xdc1616);
    }else{
        _shiFouYueDu.text = two;
        _shiFouYueDu.backgroundColor = UIColorFromRGB(0x3cbaff);
    }


}

@end
