//
//  LiuLanCell.h
//  yiruantong
//
//  Created by lx on 15/1/19.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHbaifangModel.h"
@interface LiuLanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *keHuName2;
@property (strong, nonatomic) IBOutlet UILabel *baiFangMuDi2;
@property (strong, nonatomic) IBOutlet UILabel *shenPiZhuangTai;
@property(nonatomic,retain) KHbaifangModel *model;
@property (strong, nonatomic) IBOutlet UILabel *call;

@end
