//
//  CustCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "CustCell.h"

@implementation CustCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(KHnameModel *)model
{
    _model = model;

    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];

}
@end
