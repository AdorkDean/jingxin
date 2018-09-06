//
//  ZiYuanKuViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ZiYuanKuViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}



@property(nonatomic,retain)UITableView *zyTableView;


@end
