//
//  MainViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "MainViewController.h"
#import "ZhuYeViewController.h"
#import "DaiBanViewController.h"
#import "QiXinViewController.h"
#import "TongXunLuViewController.h"
//#import "SheZhiViewController.h"
#import "MyViewController.h"
#import "BaseNavViewController.h"

@interface MainViewController ()
{
    NSInteger _count;
}

@end

@implementation MainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadcount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //通知 监听一下tabbar的隐藏与显示
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(TabbarHidden:) name:NotificationTabBarHidden object:nil];
    
    //创建控制器
    //[self _initCtrls];
    [self initOldCtrls];
    
    
}

- (void)loadcount
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/schedule"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getCount";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data1 != nil){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"代办返回:%@",array);
        for (NSDictionary *dic1 in array) {
            NSInteger n = [dic1[@"count"] integerValue];
            _count = _count + n;
        }
        
        UITabBarItem *item = [[[self.tabBarController tabBar] items] objectAtIndex:1];
        if (_count != 0) {
            
            [item setBadgeValue:[NSString stringWithFormat:@"%zi",_count]];
        }

    }
}

- (void)TabbarHidden:(NSNotification *)noti
{
    if ([noti.object isEqualToString:@"yes"]) {
        self.tabBar.hidden = YES;
    }
    else if ([noti.object isEqualToString:@"no"]) {
        self.tabBar.hidden = NO;
    }
}

//创建三级控制器
- (void)_initCtrls {
    
    //1.创建视图控制器
    NSMutableArray *viewCtrls = [[NSMutableArray alloc] init];
    ZhuYeViewController *zhuYe = [[ZhuYeViewController alloc] init];
    //DaiBanViewController *daiBan = [[DaiBanViewController alloc]init];
    QiXinViewController *qiXin = [[QiXinViewController alloc] init];
    TongXunLuViewController *tongXunLu = [[TongXunLuViewController alloc] init];
    
    //将视图控制器存放到数组中
    [viewCtrls addObject:zhuYe];
    //[viewCtrls addObject:daiBan];
    [viewCtrls addObject:tongXunLu];
    [viewCtrls addObject:qiXin];
    
    //创建数组存放标题
    NSArray *titleArrary = @[@"应用",@"通讯录",@"消息"];
    
    //创建数组存放图片的名字
    self.imageName = @[@"tab_main_00.png",
                       @"tab_main_10.png",
                       @"tab_main_20.png"
                       ];
    
    self.imageName1 = @[@"tab_main_01.png",
                        @"tab_main_11.png",
                        @"tab_main_21.png"
                       ];
    
    for (int i = 0; i < 3; i++) {
        UIViewController *vc = viewCtrls[i];
        //标题
        vc.title = titleArrary[i];
        NSString *imageStr = self.imageName[i];
        NSString *selectImageStr = self.imageName1[i];
        if (IOS7) {
            //渲染模式
            vc.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            [vc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectImageStr] withFinishedUnselectedImage:[UIImage imageNamed:imageStr]];
        }
        //导航控制器
        BaseNavViewController *navCtrl = [[BaseNavViewController alloc] initWithRootViewController:vc];
        //设置标题属性 白色
        [navCtrl.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [viewCtrls replaceObjectAtIndex:i withObject:navCtrl];
    }
    //创建标签控制器
    self.viewControllers = viewCtrls;
}

#pragma mark - 老版本

//创建三级控制器
- (void)initOldCtrls {
    
    //1.创建视图控制器
    NSMutableArray *viewCtrls = [[NSMutableArray alloc] init];
    ZhuYeViewController *zhuYe = [[ZhuYeViewController alloc] init];
    DaiBanViewController *daiBan = [[DaiBanViewController alloc]init];
    //QiXinViewController *qiXin = [[QiXinViewController alloc] init];
    TongXunLuViewController *tongXunLu = [[TongXunLuViewController alloc] init];
    //SheZhiViewController *shezhiVC = [[SheZhiViewController alloc] init];
    MyViewController *myVC = [[MyViewController alloc] init];

    //将视图控制器存放到数组中
    [viewCtrls addObject:zhuYe];
    [viewCtrls addObject:daiBan];
    [viewCtrls addObject:tongXunLu];
    //[viewCtrls addObject:shezhiVC];
    [viewCtrls addObject:myVC];

    //创建数组存放标题
    NSArray *titleArrary = @[@"主页",@"待办",@"通讯录",@"我的"];
    
    //创建数组存放图片的名字
    self.imageName = @[@"tab_main_00.png",
                       @"tab_main_10.png",
                       @"tab_main_20.png",
                       @"tab_main_30.png"];
    
    self.imageName1 = @[@"tab_main_01.png",
                        @"tab_main_11.png",
                        @"tab_main_21.png",
                        @"tab_main_31.png"];
    self.tabBar.tintColor = UIColorFromRGB(0x3cbaff);

    for (int i = 0; i < 4; i++) {
        UIViewController *vc = viewCtrls[i];
        //标题
        vc.title = titleArrary[i];
        NSString *imageStr = self.imageName[i];
        NSString *selectImageStr = self.imageName1[i];
        if (IOS7) {
            //渲染模式
            vc.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            [vc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectImageStr] withFinishedUnselectedImage:[UIImage imageNamed:imageStr]];
        }
        //导航控制器
        BaseNavViewController *navCtrl = [[BaseNavViewController alloc] initWithRootViewController:vc];
        //设置标题属性 白色
        [navCtrl.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [viewCtrls replaceObjectAtIndex:i withObject:navCtrl];
    }
    //创建标签控制器
    self.viewControllers = viewCtrls;
}



@end
