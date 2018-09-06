//
//  SHHFCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHHFMOdel;
@interface SHHFCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *custname;
@property (strong, nonatomic) IBOutlet UILabel *repairname;

@property (strong, nonatomic) IBOutlet UILabel *repairdate;
@property(nonatomic,retain)SHHFMOdel *model;


@end
