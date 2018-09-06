//
//  StatueDetailView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/15.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "StatueDetailView.h"

@interface StatueDetailView ()

@end

@implementation StatueDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单详情";
    self.navigationItem.rightBarButtonItem = nil;
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight )];
    _webView.delegate = self;
//    _webView.hidden = YES;
    [_webView setScalesPageToFit:YES];
    NSString *str = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?postid=%@",_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];

}

//#pragma mark - UIWebViewDelegate
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    _webView.hidden = YES;
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.labelText = @"正在加载...";
////    _hud.dimBackground = YES;
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    _webView.hidden = NO;
//    _hud.labelText = @"加载完成";
//    [_hud hide:YES afterDelay:1];
//}


@end
