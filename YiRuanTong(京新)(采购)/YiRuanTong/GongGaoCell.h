//
//  GongGaoCell.h
//  yiruantong
//
//  Created by lx on 15/1/16.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGliulanModel.h"
@interface GongGaoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *neiRongLable;
@property (strong, nonatomic) IBOutlet UILabel *renMingLable;
@property (strong, nonatomic) IBOutlet UILabel *shiFouYueDu;
@property (weak, nonatomic) IBOutlet UILabel *publishtime;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (nonatomic,retain) GGliulanModel *model;
@end
