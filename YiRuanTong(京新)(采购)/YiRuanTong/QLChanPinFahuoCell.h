//
//  QLChanPinFahuoCell.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/4/27.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPinFaHuoModel.h"
@interface QLChanPinFahuoCell : UITableViewCell
@property(nonatomic,strong)ChanPinFaHuoModel * model;
@property (weak, nonatomic) IBOutlet UILabel *prono;
@property (weak, nonatomic) IBOutlet UILabel *proname;
@property (weak, nonatomic) IBOutlet UILabel *protype;
@property (weak, nonatomic) IBOutlet UILabel *proguige;
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UILabel *totalmoney;
@property (weak, nonatomic) IBOutlet UILabel *proPrice;
@property (weak, nonatomic) IBOutlet UILabel *proDanwei;

@end
