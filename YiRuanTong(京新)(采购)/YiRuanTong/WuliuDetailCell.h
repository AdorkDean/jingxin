//
//  WuliuDetailCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/20.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuliuDetailModel.h"


@interface WuliuDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *dotView;
@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UIView *downView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic,strong)WuliuDetailTracesModel* model;
@end
