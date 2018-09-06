//
//  KeHuHuiKuanCell.h
//  yiruantong
//
//  Created by lx on 15/3/9.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeHuHuiKuanModel.h"
@interface KeHuHuiKuanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *keHuMingCheng;
@property (strong, nonatomic) IBOutlet UILabel *jinNianTongQi;
@property (strong, nonatomic) IBOutlet UILabel *quNianTongQi;
@property(nonatomic,retain) KeHuHuiKuanModel *model;
@end
