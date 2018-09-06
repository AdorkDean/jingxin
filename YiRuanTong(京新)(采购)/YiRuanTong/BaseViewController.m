//
//  BaseViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "ZhuYeViewController.h"
#import "DaiBanViewController.h"
#import "QiXinViewController.h"
#import "TongXunLuViewController.h"
#import "SheZhiViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "DataPost.h"

@interface BaseViewController (){

    Reachability *_hostReach;
}
@property(nonatomic,assign) BOOL keyBoardlsVisible;

@end

@implementation BaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 设置导航颜色  可用
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x3cbaff)];
    //创建一个高20的假状态栏
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    //设置颜色
    statusBarView.backgroundColor=UIColorFromRGB(0x3cbaff);
    // 添加到 navigationBar 上
    [self.navigationController.navigationBar addSubview:statusBarView];
    //设置返回按钮
    _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _BackButton.frame = CGRectMake(5, 5, 15, 40);
    _BackButton.showsTouchWhenHighlighted = YES;
    _BackButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_BackButton setBackgroundImage:[UIImage imageNamed:@"menu_return"] forState:UIControlStateNormal];
    [_BackButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _left = [[UIBarButtonItem alloc] initWithCustomView:_BackButton];
    self.navigationItem.leftBarButtonItem = _left;
    //添加按钮
    _AddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [_AddButton setImage:[UIImage imageNamed:@"menu_add"] forState:UIControlStateNormal];
    [_AddButton setTintColor:[UIColor whiteColor]];
    [_AddButton addTarget:self action:@selector(AddAction:) forControlEvents:UIControlEventTouchUpInside];
    _right = [[UIBarButtonItem alloc] initWithCustomView:_AddButton];
    self.navigationItem.rightBarButtonItem = _right;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:[self stringFromStatus:status]
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"确定", nil];
//        
//        [alert show];
        [self showAlert:[self stringFromStatus:status]];
    }

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

}
//  键盘弹出触发该方法
- (void)keyboardDidShow
{
    NSLog(@"键盘弹出");
    _keyBoardlsVisible =YES;
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide
{
    NSLog(@"键盘隐藏");
    _keyBoardlsVisible =NO;
}
- (BOOL)keyboardDid{
    return _keyBoardlsVisible;
}
- (NSString *)stringFromStatus:(NetworkStatus)status{
    
    NSString *string ;
    switch (status) {
        case NotReachable:
            string = @"未检测到网络,请检查网络！";
            break;
        case ReachableViaWiFi:
            string = @"WIFI";
            break;
        case ReachableViaWWAN:
            string = @"WWan";
            break;
        default:
            string = @"未知网络";
            break;
    }
    return string;
    
}


//#pragma mark - 返回按钮事件
- (void)backButtonAction:(UIButton*)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    //判断当前返回的页面是不是主页面 如果是 tabbar就显示  如果不是 就隐藏
    UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    if ([vc isKindOfClass:[ZhuYeViewController class]] || [vc isKindOfClass:[DaiBanViewController class]]||[vc isKindOfClass:[SheZhiViewController class]]||[vc isKindOfClass:[TongXunLuViewController class]]) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:NotificationTabBarHidden object:@"no" userInfo:nil];
    }
}
- (void)AddAction:(UIButton *)button{
    NSLog(@"添加点击事件");
}
//右边按钮
- (UIBarButtonItem *)showBarWithName:(NSString *)BarName
                      addBarWithName:(NSString *)name {
    if ([[self convertNull:BarName] isEqualToString:@""] && [[self convertNull:name] isEqualToString:@""]) {
        return nil;
        
    }else if ([[self convertNull:name] isEqualToString:@""]) {
        UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(KscreenWidth - 70, 10, 50, 40);
        [button setTitle:BarName forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addNext) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = right;
        return right;

    }else{
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        searchButton.frame = CGRectMake(KscreenWidth - 90, 10, 40, 40);
        [searchButton setTitle:name forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        
        
        UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(KscreenWidth - 50, 10, 40, 40);
        [button setTitle:BarName forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addNext) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithCustomView:button];
            //将按钮数组放在navbar 上
         [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:right1,right, nil]];
    
    }
    return nil;
}

- (void)addNext{
    
}
- (void)searchAction{
    
}

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

//时间
- (void)showAlert:(NSString *)message{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}



-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}
-(NSString*)convertNullkongge:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }else if ([object isEqualToString:@" "]){
        return @"";
    }
    return object;
}

//自动登录
- (void)selfLogin{


    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefault objectForKey:@"account"];
    NSString *passWord  = [userDefault objectForKey:@"password"];
    NSString *code = [userDefault objectForKey:@"imei"];
    account = [self convertNull:account];
    passWord = [self convertNull:passWord];
    code = [self convertNull:code];
    
    //地址
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/login"];
    //参数
    NSDictionary *parameters = @{@"imei":code,@"mobile":@"true",@"table":@"yhzh",@"password":passWord,@"account":account};
    [DataPost requestAFWithUrl:urlStr params:parameters finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自动登录返回:%@",returnDic);
        NSString *isPass = returnDic[@"isPass"];
        if ([isPass isEqualToString:@"true"]) {
            //[self showAlert:@"自动登录成功！"];
            NSLog(@"自动登录成功");
        }
        NSDictionary * rootDic = returnDic;
        NSLog(@"登录成功返回的信息:%@",rootDic);
        NSDictionary * rootDic1 = rootDic[@"account"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:rootDic1[@"account"] forKey:@"account"];
        [userDefault setObject:rootDic1[@"id"] forKey:@"id"];
        [userDefault setObject:rootDic1[@"locationhz"] forKey:@"locationhz"];
        [userDefault setObject:rootDic1[@"imeicode"] forKey:@"imeicode"];
        [userDefault setObject:rootDic1[@"name"] forKey:@"name"];
        [userDefault setObject:rootDic1[@"sex"] forKey:@"sex"];
        [userDefault setObject:rootDic1[@"age"] forKey:@"age"];
        [userDefault setObject:rootDic1[@"cellno"] forKey:@"cellno"];
        [userDefault setObject:rootDic1[@"telno"] forKey:@"telno"];
        [userDefault setObject:rootDic1[@"email"] forKey:@"email"];
        [userDefault setObject:rootDic1[@"note"] forKey:@"note"];
        [userDefault setObject:rootDic[@"logincode"] forKey:@"logincode"];
        [userDefault synchronize];

        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"自动登录失败");
    }];


}
- (NSString *)replaceOthers:(NSString *)responseString
{
    
//    responseString = [responseString substringWithRange:NSMakeRange(1, responseString.length-2)];
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    return responseString;
    return returnString;
}


- (NSString *)replaceChar:(NSString *)EnString
{
    NSString *returnString = [EnString stringByReplacingOccurrencesOfString:@"+" withString:@"＋"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"%" withString:@"％"];
    return returnString;
}

- (NSString *)getNumber:(NSString *)numString{
   
    NSString *numStr;
    //转double
    double m ;
    m = [numString doubleValue];
    //转int
    int n;
    n = [numString intValue];
    //判断是否进位
    if ((m-n) < 0.5 ) {
        numStr = [NSString stringWithFormat:@"%zi",n];
    }else{
        numStr = [NSString stringWithFormat:@"%zi",n + 1];
    }
    return numStr;
}

@end
