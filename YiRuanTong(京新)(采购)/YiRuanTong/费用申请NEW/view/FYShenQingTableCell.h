//
//  FYShenQingTableCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYSQModel.h"

@interface FYShenQingTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *creatorLabel;
@property (strong, nonatomic) IBOutlet UILabel *noLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *aimLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *spstatusLabel;

@property (nonatomic,strong)FYSQModel* model;
@end
