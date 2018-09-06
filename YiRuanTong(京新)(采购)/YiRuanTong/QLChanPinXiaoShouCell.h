//
//  QLChanPinXiaoShouCell.h
//  YiRuanTong
//
//  Created by LONG on 2018/4/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPinXiaoShouModel.h"

@interface QLChanPinXiaoShouCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chanPinMingCheng;
@property (strong, nonatomic) IBOutlet UILabel *faHuoShuLiang;
@property (strong, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *danwei;
@property (weak, nonatomic) IBOutlet UILabel *danjia;
@property (weak, nonatomic) IBOutlet UILabel *leixing;
@property (weak, nonatomic) IBOutlet UILabel *guige;
@property (weak, nonatomic) IBOutlet UILabel *zongjiage;
@property (weak, nonatomic) IBOutlet UILabel *kehuType;

@property(nonatomic,retain) ChanPinXiaoShouModel *model;
@end
