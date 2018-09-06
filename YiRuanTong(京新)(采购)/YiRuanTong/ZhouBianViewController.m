//
//  ZhouBianViewController.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ZhouBianViewController.h"
#import "DataPost.h"
#import "ArroundModel.h"
#import "JJAnnotationView.h"
@interface ZhouBianViewController ()<BMKPoiSearchDelegate,BMKLocationServiceDelegate>{
    UITextField *_textfield;
    BMKPoiSearch *_poisearcher;
    BMKLocationService *_locService;
    CLLocationCoordinate2D _location;
    CLLocationCoordinate2D _Mylocation;
    
    int _searcherNum;//检索级别
    MBProgressHUD *_HUD;
}
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)UITableView *mapTableview;
@property(nonatomic,strong)NSMutableArray *mapArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ZhouBianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"周边位置";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [[NSMutableArray alloc]init];
    
    _searcherNum = 0;
    //创建地图
    [self initMap];
    
   
}
-(void)requestLocationDataWithOwnCurrentLocation:(CLLocationCoordinate2D)locat{
    //地图周边后台返回数据接口
    
//    data={"lat1":"36.675595","long1":"117.228472","distance":"40000"}&mobile=true&action=getSurroundCust&table=khxx
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
    NSDictionary *params = @{@"mobile":@"true",@"action":@"getSurroundCust",@"table":@"khxx",@"data":[NSString stringWithFormat:@"{\"lat1\":\"%f\",\"long1\":\"%f\",\"distance\":\"%@\"}",locat.latitude,locat.longitude,@"40000"]};
    
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"周边返回%@",array);
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    ArroundModel *model = [[ArroundModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                JJAnnotationView* annotation = [[JJAnnotationView alloc]init];
                annotation.coordinate = _myLoc;
                
                annotation.title = @"我的位置";
                annotation.subtitle = @"默认当前自己位置";
                [_mapView setCenterCoordinate:_myLoc];
                _mapArray = [[NSMutableArray alloc]init];
                [_mapArray addObject:annotation];
                
                for (ArroundModel *model in _dataArray) {
//                    ArroundModel *model = _dataArray[0];
                    double lat =  (arc4random() % 100) * 0.001f;
                    double lon =  (arc4random() % 100) * 0.001f;
                    JJAnnotationView *point = [[JJAnnotationView alloc] init];
                    point.title = [NSString stringWithFormat:@"%@",model.name];
                    point.subtitle = [NSString stringWithFormat:@"距离:%.2fm",[model.distance floatValue]];
                    //point.model = model;
                    point.coordinate = CLLocationCoordinate2DMake([model.latitude floatValue]+ lat,[model.longitude floatValue] + lon);
                    [_mapArray addObject:point];
                    
                }
                [_mapView removeAnnotations:_mapView.annotations];
                [_mapView addAnnotations:_mapArray];
            }

        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
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
    //停止定位服务
    _myLoc = coordinate;
    //
    [_locService stopUserLocationService];
    
    [self requestLocationDataWithOwnCurrentLocation:_myLoc];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
//    {
//        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
//        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
//                                                           reuseIdentifier:reuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"icon_marka"];
//        return annotationView;
//    }
//    return nil;
    
    
    //判断你添加的那个大头针随便else if
    if([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.draggable = NO;
        newAnnotationView.annotation=annotation;
        newAnnotationView.image = [UIImage imageNamed:@"icon_marka"];   //把大头针换成别的图片
        return newAnnotationView;
    }
    return nil;

}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    
    if ([view.annotation isKindOfClass:[JJAnnotationView class]]) {
//        JJAnnotationView *v = (JJAnnotationView *)view.annotation;
        
    }
}
- (void)initMap{
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.mapView.delegate = self;
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:self.mapView];
    
    //设置白天黑夜模式
    [BNCoreServices_Strategy setDayNightType:BNDayNight_CFG_Type_Auto];
    //设置停车场
    [BNCoreServices_Strategy setParkInfo:YES];
    
    CLLocationCoordinate2D wgs84llCoordinate;
    //assign your coordinate here...
    
    CLLocationCoordinate2D bd09McCoordinate;
    //the coordinate in bd09MC standard, which can be used to show poi on baidu map
    bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
    
    [self locate];
  
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{   [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    [_locService stopUserLocationService];
    
    
}
- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}
@end
