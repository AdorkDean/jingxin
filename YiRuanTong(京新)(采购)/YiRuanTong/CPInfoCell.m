//
//  CPInfoCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/7/13.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "CPInfoCell.h"
#import "UIImageView+WebCache.h"
@implementation CPInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CPINfoModel *)model{
    _model = model;
    //赋值
    _nameLabel.text =  [NSString stringWithFormat:@"%@",_model.proname];
    //_nameLabel.textColor = [UIColor whiteColor];
    _specificationLabel.text =  [NSString stringWithFormat:@"%@",_model.specification];
    //_specificationLabel.textColor = [UIColor whiteColor];
    _proNoLabel.text =  [NSString stringWithFormat:@"%@",_model.prono];
    //_proNoLabel.textColor = [UIColor whiteColor];
    _imgView.frame = CGRectMake(10, 10, 40, 40);
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,_model.fileurl];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"zwtp"]];
}
- (void)layoutSubviews{

    [super layoutSubviews];
    

}

@end
