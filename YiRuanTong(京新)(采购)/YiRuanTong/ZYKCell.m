//
//  ZYKCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZYKCell.h"

@implementation ZYKCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
-(void)setModel:(ZYKModel *)model{
    _model = model;
    self.name.text = [NSString stringWithFormat:@"%@",model.filename];
    if ([model.filename containsString:@".txt"]) {
        self.photo.image = [UIImage imageNamed:@"102623859013545656"];
    }else if ([model.filename containsString:@".doc"]) {
        self.photo.image = [UIImage imageNamed:@"623223172288640913"];
    }else if ([model.filename containsString:@".docx"]) {
        self.photo.image = [UIImage imageNamed:@"623223172288640913"];
    }else if ([model.filename containsString:@".pdf"]) {
        self.photo.image = [UIImage imageNamed:@"126923648179040817"];
    }else if ([model.filename containsString:@".xlsx"]){
        self.photo.image = [UIImage imageNamed:@"864454552934992854"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
