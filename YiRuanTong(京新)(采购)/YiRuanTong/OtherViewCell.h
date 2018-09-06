//
//  OtherViewCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/14.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QitaInfoModel.h"
@interface OtherViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *accountname;

@property (strong, nonatomic) IBOutlet UILabel *reporttime;
@property (strong, nonatomic) IBOutlet UILabel *content;

@property(nonatomic,retain)QitaInfoModel *model;



@end
