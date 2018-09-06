//
//  KaoQinHistoryCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/14.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KaoQinHistoryModel.h"
@interface KaoQinHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *late;
@property (strong, nonatomic) IBOutlet UILabel *zaotui;
@property (strong, nonatomic) IBOutlet UILabel *kaoqin;
@property (nonatomic,strong)KaoQinHistoryModel *model;
@end
