//
//  VideoListCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/12.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "VideoListCell.h"

@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(VideoModel *)model{
    _model = model;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.bigthumbnail]] placeholderImage:[UIImage imageNamed:@""]];
    self.videoTitle.text = [NSString stringWithFormat:@"视频标题:%@",model.title];
    self.videoLengh.text = [NSString stringWithFormat:@"总时长:%@",model.duration];
    self.createTime.text = [NSString stringWithFormat:@"发布时间:%@",model.published];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
