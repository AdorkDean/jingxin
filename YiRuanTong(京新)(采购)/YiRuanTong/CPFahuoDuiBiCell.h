//
//  CPFahuoDuiBiCell.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaHuoTongQiModel.h"
@interface CPFahuoDuiBiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *proname;
@property (weak, nonatomic) IBOutlet UILabel *prono;
@property (weak, nonatomic) IBOutlet UILabel *thisYear;
@property (weak, nonatomic) IBOutlet UILabel *lastYear;
@property (weak, nonatomic) IBOutlet UILabel *thisYearCount;
@property (weak, nonatomic) IBOutlet UILabel *lastYearCount;
@property (weak, nonatomic) IBOutlet UILabel *guige;

@property(nonatomic,retain) FaHuoTongQiModel *model;
@end
