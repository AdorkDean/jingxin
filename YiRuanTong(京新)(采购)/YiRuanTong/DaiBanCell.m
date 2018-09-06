//
//  DaiBanCell.m
//  yiruantong
//
//  Created by lx on 15/3/18.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "DaiBanCell.h"

@implementation DaiBanCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{

    [super layoutSubviews];
    _countLabel.frame = CGRectMake(KscreenWidth - 50, 20, 20, 20);
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;


}



@end
