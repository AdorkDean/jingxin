//
//  THShenPiCell.h
//  yiruantong
//
//  Created by lx on 15/1/28.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THmanagerModel.h"
@interface THShenPiCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *sptuiHuoDanHao;
@property (strong, nonatomic) IBOutlet UILabel *spkeHuName;

@property (strong, nonatomic) IBOutlet UILabel *spshenPiZhuangTai;
//@property (strong, nonatomic) IBOutlet UILabel *sptuiHuoZhuangTai;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;



@property(nonatomic,retain) THmanagerModel *model;
@end
