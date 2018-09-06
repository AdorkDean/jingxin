//
//  CustCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/8/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHnameModel.h"
@interface CustCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong)KHnameModel *model;
@end
