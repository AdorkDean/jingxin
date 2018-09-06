//
//  HuoDongCell.h
//  yiruantong
//
//  Created by lx on 15/3/3.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhaoPianModel.h"
@interface HuoDongCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *keHuMingCheng;
@property (strong, nonatomic) IBOutlet UILabel *keHuShiJian;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *filenote;

@property (nonatomic,strong)ZhaoPianModel * model;
@end
