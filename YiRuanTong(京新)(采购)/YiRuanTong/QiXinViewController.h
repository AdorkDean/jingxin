//
//  QiXinViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "RCChatListViewController.h"
#import "TongxunluModel.h"
#import "RCIM.h"
#define NotificationTabBarHidden @"tabbarhidden"

@interface QiXinViewController : RCChatListViewController<RCIMUserInfoFetcherDelegagte>

@end
