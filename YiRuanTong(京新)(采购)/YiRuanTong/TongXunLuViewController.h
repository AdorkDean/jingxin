//
//  TongXunLuViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#define NotificationTabBarHidden @"tabbarhidden"

@interface TongXunLuViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
//是否需要搜索框
- (void)setSearchBar:(BOOL)searchBar;
//触发搜索
- (void)searchtext:(NSString *)text;

@property(nonatomic,retain)UITableView *tabView;
@end
