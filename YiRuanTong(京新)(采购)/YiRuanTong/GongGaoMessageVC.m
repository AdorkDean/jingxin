//
//  GongGaoMessageVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "GongGaoMessageVC.h"
#import "GongGaoViewController.h"
#import "DataPost.h"

@interface GongGaoMessageVC ()

@end

@implementation GongGaoMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告详情";
    //删除添加按钮
    self.navigationItem.rightBarButtonItem = nil;
    //初始化页面
    [self initView];
    //上传已读信息
    [self upDate];
    
    

}

- (void)initView{
    
    self.gongGaoTitle.text = _model.title;
    self.gongGaoName.text = _model.publisher;
    self.gongGaoTime.text = _model.publishtime;
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobilenews/new_advisory_mobile.html#&p2&id=%@",PHOTO_ADDRESS,_model.Id];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.gongGaoNeiRong loadRequest:request];

    self.gongGaoNeiRong.backgroundColor = [UIColor whiteColor];
    //新闻内容的Label的自适应大小
    [self.gongGaoNeiRong sizeToFit];
    [self.view addSubview:_gongGaoNeiRong];
}

- (void)upDate{
    //http://182.92.96.58:8005/yrt/servlet/news// 新闻已读
    //    data	{"id":"276","isvisited":"0"}
    //    mobile	true
    //    action	visitNewsDetail
    //    table	xwgg
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/news"];
    NSDictionary *params = @{@"action":@"visitNewsDetail",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"isvisited\":\"0\"}",_model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回信息=%@",str1);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeRead" object:self];
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
