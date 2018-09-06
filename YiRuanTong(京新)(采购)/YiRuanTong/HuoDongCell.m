//
//  HuoDongCell.m
//  yiruantong
//
//  Created by lx on 15/3/3.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "HuoDongCell.h"

@implementation HuoDongCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(ZhaoPianModel *)model{
    _model = model;
    self.keHuShiJian.text = model.createtime;
    NSString *imagestr = [NSString stringWithFormat:@"%@%@%@",PHOTO_ADDRESS,@"/uploadPicture/",model.autofilename];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"zp3.png"]];
    self.type.text = [NSString stringWithFormat:@"类型:%@",model.pictype];
    self.keHuMingCheng.text = [NSString stringWithFormat:@"%@(%@)",model.custname,model.uploader];
    if ([model.filenote isEqualToString:@""]) {
        self.filenote.text = [NSString stringWithFormat:@"照片描述:%@",@"无"];
    }else{
        
        self.filenote.text = [NSString stringWithFormat:@"照片描述:%@",model.filenote];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
