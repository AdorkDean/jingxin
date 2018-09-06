//
//  ZYKDetailCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYKDetailModel.h"
@interface ZYKDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *uptime;
@property(nonatomic,retain)ZYKDetailModel *model;
@end
