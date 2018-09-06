//
//  LoginViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "ZhuYeViewController.h"
#import "UIViewExt.h"
#import "GuideViewController.h"
#define KShowGuide    @"showGuide"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ForgetViewController.h"
#import "RegisteViewController.h"
#import "JPUSHService.h"
@interface LoginViewController ()

{
    Reachability *_hostReach;
    NSString *_account;
    NSString *_password;
    NSString *_stringreturn;
    MBProgressHUD *_HUD;
}

@end

@implementation LoginViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.isRemember = NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"存储的%@",[userDefault objectForKey:@"isRemember"]);
    NSInteger j  = [[userDefault objectForKey:@"isRemember"]integerValue];
    if (j == 1) {
        _isRemember = YES;
    }else{
        _isRemember = NO;
    }
    //登录界面
    [self initAllComponents];
}

//登录界面
- (void)initAllComponents
{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    backImage.image = [UIImage imageNamed:@"login_aty_bg"];
    [self.view addSubview:backImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2 - 50, 70, 100, 40)];
    nameLabel.text = @"金易销";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:30];
    [self.view addSubview:nameLabel];
    UILabel *nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2 - 100, 120, 200, 20)];
    nameLabel1.text = @"移 动 营 销 专 家";
    nameLabel1.textColor = [UIColor whiteColor];
    nameLabel1.font = [UIFont systemFontOfSize:14];
    nameLabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel1];
        
    //用户名
    UIImageView * userName=[[UIImageView alloc]initWithFrame:CGRectMake(KscreenWidth/2 - 140, 160, 280, 40)];
    userName.image=[UIImage imageNamed:@"用户名"];
    [self.view addSubview:userName];
    //密码
    UIImageView * password=[[UIImageView alloc]initWithFrame:CGRectMake(KscreenWidth/2 - 140, 220, 280, 40)];
    password.image=[UIImage imageNamed:@"密码"];
    [self.view addSubview:password];
    //从本地读取用户名和密码
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //用户名输入框
    self.userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(KscreenWidth/2  - 95, 165, 200, 30)];
    self.userNameTextField.borderStyle = UITextBorderStyleNone;
//    self.userNameTextField.secureTextEntry = NO;
    self.userNameTextField.delegate = self;
    self.userNameTextField.placeholder = @"请输入用户名称";
    self.userNameTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _account = [userDefault objectForKey:@"account"];
    if (_account.length != 0) {
       self.userNameTextField.text = _account;
    }
    [self.view addSubview:self.userNameTextField];
    //密码输入框
    self.passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(KscreenWidth/2 - 95, 225, 200, 30)];
    self.passwordTextField.placeholder = @"请输入用户密码";
//    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    _password = [userDefault objectForKey:@"password"];
    if (_password.length != 0) {
       self.passwordTextField.text = _password;
    }
    [self.view addSubview:self.passwordTextField];
    //密码记忆选择框
    self.rememberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_passwordTextField.left - 20 , 275, 15, 15)];
    if (_account.length != 0 && _password.length != 0) {
        self.rememberImageView.image = [UIImage imageNamed:@"选中后"];
    } else {
        self.rememberImageView.image = [UIImage imageNamed:@""];
    }
    self.rememberImageView.layer.cornerRadius = 2.0f;
    self.rememberImageView.layer.masksToBounds = YES;
    self.rememberImageView.layer.borderColor= [UIColor whiteColor].CGColor;
    self.rememberImageView.layer.borderWidth = 1;
    [self.view addSubview: self.rememberImageView];
    self.rememberImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * rememberGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRememberImageView:)];
    rememberGesture.numberOfTapsRequired = 1;
    [self.rememberImageView addGestureRecognizer:rememberGesture];
    
    _rememberLabel=[[UILabel alloc]initWithFrame:CGRectMake(_passwordTextField.left,267, 150, 30)];
    _rememberLabel.text = @"记住密码";
    _rememberLabel.textColor = [UIColor whiteColor];
    _rememberLabel.backgroundColor = [UIColor clearColor];
    _rememberLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:_rememberLabel];
    
    //登录按钮
    self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(KscreenWidth/2 - 140, 310, 280, 40);
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"登陆"] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(dengLu:)forControlEvents:UIControlEventTouchUpInside];
//    // 忘记密码？   注册
//    UIButton  *forget = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    forget.frame = CGRectMake(_loginButton.left +10 , 370, 80, 40);
//    [forget setTintColor:[UIColor whiteColor]];
//    forget.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [forget setTitle:@"忘记密码？" forState:UIControlStateNormal];
//    [forget addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forget];
    
    
//    UIButton *registe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    registe.frame = CGRectMake(_loginButton.right - 90, 370, 80, 40);
//    [registe setTintColor:[UIColor whiteColor]];
//    registe.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [registe setTitle:@"注册" forState:UIControlStateNormal];
//    [registe addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:registe];

}
//忘记密码
- (void)forget{
    
    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
    [self presentViewController:forgetVC animated:YES completion:nil];

}
//注册
- (void)registe{

    RegisteViewController *registeVC = [[RegisteViewController alloc] init];
    [self presentViewController:registeVC animated:YES completion:nil];
}

- (void)dengLu:(UIButton *)button
{
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.labelText = @"正在登录中...";
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];

    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *imei = [userDefault objectForKey:@"imei"];
    if (imei.length == 0) {
        [userDefault setObject:uuid forKey:@"imei"];
    }
    //绑定字符串
    NSString *imeiStr = [userDefault objectForKey:@"imei"];
    //用户名
    NSString *name = self.userNameTextField.text;
    name = [self removeChar:name];
    NSString *passWord = self.passwordTextField.text;
    passWord = [self removeChar:passWord];
    
    
    NSString *stringForURL = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/login"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"imei":imeiStr,@"mobile":@"true",@"table":@"yhzh",@"password":passWord,@"account":name};
    NSLog(@"登录请求字典%@",parameters);
    [manager POST:stringForURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *returnDic = (NSDictionary *)responseObject;
        NSLog(@"登录返回:%@",returnDic);
        NSString *isPass = returnDic[@"isPass"];
                NSString *info = returnDic[@"info"];
                if([isPass isEqualToString:@"true"])
                {
                    NSDictionary * rootDic = returnDic;
                    NSLog(@"登录成功返回的信息:%@",rootDic);
                    NSDictionary * rootDic1 = rootDic[@"account"];
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:rootDic1[@"account"] forKey:@"account"];
                    [userDefault setObject:rootDic1[@"id"] forKey:@"id"];
//                    [userDefault setObject:rootDic1[@"roleid"] forKey:@"roleid"];
                    [userDefault setObject:rootDic1[@"locationhz"] forKey:@"locationhz"];
                    [userDefault setObject:rootDic1[@"imeicode"] forKey:@"imeicode"];
                    //[userDefault setObject:rootDic1[@"password"] forKey:@"password"];
                    [userDefault setObject:rootDic1[@"name"] forKey:@"name"];
                    [userDefault setObject:rootDic1[@"sex"] forKey:@"sex"];
                    [userDefault setObject:rootDic1[@"age"] forKey:@"age"];
                    [userDefault setObject:rootDic1[@"myposition"] forKey:@"myposition"];
                    
                    [userDefault setObject:rootDic1[@"cellno"] forKey:@"cellno"];
                    [userDefault setObject:rootDic1[@"telno"] forKey:@"telno"];
                    [userDefault setObject:rootDic1[@"email"] forKey:@"email"];
                    [userDefault setObject:rootDic1[@"note"] forKey:@"note"];
                    
                    [userDefault setObject:rootDic[@"logincode"] forKey:@"logincode"];
                    
                    [userDefault synchronize];
                    //设置id为登录别名
                    NSString * tag = [NSString stringWithFormat:@"%@",rootDic1[@"id"]];
                    [self joinJPush:tag];
                    
                    [_HUD hide:YES afterDelay:1];
                    [socketSingleton sharedSingleton];
                    [socketSingleton socketSingletonOpen];
                    self.view.window.rootViewController = [[MainViewController alloc] init];
        
        
                    } else{
                    [_HUD hide:YES];
                    UIAlertView * tan = [[UIAlertView alloc]initWithTitle:@"提示" message:info delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [tan show];
                }
        
        NSDictionary *fields = [operation.response allHeaderFields]; //afnetworking写法
        NSLog(@"fields = %@",[fields description]);
        //    NSDictionary *parameters = @{@"imei":imeiStr,@"mobile":@"true",@"table":@"yhzh",@"password":passWord,@"account":name};
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",stringForURL]];
        //获取cookie方法1
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
        
        //NSLog(@"cookies--------------%@",cookies);

        NSHTTPCookie *cookie;
        for (id obj in cookies) {
            if ([obj isKindOfClass:[NSHTTPCookie class]]){
                cookie=(NSHTTPCookie *)obj;
                //NSLog(@"000000000%@: %@", cookie.name, cookie.value);
                [userDefault setObject:cookie.value forKey:@"cookievalue"];
            }

        }

        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES afterDelay:1];
        [_HUD removeFromSuperview];
        NSInteger errorCode = error.code;
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败，错误码%zi",errorCode]];
        NSLog(@"错误%@",error);
        NSLog(@"登录失败");
    }];
    
}

- (NSString *)deleteAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    returnString = [returnString substringWithRange:NSMakeRange(1, returnString.length-2)];
    return returnString;
}

- (void)tapRememberImageView:(UITapGestureRecognizer *)gesture
{
    if(self.isRemember == NO)
    {
        self.rememberImageView.image = [UIImage imageNamed:@"选中后"];
        self.isRemember = YES;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.userNameTextField.text forKey:@"account"];
        [userDefault setObject:self.passwordTextField.text forKey:@"password"];
        [userDefault setObject:@"1" forKey:@"isRemember"];
        [userDefault synchronize];
        
    } else {
        
        self.rememberImageView.image=[UIImage imageNamed:@""];
        self.isRemember = NO;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"account"];
        [userDefault removeObjectForKey:@"password"];
        [userDefault setObject:@"0" forKey:@"isRemember"];
        [userDefault synchronize];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.userNameTextField) {
        textField.secureTextEntry = NO;
    }else{
        textField.secureTextEntry = YES;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

}

//UIAlertView协议方法
- (void)alertViewCancel:(UIAlertView *)alertView
{
    self.mainViewController = [[MainViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:self.mainViewController animated:YES completion:nil];
}

- (NSString *)removeChar:(NSString *) chString{
    NSString * returnString = [chString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return returnString;
}
#pragma mark 用户+标签、别名
-(void)joinJPush:(NSString *)tag{
    //    NSLog(@"%@",tag);
    
    [JPUSHService setAlias:tag completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:arc4random()%100];
    //        NSSet * set = [[NSSet alloc] initWithObjects:@"abc",@"one", nil];
    //
    //        [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
    //
    //        } seq:0];
}

@end
