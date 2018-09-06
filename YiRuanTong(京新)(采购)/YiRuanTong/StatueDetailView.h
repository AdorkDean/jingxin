//
//  StatueDetailView.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/15.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface StatueDetailView : BaseViewController<UIWebViewDelegate>{
    
    UIWebView *_webView;
    MBProgressHUD *_hud;
}
@property(nonatomic,copy) NSString *urlString;

@end
