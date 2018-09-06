//
//  SPCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiDingYiSPModel.h"
@interface SPCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *shangBaoLeiXing;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *zhuangTai;
@property(nonatomic,retain) ZiDingYiSPModel *model;
@end
