//
//  ChanPinFaHuoCell.h
//  yiruantong
//
//  Created by lx on 15/3/6.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPinFaHuoModel.h"
@interface ChanPinFaHuoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chanPinMingCheng;
@property (strong, nonatomic) IBOutlet UILabel *faHuoShuLiang;

@property(nonatomic,retain)ChanPinFaHuoModel *model;
@end
