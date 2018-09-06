//
//  QLKeHuDetailCell.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKDetailModel.h"
@interface QLKeHuDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *danjuhao;
@property (weak, nonatomic) IBOutlet UILabel *zhaiyao;
@property (weak, nonatomic) IBOutlet UILabel *qichu;
@property (weak, nonatomic) IBOutlet UILabel *yingshou;
@property (weak, nonatomic) IBOutlet UILabel *yue;
@property (weak, nonatomic) IBOutlet UILabel *shouhui;
@property (nonatomic,strong)FKDetailModel * model;
@end
