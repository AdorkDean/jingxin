//
//  ZhaoPianLieBiaoVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ZhaoPianLieBiaoVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSString *tuPianID;
@property(nonatomic,copy)NSString *name;
@end
