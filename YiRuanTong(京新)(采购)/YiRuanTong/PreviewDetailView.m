//
//  PreviewDetailView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/15.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "PreviewDetailView.h"

@interface PreviewDetailView ()

@end

@implementation PreviewDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览详情";
    self.navigationItem.rightBarButtonItem = nil;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    _webView.delegate = self;
    _webView.hidden = YES;
    [_webView setScalesPageToFit:YES];
    NSString *str = [NSString stringWithFormat:@"%@/Upload?action=download&folder=uploadresfile&fileId=55a1ed2edeb349a5bc10d7df4b561d0a.png&fileName=未标题-2.png",DATA_ADDRESS];
    
    NSLog(@"字符串%@",str);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webView.hidden = YES;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载...";
    _hud.dimBackground = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.hidden = NO;
    _hud.labelText = @"加载完成";
    [_hud hide:YES afterDelay:1];
}

@end
