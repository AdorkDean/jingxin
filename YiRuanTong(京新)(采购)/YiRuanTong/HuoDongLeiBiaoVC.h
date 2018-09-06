//
//  HuoDongLeiBiaoVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface HuoDongLeiBiaoVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIButton *returnButton;

@property(strong,nonatomic)NSString *zhaoPianID;



@end
