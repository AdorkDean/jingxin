//
//  THCpInfoCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/13.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "THCpInfoCell.h"

@implementation THCpInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CPINfoModel *)model{
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.proname];
    _proNoLabel.text = [NSString stringWithFormat:@"%@",model.prono];
    _ProSpecificationLabel.text = [NSString stringWithFormat:@"%@",model.specification];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,model.fileurl]] placeholderImage:[UIImage imageNamed:@"zwtp"]];
//    NSLog(@"%@--%@--%@",_model.pronam,_model.prono,_model.specification);
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    

}

@end
