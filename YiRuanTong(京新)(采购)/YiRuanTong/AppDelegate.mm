//
//  AppDelegate.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "AppDelegate.h"
#import "ZhuYeViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "RCIM.h"
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"
#import "LocaModel.h"
#import "DataPost.h"
#import "DingDanViewController.h"
#import <MeiQiaSDK/MQManager.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
//#define  NAVI_TEST_APP_KEY @"xaNL6uSnAduwW2Geayrdpni6"
#define  NAVI_TEST_APP_KEY @"f6UMR5clrDIgVigwEDkKXYohz7QnLahK"
@interface AppDelegate ()<BMKLocationServiceDelegate,JPUSHRegisterDelegate>

{
    NSString *_account;
    NSString *_locationhz;
    NSString *_imeicode;
    BMKLocationService *_locService;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    //状态栏颜色改变
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:NAVI_TEST_APP_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    if (launchOptions != nil)
    {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            NSString *elert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            NSLog(@"%@",elert);
        }
    } else{
    }
    [self locate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _account = [userDefault objectForKey:@"account"];
    _locationhz = [[userDefault objectForKey:@"locationhz"] stringValue];
    _imeicode = [userDefault objectForKey:@"imeicode"];
    //当初次登陆时 让时间默认为1分钟
    if (_locationhz.length == 0) {
        _locationhz = @"1";
    }
    int a = [_locationhz intValue];
    int b = a * 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:b
                                              target:self
                                            selector:@selector(uploadLocation)
                                            userInfo:nil
                                             repeats:YES];
    
    //初始化导航SDK
    [BNCoreServices_Instance initServices: NAVI_TEST_APP_KEY];
    //TTS在线授权
    [BNCoreServices_Instance setTTSAppId:@"10009165"];
    //设置是否自动退出导航
    [BNCoreServices_Instance setAutoExitNavi:NO];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    
        //融云 注册通知
    [RCIM initWithAppKey:@"qd46yzrf4vdbf" deviceToken:nil];
    
    // 在 iOS 8 下注册苹果推送，申请推送权限。
 
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
   
      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
       [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    //极光
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //_num = 0;
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [MQManager initWithAppkey:@"321d8d31c057a6e60858d257b7aefc00" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[LoginViewController alloc] init];
    return YES;
}

- (void)locate
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
        
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSLog(@"经纬度%@ - %@",self.lblLongitude,self.lblLatitude);
    [_locService stopUserLocationService];
    
    
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
#pragma mark - 实时定位上传
- (void)uploadLocation
{
    //检测网络状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"未检测到网络！");
        //获取当前定位时间点
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr =[dateFormatter stringFromDate:currentDate];
        [_locService startUserLocationService];
       
        double lon = [self.lblLongitude doubleValue];
        double la = [self.lblLatitude doubleValue];
        if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
            
            NSLog(@"位置信息异常!");
        }else{
            
            LocaModel *model = [[LocaModel alloc] init];
            model.lblLongitude = self.lblLongitude;
            model.lblLatitude = self.lblLatitude;
            model.timeStr = dateStr;
            [model save];
        }
        


       
        
    }else{
        //取出存储的数据
        NSMutableArray *array = [LocaModel findAll];
        if (array.count == 0) {
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            _account = [userDefault objectForKey:@"account"];
            [_locService startUserLocationService];
            
            double lon = [self.lblLongitude doubleValue];
            double la = [self.lblLatitude doubleValue];
            if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
                 NSLog(@"位置信息异常!");
            }else{
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location"];
                NSDictionary *params = @{@"mobile":@"true",@"action":@"setSalerLoction",@"data":[NSString stringWithFormat:@"{\"longitude\":\"%@\",\"latitude\":\"%@\",\"account\":\"%@\",\"imei\":\"%@\"}",self.lblLongitude,self.lblLatitude,_account,_imeicode]};
                [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
                    NSString *str1 =[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                    NSLog(@"定时上传返回%@",str1);
                } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
                    NSLog(@"定时上传失败");
                }];

            
            }

        }else  if(array.count > 0){
            /*
             {"longitude":"117.15097","latitude":"36.6705","account":"yph","imei":"867064014296733","localList":[{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:02:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:03:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:04:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:05:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:06:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:07:52"}]}
             */

            NSLog(@"存储数据的数目%zi",array.count);
           
            //每次上传获取一下当前经纬度
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            _account = [userDefault objectForKey:@"account"];
             [_locService startUserLocationService];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location"];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request setHTTPMethod:@"POST"];
            NSMutableString *str =[NSMutableString  stringWithFormat:@"mobile=true&action=setSalerLoction&data={\"longitude\":\"%@\",\"latitude\":\"%@\",\"account\":\"%@\",\"imei\":\"%@\",}",self.lblLongitude,self.lblLatitude,_account,_imeicode];
            //拼接无网络时存储的数据
            NSMutableString  *dataStr = [NSMutableString stringWithFormat:@"\"localList\":[]"];
            for (LocaModel *model in array) {
                [dataStr insertString:[NSString stringWithFormat:@"{\"latitude\":\"%@\",\"longitude\":\"%@\",\"time\":\"%@\"},",model.lblLatitude,model.lblLongitude,model.timeStr] atIndex:dataStr.length - 1];
            }
            [dataStr deleteCharactersInRange:NSMakeRange(dataStr.length - 2, 1)];
            
            [str insertString:[NSString stringWithFormat:@"%@",dataStr] atIndex:str.length-1];
            
            NSLog(@"存储上传字符串%@",str);
            NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"存储上传返回信息%@",str1);
            //根据返回信息处理存储的数据选择是否清除
            if(str1.length != 0){
                NSRange range =  {1, str1.length-2};
                NSString *realStr = [str1 substringWithRange:range];
                if ([realStr isEqualToString:@"true"]){
                    [LocaModel clearTable];
                    [array removeAllObjects];
                    NSLog(@"清空后数据数目%zi",array.count);
                }else{
                    NSLog(@"存储上传失败");
                    [LocaModel clearTable];
                    [array removeAllObjects];
                    NSLog(@"失败后清空%zi",array.count);
                    
                }

            }
            
        }
    
    }

}

- (NSString *)deleteAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    returnString = [returnString substringWithRange:NSMakeRange(1, returnString.length-2)];
    return returnString;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//
//    //DebugLog(@"RemoteNote userInfo:%@",userInfo);
//    DebugLog(@" 收到推送消息： %@",userInfo[@"aps"][@"alert"]);
//}

// 获取苹果推送权限成功。
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 设置 deviceToken。
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
#pragma mark  集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"获取token失败:%@",error);
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];
    NSLog(@"未读消息数目:%zi",[[RCIM sharedRCIM] getTotalUnreadCount]);
    
    //勿扰时段内关闭本地通知
    [[RCIM sharedRCIM] getConversationNotificationQuietHours:^(NSString *startTime, int spansMin) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        if (startTime && startTime.length != 0) {
            NSDate *startDate = [dateFormatter dateFromString:startTime];
            NSDate *endDate = [startDate dateByAddingTimeInterval:spansMin * 60];
            NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
            NSDate *nowDate = [dateFormatter dateFromString:nowDateString];
            
            NSDate *earDate = [startDate earlierDate:nowDate];
            NSDate *laterDate = [endDate laterDate:nowDate];
            
            if (([startDate isEqualToDate:earDate] && [endDate isEqualToDate:laterDate]) || [nowDate isEqualToDate:startDate] || [nowDate isEqualToDate:earDate]) {
                //设置本地通知状态为关闭
                [[RCIM sharedRCIM] setMessageNotDisturb:YES];
                
            }else{
                
                [[RCIM sharedRCIM] setMessageNotDisturb:NO];
            }
        }
    } errorCompletion:^(RCErrorCode status) {
        
    }];
#pragma mark  集成第三步: 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_num + 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];   //清除角标
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    
    //[UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //后台退出
    [self logOut];
}



void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}

- (void)logOut{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/loginout"];
    NSDictionary *params = @{@"":@""};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSLog(@"推出登录销毁session");
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
    
    
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark- JPUSHRegisterDelegate





- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    //[rootViewController addNotificationCount];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //NSLog(@"角标个数：%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    if ((long)[UIApplication sharedApplication].applicationIconBadgeNumber == 0) {
        
    }else{
        
        //        NSNotification *mynotification = [NSNotification notificationWithName:@"icon" object:self userInfo:nil];
        //        [[NSNotificationCenter defaultCenter] postNotification:mynotification];
    }
    
    
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_num + 1];
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];   //清除角标
    //    [JPUSHService setBadge:0];
    //    [JPUSHService resetBadge];
#pragma mark  集成第二步: 进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
    
}
#pragma mark 推送处理
//iOS10之下所有的前台后台通知处理+iOS10以上前台通知处理处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        //iOS10之下，后台收到通知（无论是否锁屏）
//        NSNotification *mynotification =[NSNotification notificationWithName:@"backNotification" object:nil userInfo:userInfo];
//        [[NSNotificationCenter defaultCenter] postNotification:mynotification];
//          [self goToMssageViewControllerWith:userInfo];
        
    }else if (application.applicationState == UIApplicationStateActive){
        //无论是iOS多少，前台收到通知
        //_boolPush = 1;
//        NSNotification *mynotification =[NSNotification notificationWithName:@"backNotification" object:nil userInfo:userInfo];
//        [[NSNotificationCenter defaultCenter] postNotification:mynotification];
        
//        DingDanViewController * vc = [[DingDanViewController alloc]init];
////        vc.orderNo = alert;
//        vc.isNotice = @"1";
//        
//        [self pushViewController:vc animated:YES];
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//iOS10以上后台处理
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"userInfo-======--==~~~~~%@",userInfo);
////        if (_boolPush ==  1) {
////            _boolPush = 0;
////        }else{
////
////            NSNotification *mynotification =[NSNotification notificationWithName:@"backNotification" object:nil userInfo:userInfo];
////            [[NSNotificationCenter defaultCenter] postNotification:mynotification];
//
////        }
//        [self goToMssageViewControllerWith:userInfo];
//    }
    completionHandler(); // 系统要求执行这个方法
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    //前台收到通知，在上一个方法中，统一处理
    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    NSNotification *mynotification =[NSNotification notificationWithName:@"backNotification" object:nil userInfo:userInfo];
//    [[NSNotificationCenter defaultCenter] postNotification:mynotification];
//
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
#endif

- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    
    NSDictionary * aps = [msgDic objectForKey:@"aps"];
    NSString * alert = [aps objectForKey:@"alert"];
    NSRange startRange = [alert rangeOfString:@"["];
    NSRange endRange = [alert rangeOfString:@"]"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [alert substringWithRange:range];
    //将字段存入本地，在要跳转的页面用它来判断
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"push" forKey:@"push"];
    [pushJudge synchronize];
    
        //这里写要跳转的controller
    DingDanViewController * VC = [[DingDanViewController alloc]init];
    VC.orderNo = result;
    UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];
    [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
    
}
@end
