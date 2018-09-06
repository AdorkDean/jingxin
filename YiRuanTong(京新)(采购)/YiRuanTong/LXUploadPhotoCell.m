//
//  LXUploadPhotoCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/6.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "LXUploadPhotoCell.h"

@implementation LXUploadPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectPhotoAction:(id)sender {
    if (_selectPhotoBlock) {
        self.selectPhotoBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
