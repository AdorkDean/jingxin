//
//  TuiHuoDetailProCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/31.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuiHuoDetailModel.h"

@interface TuiHuoDetailProCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *proheaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *proNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *specLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitpriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;


@property (nonatomic,strong)TuiHuoDetailModel* model;
@property (nonatomic,strong)NSString* count;

@end
