//
//  KeHuFaHuoDuiBiCell.h
//  yiruantong
//
//  Created by lx on 15/3/11.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaHuoTongQiModel.h"
@interface KeHuFaHuoDuiBiCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *keHuMingChen;
@property (weak, nonatomic) IBOutlet UILabel *thisYear;
@property (weak, nonatomic) IBOutlet UILabel *lastYear;
@property (weak, nonatomic) IBOutlet UILabel *thisyearCount;
@property (weak, nonatomic) IBOutlet UILabel *lastYearCount;


@property(nonatomic,retain) FaHuoTongQiModel *model;
@end
