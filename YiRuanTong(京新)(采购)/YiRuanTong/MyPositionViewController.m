//
//  MyPositionViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/5/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "MyPositionViewController.h"
#import "MyPositionTableViewCell.h"
@interface MyPositionViewController ()<UITextFieldDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource>{
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
@end

@implementation MyPositionViewController

- (UITableView *)mapTableview{
    if (_mapTableview == nil) {
        _mapTableview = [[UITableView alloc]initWithFrame:CGRectMake(15, 55, KscreenWidth-30, KscreenHeight-64-55)];
        _mapTableview.delegate = self;
        _mapTableview.dataSource = self;
        [self.view addSubview:_mapTableview];
    }
    _mapTableview.hidden = NO;
    return _mapTableview;
}
- (UIButton*)createButton:(NSString*)title target:(SEL)selector frame:(CGRect)frame
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [button setBackgroundColor:[UIColor whiteColor]];
    }else
    {
        [button setBackgroundColor:[UIColor clearColor]];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (UITextField *)textfield{
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.frame = CGRectMake(15, 15, KscreenWidth-30, 40);
        [_textfield setFont:[UIFont systemFontOfSize:16.0]];
        [_textfield setTextColor:UIColorFromRGB(0x808080)];
        _textfield.backgroundColor = [UIColor whiteColor];
        [_textfield setBorderStyle:UITextBorderStyleRoundedRect];
        _textfield.textAlignment = NSTextAlignmentLeft;
        _textfield.placeholder = @"请输入目的地(可以点击地图上的位置)";
        _textfield.delegate = self;
        [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_textfield setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return _textfield;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的位置";
    self.navigationItem.rightBarButtonItem = nil;
    _mapArray = [[NSMutableArray alloc]init];
    _searcherNum = 0;
    //创建地图
    [self initMap];
    
    //
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _myLoc;
    annotation.title = @"我的位置";
    [_mapView setCenterCoordinate:_myLoc];
    _mapView.zoomLevel = 18;
    [_mapView addAnnotation:annotation];
}
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
- (void)initMap{
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.mapView.delegate = self;
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:self.mapView];
    
    //导航
    CGSize buttonSize = {240,40};
    CGRect buttonFrame = {(self.view.frame.size.width-buttonSize.width)/2,KscreenHeight-64-60,buttonSize.width,buttonSize.height};
    UIButton* realNaviButton = [self createButton:@"开始导航" target:@selector(realNavi:)  frame:buttonFrame];
    [self.view addSubview:realNaviButton];
    
    [self.view addSubview:self.textfield];
    
    //设置白天黑夜模式
    [BNCoreServices_Strategy setDayNightType:BNDayNight_CFG_Type_Auto];
    //设置停车场
    [BNCoreServices_Strategy setParkInfo:YES];
    
    CLLocationCoordinate2D wgs84llCoordinate;
    //assign your coordinate here...
    
    CLLocationCoordinate2D bd09McCoordinate;
    //the coordinate in bd09MC standard, which can be used to show poi on baidu map
    bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];

    
    //定位
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    
    //初始化检索对象
    _poisearcher = [[BMKPoiSearch alloc]init];
    
    
   
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
    _poisearcher.delegate = nil;
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


//真实GPS导航
- (void)realNavi:(UIButton*)button
{
    if (![self checkServicesInited]) return;
    [self startNavi];
}

- (void)startNavi
{
    BOOL useMyLocation = NO;
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    if (useMyLocation) {
        startNode.pos.x = myLocation.coordinate.longitude;
        startNode.pos.y = myLocation.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_OriginalGPS;
    }
    else {
        startNode.pos.x = _Mylocation.longitude;
        startNode.pos.y = _Mylocation.latitude;
        startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    }
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    
//    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
//    midNode.pos = [[BNPosition alloc] init];
//    midNode.pos.x = 113.977004;
//    midNode.pos.y = 22.556393;
    //midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    
    if (!(_location.latitude == 0)) {
        endNode.pos.x = _location.longitude;
        endNode.pos.y = _location.latitude;
    }
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    //关闭openURL,不想跳转百度地图可以设为YES
    [BNCoreServices_RoutePlan setDisableOpenUrl:YES];
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
    
    //导航中改变终点方法示例
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
     endNode.pos = [[BNPosition alloc] init];
     endNode.pos.x = 114.189863;
     endNode.pos.y = 22.546236;
     endNode.pos.eType = BNCoordinate_BaiduMapSDK;
     [[BNaviModel getInstance] resetNaviEndPoint:endNode];
     });*/
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo
{
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            NSLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            NSLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            NSLog(@"起终点距离起终点太近");
            break;
        default:
            NSLog(@"算路失败");
            break;
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}


#pragma mark - 安静退出导航

- (void)exitNaviUI
{
    [BNCoreServices_UI exitPage:EN_BNavi_ExitTopVC animated:YES extraInfo:nil];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi)
    {
        NSLog(@"退出导航");
    }
    else if (pageType == BNaviUI_Declaration)
    {
        NSLog(@"退出导航声明页面");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //textField放弃第一响应者 （收起键盘）
    //键盘是textField的第一响应者
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"已经停止编辑");
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    
    citySearchOption.pageIndex = 0;
    
    citySearchOption.pageCapacity = 20;
    
    //citySearchOption.city= self.city;
    
    citySearchOption.keyword = textField.text;
    BOOL flag = [_poisearcher poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"检索发送成功");
        _poisearcher.delegate = self;
        //进度HUD
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //设置模式为进度框形的
        _HUD.labelText = @"正在努力为您检索中...";
        _HUD.mode = MBProgressHUDModeIndeterminate;
        [_HUD show:YES];
    }
    else
    {
        NSLog(@"检索发送失败");
        _mapTableview.hidden = YES;

    }
    
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    [_mapArray removeAllObjects];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSLog(@"%@,%@",poiResult.poiInfoList,poiResult.cityList);
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        //在此处理正常结果
        if (poiResult.poiInfoList==nil) {
            if (poiResult.cityList) {
                _searcherNum = 2;
                for (int i=0; i<[poiResult.cityList count]; i++) {
                    BMKCityListInfo *listinfo = poiResult.cityList[i];
                    NSString *address = [NSString stringWithFormat:@"%@",listinfo.city];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:_textfield.text forKey:@"name"];
                    [dic setValue:address forKey:@"address"];
                    
                    [_mapArray addObject:dic];
                    
                }
                [self.mapTableview reloadData];

            }else{
                _mapTableview.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，未找到结果" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }else{
            _searcherNum = 1;
            for (int i=0; i<[poiResult.poiInfoList count]; i++) {
                BMKPoiInfo *info = poiResult.poiInfoList[i];
                NSString *address = [NSString stringWithFormat:@"%@-%@",info.city,info.address];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:info.name forKey:@"name"];
                [dic setValue:address forKey:@"address"];
                [dic setValue:[NSString stringWithFormat:@"%f",info.pt.latitude] forKey:@"latitude"];
                [dic setValue:[NSString stringWithFormat:@"%f",info.pt.longitude] forKey:@"longitude"];
                
                [_mapArray addObject:dic];
            }
            /*
             NSString* _name;			///<POI名称
             NSString* _uid;
             NSString* _address;		///<POI地址
             NSString* _city;			///<POI所在城市
             NSString* _phone;		///<POI电话号码
             NSString* _postcode;		///<POI邮编
             int		  _epoitype;		///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
             CLLocationCoordinate2D _pt;	///<POI坐标
             */
            [self.mapTableview reloadData];
        }
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，未找到结果" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}


////接收正向编码结果
//- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        //在此处理正常结果
//        NSLog(@">>>>>>>%f,%f  %@",result.location.latitude,result.location.longitude,result.address);
//        
//        _location = result.location;
//    }
//    else {
//        NSLog(@"抱歉，未找到结果");
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，未找到结果" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//    }
//}
//定位
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _Mylocation = userLocation.location.coordinate;
    
}

//点击地图随意位置
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi{
    NSLog(@"%@",mapPoi.text);
    _textfield.text = mapPoi.text;
    _location = mapPoi.pt;
}

#pragma mark - uitableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mapArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyPositionTableViewCell* commentCell = [tableView dequeueReusableCellWithIdentifier:@"MyPositionTableViewCell"];
    if (!commentCell) {
        commentCell = [[[NSBundle mainBundle]loadNibNamed:@"MyPositionTableViewCell" owner:nil options:nil]firstObject];
    }
    if (tableView == _mapTableview) {
        commentCell.namelab.text = [_mapArray[indexPath.row] objectForKey:@"name"];
        commentCell.addresslab.text = [_mapArray[indexPath.row] objectForKey:@"address"];

    }
        
    
    return commentCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searcherNum == 1) {
        
        _textfield.text = [_mapArray[indexPath.row] objectForKey:@"name"];
        _location.latitude = [[_mapArray[indexPath.row] objectForKey:@"latitude"] doubleValue];
        _location.longitude = [[_mapArray[indexPath.row] objectForKey:@"longitude"] doubleValue];
        _mapTableview.hidden = YES;
        
        self.mapView.centerCoordinate = _location;//移动到中心点
        
    }else if (_searcherNum == 2){
        BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
        
        citySearchOption.pageIndex = 0;
        
        citySearchOption.pageCapacity = 20;
        
        citySearchOption.city= [_mapArray[indexPath.row] objectForKey:@"address"];
        
        citySearchOption.keyword = [_mapArray[indexPath.row] objectForKey:@"name"];
        BOOL flag = [_poisearcher poiSearchInCity:citySearchOption];
        if(flag)
        {
            NSLog(@"检索发送成功");
            _poisearcher.delegate = self;
            
        }
        else
        {
            NSLog(@"检索发送失败");
            _mapTableview.hidden = YES;
            
        }
    }

}
@end
