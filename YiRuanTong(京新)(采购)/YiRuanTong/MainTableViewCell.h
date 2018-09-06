//
//  MainTableViewCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/7/29.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"
@interface MainTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,retain) MainModel *model;
@end
