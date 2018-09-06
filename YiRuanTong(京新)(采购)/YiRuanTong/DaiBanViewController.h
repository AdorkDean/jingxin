//
//  DaiBanViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#define NotificationTabBarHidden @"tabbarhidden"

@interface DaiBanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *tabView;

// 请求

@property(nonatomic,retain)NSArray *photoArray; //图片

@end
