//
//  CustHistoryViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/7.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CustHistoryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,copy)NSString *custid;    // 客户ID
@property(nonatomic,copy)NSString *visitorid; // 拜访人ID

@end
