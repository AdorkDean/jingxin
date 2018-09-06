//
//  TuPianLieBiaoCell.h
//  yiruantong
//
//  Created by lx on 15/3/4.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhaoPianModel.h"
@interface TuPianLieBiaoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tuPianName;
@property (strong, nonatomic) IBOutlet UILabel *tuPianLieXing;
@property (strong, nonatomic) IBOutlet UIImageView *lieBiaoImageView;
@property(nonatomic,retain)ZhaoPianModel *model;

@end
