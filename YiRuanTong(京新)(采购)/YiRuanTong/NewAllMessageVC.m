//
//  NewAllMessageVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "NewAllMessageVC.h"
#import "DataPost.h"
@interface NewAllMessageVC ()<UIWebViewDelegate>

@end

@implementation NewAllMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    //删除添加按钮
    self.navigationItem.rightBarButtonItem = nil;
    [self PageViewDidLoad1];
    [self upDate];
}

- (void)PageViewDidLoad1
{
    self.m_newTitle.text = _model.title;
    self.m_newName.text = _model.publisher;
    self.m_newTime.text = _model.publishtime;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobilenews/new_advisory_mobile.html#&p2&id=%@",PHOTO_ADDRESS,_model.Id];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.m_newNeiRong loadRequest:request];
    self.m_newNeiRong.delegate = self;
    //新闻内容的Label的自适应大小
    [self.m_newNeiRong sizeToFit];
    self.m_newNeiRong.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_m_newNeiRong];
    
    
}
//设置字体大小

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改百分比即可
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];
    
}
- (void)upDate{
    
    //servlet/news 新闻已读
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/news"];
    NSDictionary *params = @{@"action":@"visitNewsDetail",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"isvisited\":\"0\"}",_model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回信息=%@",str1);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsRead" object:self];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];

}

@end
