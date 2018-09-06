//
//  JDXJCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDXJModel;
@interface JDXJCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *custname;
@property (strong, nonatomic) IBOutlet UILabel *routingname;
@property (strong, nonatomic) IBOutlet UILabel *routingdate;
@property(nonatomic,retain)JDXJModel *model;
@end
