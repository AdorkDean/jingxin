//
//  CgInformationLLCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CgLLManageModel.h"
@interface CgInformationLLCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cgNumber;
@property (strong, nonatomic) IBOutlet UILabel *cgArea;
@property (strong, nonatomic) IBOutlet UILabel *cgPeople;
@property (strong, nonatomic) IBOutlet UILabel *cgBumen;
@property (strong, nonatomic) IBOutlet UILabel *PayWay;
@property (strong, nonatomic) IBOutlet UILabel *cgDate;
@property (strong, nonatomic) IBOutlet UILabel *spStatus;
@property(nonatomic,retain)CgLLManageModel *model;
@end
