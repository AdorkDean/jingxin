//
//  ForgetViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ForgetViewController.h"
#import "UIViewExt.h"
#import "ReSetViewController.h"
#import "JKCountDownButton.h"
#import "AFNetworking.h"
@interface ForgetViewController ()<UITextFieldDelegate>{

    UITextField *_telFiled;
    UITextField *_testFiled;
    JKCountDownButton *_getCodeButton;
    UIButton *_nextButton;
    
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    [self initNav];
    [self initView];
    
        
}
//页面
- (void)initNav{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 64)];
    [navView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navBack.png"]]];
    [self.view addSubview:navView];
    //
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(10, 22, 40, 40);
    backbutton.showsTouchWhenHighlighted = YES;
    backbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [backbutton setBackgroundImage:[UIImage imageNamed:@"menu_return.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backbutton];
    //
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2 - 60, 22, 120, 40)];
    titleLabel.text = @"找回密码";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];

}
- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)initView{
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight)];
    test.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:test];
    _telFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, KscreenWidth - 40, 40)];
    _telFiled.delegate = self;
    _telFiled.borderStyle = UITextBorderStyleRoundedRect;
    _telFiled.placeholder = @"请输入手机号码";
    _telFiled.keyboardType = UIKeyboardTypeNumberPad;
    _telFiled.font = [UIFont systemFontOfSize:14];
    [test addSubview:_telFiled];
    
    _testFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, KscreenWidth - 150 , 40)];
    _testFiled.delegate = self;
    _testFiled.borderStyle = UITextBorderStyleRoundedRect;
    _testFiled.placeholder = @"请输入手机验证码";
    _testFiled.font = [UIFont systemFontOfSize:14];
    [test addSubview:_testFiled];
     //
    _getCodeButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _getCodeButton.frame = CGRectMake(_testFiled.right + 10, 80, 100, 40);
    _getCodeButton.backgroundColor = COLOR(37, 163, 251, 1);
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //[_getCodeButton setTintColor:[UIColor blackColor]];
    [_getCodeButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_getCodeButton.layer setBorderWidth:0.1];
    [_getCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    
    
    
    
    [_getCodeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [test addSubview:_getCodeButton];
    //
    _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nextButton.frame = CGRectMake(20, 140, KscreenWidth - 40, 40);
    _nextButton.backgroundColor = COLOR(37, 163, 251, 1);
    [_nextButton setTintColor:[UIColor whiteColor]];
    [_nextButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_nextButton.layer setBorderWidth:0.1];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [test addSubview:_nextButton];
    
    
}
// 获取手机验证码
- (void)getCode{
    
    /*
     Action	getSMSCode
     Data={"phone": "手机号","type":"changepwd"}
     Params
     返回值	{
     "status": true,
     "msg": "手机号验证的消息"
     }
     
     */
    NSString *telNo = _telFiled.text;
    if (telNo.length == 0) {
        [self showAlert:@"请输入手机号"];
    }else{
        [_getCodeButton addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
            sender.enabled = NO;
            
            [sender startWithSecond:60];
            
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
                
            }];
            
        }];

        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location?action=getSMSCode"];
        NSDictionary *parameters = @{@"action":@"getSMSCode",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"type\":\"changepwd\"}",telNo]};
        NSLog(@"上传数组%@",parameters);

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject != nil) {
                
                NSString *dataStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSRange  range = {1, dataStr.length - 2};
                NSString *reallystr = [dataStr substringWithRange:range];
                reallystr = [self replaceOhter:reallystr];
                NSData *data1 = [reallystr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
                NSString *message = dic[@"msg"];
                [self showAlert:message];
                NSLog(@"返回数据1%@",dataStr);
                NSLog(@"返回数据2%@",reallystr);
                NSLog(@"返回数据%@",dic);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger errorCode = error.code;
            NSLog(@"错误码%zi",errorCode);
            NSLog(@"错误%@",error);
            NSLog(@"请求失败");
            
        }];

    
    }

}
//下一步
- (void)next{
    /*
     Action	checkSMSCode
     Data
     {
     "phone": "手机号",
     "smscode": "验证码",
     "mobile": true
     }
     Params
     返回值	{
     "status": true,
     "msg": "手机号验证的消息"
     }
     */
    
    NSString *telNo = _telFiled.text;
    NSString *code = _testFiled.text;
    
    if(telNo.length == 0){
        
        [self showAlert:@"请输入手机号"];
        
    }else{
        
        if (code.length == 0) {
            
            [self showAlert:@"请输入验证码"];
            
        }else{
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location?action=checkSMSCode"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSDictionary *parameters = @{@"action":@"checkSMSCode",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"smscode\":\"%@\"}",telNo,code]};
            NSLog(@"上传数组%@",parameters);
            [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject != nil) {
                    
                    NSString *dataStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSRange  range = {1, dataStr.length - 2};
                    NSString *reallystr = [dataStr substringWithRange:range];
                    reallystr = [self replaceOhter:reallystr];
                    NSData *data1 = [reallystr dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
                    NSString *message = dic[@"msg"];
                    NSString *status = dic[@"status"];
                    int i  =  [status intValue];
                    if ( i == 1) {
                        [self showAlert:message];
                        ReSetViewController *resetVc = [[ReSetViewController alloc] init];
                        [self presentViewController:resetVc animated:YES completion:nil];
                        
                    }else if (i == 0){
                        [self showAlert:message];
                    
                    }
                    
                    NSLog(@"返回数据1%@",dataStr);
                    NSLog(@"返回数据2%@",reallystr);
                    NSLog(@"返回数据%@",dic);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSInteger errorCode = error.code;
                NSLog(@"错误码%zi",errorCode);
                NSLog(@"错误%@",error);
                NSLog(@"请求失败");
                
            }];

    
           
            
            
        }
    }
}

//跨域
- (NSString *)replaceOhter:(NSString *)dataStr
{
    NSString * returnString = [dataStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return returnString;
}
@end
