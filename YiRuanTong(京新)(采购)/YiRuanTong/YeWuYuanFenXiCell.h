//
//  YeWuYuanFenXiCell.h
//  yiruantong
//
//  Created by lx on 15/3/11.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YeWuYuanHuiKuanModel.h"
@interface YeWuYuanFenXiCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *yeWuYuan;
@property (strong, nonatomic) IBOutlet UILabel *yingHuiJinE;
@property (strong, nonatomic) IBOutlet UILabel *shiJiHuiKuan;
@property(nonatomic,retain)YeWuYuanHuiKuanModel *model;
@end
