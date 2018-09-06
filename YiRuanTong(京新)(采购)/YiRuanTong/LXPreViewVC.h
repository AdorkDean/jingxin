//
//  LXPreViewVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/15.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "ZYKDetailModel.h"
@interface LXPreViewVC : BaseViewController
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}
@property(nonatomic,retain)ZYKDetailModel *model;
@property(nonatomic,copy) NSString *fileId;
@end
