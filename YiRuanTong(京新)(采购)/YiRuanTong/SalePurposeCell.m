//
//  SalePurposeCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "SalePurposeCell.h"

@implementation SalePurposeCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}


- (void)initView{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KscreenWidth - 40, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, KscreenWidth - 40, 20)];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_detailLabel];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.text = [NSString stringWithFormat:@"业务员:%@",_model.accountname];
    _detailLabel.text = [NSString stringWithFormat:@"发货:%@|回款:%@|任务:%@",_model.totalsendgoodsmoney,_model.returnedmoney,_model.totalsales];
}


@end
