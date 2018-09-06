//
//  ReSetViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ReSetViewController.h"
#import "ForgetViewController.h"
#import "AFNetworking.h"
@interface ReSetViewController ()<UITextFieldDelegate>{
    
    UITextField *_newPassWord;
    UITextField *_surePassWord;
    UIButton *_sureButton;

}

@end

@implementation ReSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏
    [self initNav];
    //页面
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
    titleLabel.text = @"重置密码";
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
    // 输入手机号
    _newPassWord = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, KscreenWidth - 40, 40)];
    _newPassWord.delegate = self;
    _newPassWord.placeholder = @"请输入新密码";
    _newPassWord.secureTextEntry = YES;
    _newPassWord.borderStyle = UITextBorderStyleRoundedRect;
    _newPassWord.font = [UIFont systemFontOfSize:14];
    [test addSubview:_newPassWord];
    //用户名
    _surePassWord = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, 40)];
    _surePassWord.delegate = self;
    _surePassWord.placeholder = @"确认密码";
    _surePassWord.secureTextEntry = YES;
    _surePassWord.borderStyle = UITextBorderStyleRoundedRect;
    _surePassWord.font = [UIFont systemFontOfSize:14];
    [test addSubview:_surePassWord];
    _sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sureButton.frame = CGRectMake(20, 140, KscreenWidth - 40, 40);
    [_sureButton setTintColor:[UIColor whiteColor]];
    _sureButton.backgroundColor = COLOR(37, 163, 251, 1);
    [_sureButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_sureButton.layer setBorderWidth:0.1];
    [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [test addSubview:_sureButton];
    
    
}
- (void)sure{
    /*
     Action	changePwd
     Data
     {
     "password": "密码",
     "mobile": true
     }
     Params
     返回值	{
     "status": true,
     "msg": "重置密码的消息"
     }
     
*/

    NSString *password = _newPassWord.text;
    NSString *surePass = _surePassWord.text;
    if (password.length == 0) {
        [self showAlert:@"请输入新密码"];
    }else{
        if (![password isEqualToString:surePass]) {
            
            [self showAlert:@"您输入的密码不一致，请重新输入"];
            
        }else{
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location?action=changePwd"];
             NSDictionary *parameters = @{@"action":@"changePwd",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"password\":\"%@\"}",password]};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
           
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
                    int i = [status intValue];
                    if ( i == 1) {
                        [self showAlert:message];
                        
                    }else if ( i == 0){
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
            

            [self dismissViewControllerAnimated:YES completion:nil];
            

        
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
