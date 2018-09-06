//
//  BaiDuMapViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaiDuMapViewController.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CommonModel.h"
#import "RouteSearchVC.h"
@interface BaiDuMapViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *_array;
    CLLocationCoordinate2D _coor1;
    CLLocationCoordinate2D _coor2;
    
    UIView *_searchView;
    UIView *_backView;
    UIView *_timeView;
    UIButton *_startButton;
    UIButton *_endButton;
    UIButton *_salerButton;
    NSString *_salerId;
    UITextField *_salerField;
    NSMutableArray *_dataArray;
    UIButton* _hide_keHuPopViewBut;
    NSString * _currentDateStr;
    NSString * _pastDateStr;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation BaiDuMapViewController
- (void)getDateStr{
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"---当前的时间的字符串 =%@",currentDateStr);
    _currentDateStr = currentDateStr;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:-7];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    NSLog(@"---前一个月 =%@",beforDate);
    _pastDateStr = beforDate;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的路线";
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    _dataArray = [NSMutableArray array];
    //    [self showBarWithName:@"搜索" addBarWithName:nil];
    //    [self initSearchView];
    [self initMap];
    [self getDateStr];
    [self dataRequest];
    
}
-(void)souSuoButtonClickMethod{
    RouteSearchVC * vc = [[RouteSearchVC alloc]init];
    [vc setBlock:^(NSString *proid, NSString *proname, NSString *start, NSString *end) {
        [self searchWithStarttime:start AndEndTime:end AndSalerID:proid];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dataRequest{
    //业务员路线加载
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *idEq = [userDefault objectForKey:@"id"];
    //    NSDate *  senddate = [NSDate date];
    //    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    //    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    //    NSString *  locationString = [dateformatter stringFromDate:senddate];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
    NSDictionary *params = @{@"action":@"getSalerTrends",@"flag":@"time",@"table":@"wzgl",@"params":[NSString stringWithFormat:@"{\"ids\":[%@],\"nowdate\":\"%@\",\"begindate\":\"%@\",\"enddate\":\"%@\"}",idEq,@"",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"获取该用户所有的经纬度:%@",array);
        NSDictionary *dic = array[0];
        _array = dic[@"trendsList"];
        if (_array.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该用户暂无路线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else if (_array.count > 0){
            
            NSInteger n = _array.count;
            CLLocationCoordinate2D coors[5000] = {0};
            for (int i = 0;i < n;i++) {
                NSDictionary *dic = _array[i];
                if ([[NSString stringWithFormat:@"%@",dic[@"latitudeafter"]] isEqualToString:@"(null)"]) {
                    NSString *time = [dic objectForKey:@"rectime"];
                    NSDictionary *dic1 = @{@"latitudeafter":@"36.684336",@"longitudeafter":@"117.077644",@"rectime":time};
                    dic = dic1;
                }
                coors[i].latitude = [dic[@"latitudeafter"] floatValue];
                coors[i].longitude = [dic[@"longitudeafter"] floatValue];
                
                if (i == 0) {
                    _coor1.latitude = [dic[@"latitudeafter"] floatValue];
                    _coor1.longitude = [dic[@"longitudeafter"] floatValue];
                }
                if (i == n - 1) {
                    _coor2.latitude = [dic[@"latitudeafter"] floatValue];
                    _coor2.longitude = [dic[@"longitudeafter"] floatValue];
                }
            }
            // 添加折线覆盖物
            BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:n];
            [_mapView addOverlay:polyline];
            NSDictionary *dic2 = _array[0];
            CLLocationCoordinate2D coor;
            coor.latitude = [dic2[@"latitudeafter"] floatValue];
            coor.longitude = [dic2[@"longitudeafter"] floatValue];
            [_mapView setCenterCoordinate:coor];
            _mapView.zoomLevel = 12;
            //标注起点
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = _coor1;
            annotation.title = @"起点";
            [_mapView addAnnotation:annotation];
            //显示标注信息
            [_mapView selectAnnotation:annotation animated:YES];
            //终点
            BMKPointAnnotation* annotation1 = [[BMKPointAnnotation alloc]init];
            annotation1.coordinate = _coor2;
            annotation1.title = @"终点";
            [_mapView addAnnotation:annotation1];
            //显示标注信息
            [_mapView selectAnnotation:annotation1 animated:YES];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != 10001) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

//创建地图
- (void)initMap{
    
    //    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 80)];
    //    _backView.backgroundColor = [UIColor lightGrayColor];
    //    _backView.alpha = 0.6;
    //    [self.view addSubview:_backView];
    //    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _salerButton.frame = CGRectMake(10, 0, 80 , 40);
    //    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    //    [_salerButton setTintColor:[UIColor blackColor]];
    //    [_backView addSubview:_salerButton];
    //    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //    NSString *name = [userDefault objectForKey:@"name"];
    //    [_salerButton setTitle:name forState:UIControlStateNormal];
    //
    //    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _startButton.frame = CGRectMake(_salerButton.right + 10, 0, 100, 40);
    //    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    //    [_backView addSubview:_startButton];
    //
    //    //当前日期
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    //    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    //    NSString *dateStr = [dateformatter stringFromDate:date];
    //    [_startButton setTitle:dateStr forState:UIControlStateNormal];
    //    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    //    searchBtn.backgroundColor = [UIColor grayColor];
    //    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    //    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    searchBtn.frame = CGRectMake(KscreenWidth - 80, 0, 60, 40);
    //    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    //    [searchBtn.layer setBorderWidth:0.5]; //边框宽度
    //    [_backView addSubview:searchBtn];
    
    
    //创建地图
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{   [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell_1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (_dataArray.count != 0) {
        CommonModel *model = _dataArray[indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.m_keHuPopView removeFromSuperview];
    CommonModel *model = _dataArray[indexPath.row];
    [_salerButton setTitle:model.name forState:UIControlStateNormal];
    _salerButton.userInteractionEnabled = YES;
    _salerId = model.Id;
    
}


#pragma mark - search方法
- (void)searchWithStarttime:(NSString *)star AndEndTime:(NSString *)end AndSalerID:(NSString *)salerid{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *idEq = [userDefault objectForKey:@"id"];
    idEq = [self convertNull:idEq];
    //    NSString *time = _startButton.titleLabel.text;
    //    time = [self convertNull:time];
    //
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
    NSDictionary *params = @{@"action":@"getSalerTrends",@"flag":@"time",@"table":@"wzgl",@"params":[NSString stringWithFormat:@"{\"ids\":[%@],\"nowdate\":\"%@\",\"begindate\":\"%@\",\"enddate\":\"%@\"}",idEq,@"",star,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"获取该用户所有的经纬度:%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            _array = dic[@"trendsList"];
            if (_array.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该用户暂无路线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 10001;
                [alert show];
            } else if (_array.count > 0){
                
                NSInteger n = _array.count;
                CLLocationCoordinate2D coors[5000] = {0};
                for (int i = 0;i < n;i++) {
                    NSDictionary *dic = _array[i];
                    if ([[NSString stringWithFormat:@"%@",dic[@"latitudeafter"]] isEqualToString:@"(null)"]) {
                        NSString *time = [dic objectForKey:@"rectime"];
                        NSDictionary *dic1 = @{@"latitudeafter":@"36.684336",@"longitudeafter":@"117.077644",@"rectime":time};
                        dic = dic1;
                    }
                    coors[i].latitude = [dic[@"latitudeafter"] floatValue];
                    coors[i].longitude = [dic[@"longitudeafter"] floatValue];
                    
                    if (i == 0) {
                        _coor1.latitude = [dic[@"latitudeafter"] floatValue];
                        _coor1.longitude = [dic[@"longitudeafter"] floatValue];
                    }
                    if (i == n - 1) {
                        _coor2.latitude = [dic[@"latitudeafter"] floatValue];
                        _coor2.longitude = [dic[@"longitudeafter"] floatValue];
                    }
                }
                // 添加折线覆盖物
                BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:n];
                [_mapView addOverlay:polyline];
                NSDictionary *dic2 = _array[0];
                CLLocationCoordinate2D coor;
                coor.latitude = [dic2[@"latitudeafter"] floatValue];
                coor.longitude = [dic2[@"longitudeafter"] floatValue];
                [_mapView setCenterCoordinate:coor];
                _mapView.zoomLevel = 14;
                //标注起点
                BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
                annotation.coordinate = _coor1;
                annotation.title = @"起点";
                [_mapView addAnnotation:annotation];
                //显示标注信息
                [_mapView selectAnnotation:annotation animated:YES];
                //终点
                BMKPointAnnotation* annotation1 = [[BMKPointAnnotation alloc]init];
                annotation1.coordinate = _coor2;
                annotation1.title = @"终点";
                [_mapView addAnnotation:annotation1];
                //显示标注信息
                [_mapView selectAnnotation:annotation1 animated:YES];
            }
        }
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
    
    
    
}

- (void)chongZhi{
    
    [_salerButton setTitle:@"" forState:UIControlStateNormal];
    [_startButton setTitle:@"" forState:UIControlStateNormal];
}


- (void)addNext{
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
    }
    
}
- (void)searchAction{
    
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
    }
    
}



@end

