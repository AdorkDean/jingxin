//
//  PlayerViewController.m
//  TestYKMediaPlayer
//
//  Created by weixinghua on 13-6-25.
//  Copyright (c) 2013年 Youku Inc. All rights reserved.
//

#import "PlayerViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface NSURLRequest (InvalidSSLCertificate)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@interface PlayerViewController ()<NSURLSessionDelegate>

@property (strong, nonatomic) JSContext *context;

@property (nonatomic, strong) NSURLRequest *request;
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;

@property (nonatomic,strong)NSString * imgUrl;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:@"http://118.190.47.231/jx/app/videoShowMobile/videoShowMobile.html"];
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    [self.webView loadRequest:self.request];
    
}
//加载URL
- (void)loadHTML:(NSString *)htmlString
{
    
}
#pragma mark - UIWebViewDelegate
//开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* scheme = [[request URL] scheme];
    
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [awebView stopLoading];
            return NO;
        }
    }
    return YES;
}
-(void)addJScustomAction{
    _context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    [self addAlertSureWithContext:_context];
    
    //通过OC调用此方法
    NSString * method = @"loadVideoParams";
    
    JSValue * function = [self.context objectForKeyedSubscript:method];
    
    //这里面的a,b,c就是OC调用JS的时候给JS传的参数
    [function callWithArguments:@[self.sptitleid]];
    
}
-(void)addAlertSureWithContext:(JSContext *)context{
    context[@""] = ^(){
        
    };
}

//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self addJScustomAction];
    
    self.webView.backgroundColor = [UIColor blackColor];
    
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    
    
    
}

#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        self.isAuthed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络不给力");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:self.request];
    [connection cancel];
}



//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
@end
