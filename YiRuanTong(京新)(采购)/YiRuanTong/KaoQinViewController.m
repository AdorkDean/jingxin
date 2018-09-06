//
//  KaoQinViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KaoQinViewController.h"
#import <AddressBook/AddressBook.h>
#import "MainViewController.h"
#import "KQLiShiViewController.h"
#import "KaoQInViewCell.h"
#import "BaiDuMapViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyPositionViewController.h"
#import "DataPost.h"
#import "MBProgressHUD.h"
#import "KaoQinTongjiVC.h"
@interface KaoQinViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>

{
    CLLocationCoordinate2D _loc;
    UIWebView *_web ;
    BMKLocationService *_locService;
    //MBProgressHUD *_HUD;
}
@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;

@property (strong,nonatomic)NSTimer * timer;  // 刷新显示时间的定时器
@property (strong,nonatomic)NSString * addressMessage;
@property (nonatomic,retain)NSTimer *upTimer; // 上传经纬度的定时器

@end

@implementation KaoQinViewController
//视图将要显示时隐藏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //创建NSTimer计时器 每过一秒执行一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)
                                              target:self
                                            selector:@selector(onTimer)
                                            userInfo:nil
                                             repeats:YES];
}

//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"考勤管理";
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    //页面设置
    [self KaoQinViewLoad];
    
    //进度HUD
//    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //设置模式为进度框形的
//    _HUD.labelText = @"网络不给力，正在加载中...";
//    _HUD.mode = MBProgressHUDModeIndeterminate;
//    [_HUD show:YES];

    [self locate];
    
}

- (void)KaoQinViewLoad
{
    //考勤管理的界面设置
    UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    headImageView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.view addSubview:headImageView];
    //时间
    self.lab1 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2 - 150, 10, 300, 40)];
    self.lab1.textColor = [UIColor whiteColor];
    self.lab1.textAlignment = NSTextAlignmentCenter;
    self.lab1.font =[UIFont systemFontOfSize:40];
    
    //日期
    self.lab2 =[[UILabel alloc]initWithFrame:CGRectMake(40, 60, 200, 30)];
    self.lab2.textColor = [UIColor whiteColor];
    self.lab2.font = [UIFont systemFontOfSize:20];
    self.lab2.textAlignment = NSTextAlignmentLeft;
    //星期
    self.lab3 =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth - 80 -40, 60, 80, 30)];
    self.lab3.textColor = [UIColor whiteColor];
    self.lab3.font = [UIFont systemFontOfSize:20];
    self.lab3.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:self.lab1];
    [self.view addSubview:self.lab2];
    [self.view addSubview:self.lab3];
    [self locate];
    
    //先将系统时间赋值到realTimeLabel上  避免刚进去label空缺
    NSDate * currentDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * currentDateStr = [dateFormatter stringFromDate:currentDate];
    //获取星期
    NSArray * arrWeek = [NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:currentDate];
    NSInteger week = [comps weekday];
    NSString *weekDay = [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];

    //时间
    NSRange timeRange =  {11,8};
    NSString *timeStr = [currentDateStr substringWithRange:timeRange];
    self.lab1.text = timeStr;
    //日期
    NSRange dateRange = {0,10};
    NSString *dateStr = [currentDateStr substringWithRange:dateRange];
    self.lab2.text = dateStr;
    //星期
    self.lab3.text = weekDay;

    //签到
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, KscreenWidth, 320)];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.rowHeight = 50;
    [self.view addSubview:_tabView];
    
    _photoArray = @[@"sign_ok_img.png",
                    @"sign_ce_img.png",
                    @"sign_map_img.png",
                    @"sign_point_img.png",
                    @"sign_list_img.png",
                    @"sign_account_img.jpg"];
    
    _nameArray = @[@"考勤签到",
                   @"考勤签退",
                   @"我的路线",
                   @"我的位置",
                   @"考勤历史",
                   @"考勤统计"];
}

#pragma mark -UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *iden = @"cell_1";
    KaoQInViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (KaoQInViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"KaoQInViewCell" owner:self options:nil] firstObject];
        //辅助图标
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.ImageView.image = [UIImage imageNamed:_photoArray[indexPath.row]];
    cell.TitleLabel.text = _nameArray[indexPath.row];
    return cell;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //签到
        if (self.addressMessage.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前位置定位失败,请尝试重新点击" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self locate];
        } else {
          [self qiandao];
        }
    } else if (indexPath.row == 1){
        //签退
        if (self.addressMessage.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前位置定位失败,请尝试重新点击" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self locate];
        } else {
            [self qiantui];
        }
    } else if (indexPath.row == 2){
        //我的路线
        BaiDuMapViewController *baiDuMapVC = [[BaiDuMapViewController alloc] init];
        [self.navigationController pushViewController:baiDuMapVC animated:YES];
    } else if (indexPath.row == 3){
        //我的位置
        MyPositionViewController *myLocVC = [[MyPositionViewController alloc] init];
        myLocVC.myLoc = _loc;
        [self.navigationController pushViewController:myLocVC animated:YES];
        
    }else if (indexPath.row == 4){
        //跳转到考勤历史界面 的方法
        KQLiShiViewController *liShiView = [[KQLiShiViewController alloc] init];
        [self.navigationController pushViewController:liShiView animated:YES];
    }else if (indexPath.row == 5){
        //跳转到考勤统计界面 的方法
        KaoQinTongjiVC *liShiView = [[KaoQinTongjiVC alloc] init];
        [self.navigationController pushViewController:liShiView animated:YES];
    }
}

- (void)qiandao
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString  stringWithFormat:@"当前位置在:%@,是否要签到?",self.addressMessage] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
}

- (void)qiantui
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString  stringWithFormat:@"当前位置在:%@,是否要签退?",self.addressMessage] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 200;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self DataRequest];
        }
    } else if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            [self DataRequest1];
        }
    }
}

#pragma mark - 定位
- (void)locate
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
   
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:100.f];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //上传经纬度获取
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    //停止定位服务
    _loc = coordinate;
    [_locService stopUserLocationService];
    [self outputAdd];
    
}

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (void)outputAdd
{
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake([self.lblLatitude floatValue], [self.lblLongitude floatValue]);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
        //位置信息
        self.addressMessage = result.address;
        NSLog(@"显示位置:%@",self.addressMessage);
        //[_HUD hide:YES afterDelay:.5];
    }else{
        NSLog(@"找不到相对应的位置信息");
        
    }
}



//获取当前实时时间 更新到realTimeLabel上
- (void)onTimer
{
    NSDate * currentDate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * currentDateStr = [dateFormatter stringFromDate:currentDate];
    self.lab1.text = currentDateStr;
}

//在视图消失时 结束NSTimer
- (void)viewDidDisappear:(BOOL)animated
{   [super viewDidDisappear:animated];
    [_timer invalidate];
}

- (void)DataRequest
{
    /*签到
     http://182.92.96.58:8005/yrt/servlet/workSign
     
     mobile	true
     action	signIn
     data	{
     "signinLongBefore": "117.151065",
     "signinLatiBefore": "36.670494",
     "signinSite": "山东省济南市历城区g309",
     "table": "gzkq"
     }
     table	gzkq
     返回值
     {
     "state": "1",
     "info": "签到迟到、旷工!",
     "time": "2015-01-07 16:32"
     }*/
    //考勤管理——考勤签到的
    //先定位
    [_locationManager startUpdatingLocation];
    double lon = [self.lblLongitude doubleValue];
    double la = [self.lblLatitude doubleValue];
    if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
        
        NSLog(@"位置信息异常!");
        [self showAlert:@"定位信息异常,请重新签到！"];
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/workSign"];
        NSDictionary *params = @{@"action":@"signIn",@"mobile":@"true",@"table":@"gzkq",@"data":[NSString stringWithFormat:@"{\"signinLongBefore\":\"%@\",\"signinLatiBefore\":\"%@\",\"signinSite\":\"%@\",\"table\":\"gzkq\"}",self.lblLongitude,self.lblLatitude,self.addressMessage]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *dataStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSDictionary * dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"签到信息%@",dataStr);
            NSString * str1 = dict1[@"info"];
            UIAlertView *tan = [[UIAlertView alloc]initWithTitle:@"提示" message:str1 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tan show];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"上传签到失败");
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

}

- (void)DataRequest1
{
    /*签退
     http://182.92.96.58:8005/yrt/servlet/workSign
     mobile	true
     action	signOut
     data	{
     "signoutSite": "山东省济南市历城区g309",
     "signoutLatiBefore": "36.670494",
     "signoutLongBefore": "117.151065",
     "table": "gzkq"
     }
     table	gzkq
     返回值
     {
     "state": "1",
     "info": "签退早退!",
     "time": "2015-01-07 16:34"
     }*/
    //考勤管理——考勤签退的
    //先定位
    [_locationManager startUpdatingLocation];
    double lon = [self.lblLongitude doubleValue];
    double la = [self.lblLatitude doubleValue];
    if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
        
        NSLog(@"位置信息异常!");
         [self showAlert:@"定位信息异常,请重新签退！"];
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/workSign"];
        NSDictionary *params = @{@"action":@"signOut",@"mobile":@"true",@"table":@"gzkq",@"data":[NSString stringWithFormat:@"{\"signoutSite\":\"%@\",\"signoutLatiBefore\":\"%@\",\"signoutLongBefore\":\"%@\",\"table\":\"gzkq\"}",self.addressMessage,self.lblLatitude,self.lblLongitude]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
            if (dict1 !=  nil) {
                
                NSString * str1 = dict1[@"info"];
                UIAlertView * tan = [[UIAlertView alloc]initWithTitle:@"提示" message:str1 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [tan  show];
            }
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"上传签退失败");
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
}

@end
