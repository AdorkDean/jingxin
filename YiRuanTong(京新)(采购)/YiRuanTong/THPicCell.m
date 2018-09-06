//
//  THPicCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/11/3.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "THPicCell.h"
#import "UIImageView+WebCache.h"
@implementation THPicCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initView{
    
    _showImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 65, 65)];
    _showImage.contentMode = UIViewContentModeScaleAspectFit; 
    [self.contentView addSubview:_showImage];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, KscreenWidth - 100, 80)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,@"uploadfile",_model.fileid];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_showImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zwtp.png"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",_model.filename];
    
    
}


@end
