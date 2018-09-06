//
//  DDShenPiCell.h
//  yiruantong
//
//  Created by lx on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDguanliModel.h"
@interface DDShenPiCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *shenPiID;

@property (strong, nonatomic) IBOutlet UILabel *shenPiName;

@property (strong, nonatomic) IBOutlet UILabel *shenPiState;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatus;

@property(nonatomic,retain)DDguanliModel *model;


@end
