//
//  ChanPinXiaoShouCell.h
//  yiruantong
//
//  Created by lx on 15/3/9.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPinXiaoShouModel.h"
@interface ChanPinXiaoShouCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chanPinMingCheng;
@property (strong, nonatomic) IBOutlet UILabel *faHuoShuLiang;
@property (strong, nonatomic) IBOutlet UILabel *depart;
@property(nonatomic,retain) ChanPinXiaoShouModel *model;
@end
