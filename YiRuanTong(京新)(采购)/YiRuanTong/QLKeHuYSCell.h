//
//  QLKeHuYSCell.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHfukuanModel.h"
@interface QLKeHuYSCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *custName;
@property (weak, nonatomic) IBOutlet UILabel *xiaoji;
@property (weak, nonatomic) IBOutlet UILabel *qichu;
@property (weak, nonatomic) IBOutlet UILabel *yue;
@property (weak, nonatomic) IBOutlet UILabel *yingshou;
@property (weak, nonatomic) IBOutlet UILabel *shouhui;
@property (nonatomic,strong)KHfukuanModel * model;
@end
