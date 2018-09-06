//
//  ZYKCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYKModel.h"
@interface ZYKCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *photo;

@property(nonatomic,retain)ZYKModel *model;
@end
