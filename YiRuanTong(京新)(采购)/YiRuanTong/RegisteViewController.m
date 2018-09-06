//
//  RegisteViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/6.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "RegisteViewController.h"
#import "UIViewExt.h"
#import "AFNetworking.h"
#import "JKCountDownButton.h"
#import "DataPost.h"

@interface RegisteViewController ()<UITextFieldDelegate>{

    UITextField *_telFiled;
    UITextField *_testFiled;
    UITextField *_custName;
    UITextField *_account;
    UITextField *_passWord;
    UITextField *_surePassWord;
    JKCountDownButton *_getCodeButton;
    UIButton *_nextButton;
}

@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    titleLabel.text = @"注册";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    
}
- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//页面
- (void)initView{
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight)];
    test.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:test];
    // 输入手机号
    _telFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, KscreenWidth - 40, 40)];
    _telFiled.delegate = self;
    _telFiled.placeholder = @"请输入手机号码";
    _telFiled.borderStyle = UITextBorderStyleRoundedRect;
    _telFiled.keyboardType = UIKeyboardTypeNumberPad;
    _telFiled.font = [UIFont systemFontOfSize:14];
    [test addSubview:_telFiled];
//    //名
//    _custName = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, 40)];
//    _custName.delegate = self;
//    _custName.placeholder = @"请输入姓名";
//    _custName.borderStyle = UITextBorderStyleRoundedRect;
//    _custName.font = [UIFont systemFontOfSize:14];
//    [test addSubview:_custName];
//    //用户名
//    _account = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, KscreenWidth - 40, 40)];
//    _account.delegate = self;
//    _account.placeholder = @"请输入用户名";
//    _account.borderStyle = UITextBorderStyleRoundedRect;
//    _account.font = [UIFont systemFontOfSize:14];
//    [test addSubview:_account];
//    // 密码
   
//
//    // 确认密码
//    _surePassWord = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, KscreenWidth - 40, 40)];
//    _surePassWord.delegate = self;
//    _surePassWord.placeholder = @"确认密码";
//    _surePassWord.secureTextEntry = YES;
//    _surePassWord.borderStyle = UITextBorderStyleRoundedRect;
//    _surePassWord.font = [UIFont systemFontOfSize:14];
//    [test addSubview:_surePassWord];
    
      ///密码
    _passWord = [[UITextField alloc] initWithFrame:CGRectMake(20, _telFiled.bottom + 20, KscreenWidth - 40, 40)];
    _passWord.delegate = self;
    _passWord.placeholder = @"请输入密码";
    _passWord.secureTextEntry  =  YES;
    _passWord.borderStyle = UITextBorderStyleRoundedRect;
    _passWord.font = [UIFont systemFontOfSize:14];
    [test addSubview:_passWord];
    
    //请输入手机验证码
    _testFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, _passWord.bottom + 20, KscreenWidth - 150 , 40)];
    _testFiled.delegate = self;
    _testFiled.placeholder = @"请输入手机验证码";
    _testFiled.borderStyle = UITextBorderStyleRoundedRect;
    _testFiled.font = [UIFont systemFontOfSize:14];
    [test addSubview:_testFiled];
    //
    _getCodeButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _getCodeButton.frame = CGRectMake(_testFiled.right + 10, _passWord.bottom + 20 , 100 , 40);
    _getCodeButton.backgroundColor = COLOR(37, 163, 251, 1);
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //_getCodeButton.tintColor = [UIColor blackColor];
    [_getCodeButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_getCodeButton.layer setBorderWidth:0.1];
    [_getCodeButton setTitle:@"获取" forState:UIControlStateNormal];
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
    [_getCodeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [test addSubview:_getCodeButton];
  
    
   

   
    //
    _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nextButton.frame = CGRectMake(20, _testFiled.bottom + 20, KscreenWidth - 40, 40);
    [_nextButton setTintColor:[UIColor whiteColor]];
    _nextButton.backgroundColor = COLOR(37, 163, 251, 1);
    [_nextButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_nextButton.layer setBorderWidth:0.1];
    [_nextButton setTitle:@"注册" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [test addSubview:_nextButton];
    
    UILabel *link = [[UILabel alloc] initWithFrame:CGRectMake(0, KscreenHeight - 40 - 64, KscreenWidth, 40)];
    link.font =[UIFont systemFontOfSize:14];
    link.textAlignment = NSTextAlignmentCenter;
    link.text = @"联系方式：0531-88807916";
    [test addSubview:link];
    
}

- (void)getCode{
    /*
     Action	getSMSCode
     Data:{"phone":"手机号"}
     "mobile":"true"
     返回值{
     "status": true,
     "msg": "手机号验证的消息"
     }
     http://192.168.1.203:8080/lxnewss/withUnLog/location?action=getSMSCode
     
     data	{"phone":"18663759204","type":"register"}
     
     
     */
    NSString *telNo = _telFiled.text;
   
    
    
    if (telNo.length == 0) {
        
        [self showAlert:@"请输入手机号"];
        
    }else{
        
 //       NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"location?action=getSMSCode"];
        
//        NSString *str =[NSString stringWithFormat:@"action=getSMSCode&data={\"phone\":\"%@\",\"type\":\"register\"}",telNo];
//        NSURL *url =[NSURL URLWithString:urlStr];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//        [request setHTTPMethod:@"POST"];
//        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data];
//        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *dataStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
//        NSLog(@"获取验证码返回数据%@",dataStr);
        
        
 //       NSDictionary *parameters = @{@"action":@"getSMSCode",@"data":@{@"phone":telNo,@"type":@"register"}};
//        NSLog(@"上传数组%@",parameters);
//        [DataPost requestAFWithUrl:urlStr params:parameters finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//            NSString *dataStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//            NSLog(@"返回数据%@",dataStr);
//        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//            NSLog(@"请求失败");
//            NSInteger errorCode = error.code;
//            [self showAlert:[NSString stringWithFormat:@"连接服务器失败，错误码%zi",errorCode]];
//        }];
//        
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        
//        [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSDictionary *dic = (NSDictionary *)responseObject;
//            NSLog(@"注册返回:%@",dic);
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSInteger *errorCode = error.code;
//            NSLog(@"错误%@",error);
//            NSLog(@"错误码%zi",errorCode);
//            NSLog(@"请求失败");
//        }];
//

        NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location?action=getSMSCode"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *parameters = @{@"action":@"getSMSCode",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"type\":\"register\"}",telNo]};
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
- (void)next{
    /*
     Action
     Data
     {
     "phone": "手机号",
     "name": "姓名",
     "password": "密码",
     " smscode ": "验证码",
     "mobile": true
     }
     Params
     返回值	{
     "status": true/false,
     "msg": "注册的消息"
     }
     
     */
    
    NSString *telNo = _telFiled.text;
//    NSString *account = _account.text;
//    NSString *name = _custName.text;
    NSString *password = _passWord.text;
//    NSString *surePass = _surePassWord.text;
    NSString *code = _testFiled.text;
    
    if (telNo.length == 0 || code.length == 0 || password.length == 0 ) {
        [self showAlert:@"请输入完整信息"];
    }else{
    
                /*
         http://192.168.1.203:8080/lxnewss/withUnLog/location?action=userRegisterBySmS
         
         data	{"table":"khzh","account":"短信手机注册测试","cellNo":"18663759204","smscode":"7584","password":"123"}
         
         */
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location?action=userRegister2BySmS"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *parameters = @{@"action":@"userRegister2BySmS",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"cellNo\":\"%@\",\"account\":\"\",\"password\":\"%@\",\"smscode\":\"%@\",\"table\":\"khzh\",\"name\":\"\"}",telNo,password,code]};
            NSLog(@"上传数组%@",parameters);
            [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject != nil) {
                    
                    NSString *dataStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSRange  range = {1, dataStr.length - 2};
                    NSString *reallystr = [dataStr substringWithRange:range];
//                    reallystr = [self replaceOhter:reallystr];
//                    NSData *data1 = [reallystr dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
//                    NSString *message = dic[@"msg"];
                    if ([reallystr isEqualToString:@"true"]) {
                         [self showAlert:@"注册成功"];
                           //注册成功返回
                        //[self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self showAlert:@"注册失败"];
                    }
                   
                    NSLog(@"返回数据1%@",dataStr);
                    NSLog(@"返回数据2%@",reallystr);
                    //NSLog(@"返回数据%@",dic);
                }
               

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSInteger errorCode = error.code;
                NSLog(@"错误码%zi",errorCode);
                NSLog(@"错误%@",error);
                NSLog(@"请求失败");
                
            }];
            
            
            
        
        
        
    
    }
    
}
//跨域
- (NSString *)replaceOhter:(NSString *)dataStr
{
    NSString * returnString = [dataStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return returnString;
}
@end
