//
//  PlayerViewController.h
//  TestYKMediaPlayer
//
//  Created by weixinghua on 13-6-25.
//  Copyright (c) 2013年 Youku Inc. All rights reserved.
//
#import "BaseViewController.h"
#import <WebKit/WebKit.h>
@interface PlayerViewController : BaseViewController<UIWebViewDelegate, NSURLConnectionDelegate>

//定义一个属性，方便外接调用
@property (nonatomic, strong) UIWebView *webView;

//声明一个方法，外接调用时，只需要传递一个URL即可
- (void)loadHTML:(NSString *)htmlString;
@property (nonatomic, strong) NSString * sptitleid;


@end
