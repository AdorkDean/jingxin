//
//  YYZJCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYZJModel;
@interface YYZJCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *custname;
@property (strong, nonatomic) IBOutlet UILabel *salername;

@property (strong, nonatomic) IBOutlet UILabel *installdate;

@property(nonatomic,retain)YYZJModel *model;
@end
