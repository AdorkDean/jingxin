//
//  KHweizhiViewController.m
//  YiRuanTong
//
//  Created by apple on 17/8/17.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "KHweizhiViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "DataPost.h"
#import "KHweizhiModel.h"
#import "MyPositionTableViewCell.h"
@interface KHweizhiViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField *_textfield;
    NSMutableArray *_HttpArray;
    BMKLocationService *_locService;
    BMKPinAnnotationView *newAnnotation;
    CLLocationCoordinate2D _Mylocation;

    int i;
}
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)UITableView *mapTableview;

@end

@implementation KHweizhiViewController
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
- (UITextField *)textfield{
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.frame = CGRectMake(15, 15, KscreenWidth-30, 40);
        [_textfield setFont:[UIFont systemFontOfSize:16.0]];
        [_textfield setTextColor:UIColorFromRGB(0x808080)];
        _textfield.backgroundColor = [UIColor whiteColor];
        [_textfield setBorderStyle:UITextBorderStyleRoundedRect];
        _textfield.textAlignment = NSTextAlignmentLeft;
        _textfield.placeholder = @"请输入搜索的客户";
        _textfield.delegate = self;
        [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_textfield setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return _textfield;
}
- (void)viewDidLoad {
    self.title = @"客户位置";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    i = 0;
    [self DataRequest:@""];
    [self initMap];
}
- (void)initMap{
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.mapView.delegate = self;
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:self.mapView];
    
    //定位
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    //
    [self.view addSubview:self.textfield];

    UIButton *switchBut = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth - 40, KscreenHeight-150, 35, 35)];
    [switchBut setImage:[UIImage imageNamed:@"dingwei-4"] forState:UIControlStateNormal];
    [switchBut addTarget:self action:@selector(switchbut:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:switchBut];
}
- (void)switchbut:(UIButton *)but{
    
    
    [_mapView setCenterCoordinate:_Mylocation];

}
//接口
- (void)DataRequest:(NSString *)name{
    
    _HttpArray = [[NSMutableArray alloc] init];

    //数据接口拼接
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getCustomerPositionList",@"classname":@"",@"name":name};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        //DebugLog(@"返回:%@",array);
        for (NSDictionary *dic in array) {
            KHweizhiModel *model = [[KHweizhiModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_HttpArray addObject:model];
        }
        if ([name isEqualToString:@""]) {
            _mapTableview.hidden = YES;
            [self kehuclassAddress];
        }else{
            [self.mapTableview reloadData];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [tan show];
        }
        
    }];
}


//定位
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _Mylocation = userLocation.location.coordinate;
    i = 0;
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _Mylocation;
    //annotation.title = @"我的位置";
    [_mapView setCenterCoordinate:_Mylocation];
    _mapView.zoomLevel = 18;
    [_mapView addAnnotation:annotation];
    [_mapView selectAnnotation:annotation animated:YES];
    //关闭定位
    [_locService stopUserLocationService];


}
-(void)kehuclassAddress{

    
    for (int y = 0; y<_HttpArray.count; y++) {
        KHweizhiModel *model = _HttpArray[y];
        i = y+1;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D _location;
        _location.latitude = [model.latitudeafter doubleValue];
        _location.longitude = [model.longitudeafter doubleValue];
        annotation.coordinate = _location;
        [_mapView addAnnotation:annotation];
    }
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = [NSString stringWithFormat:@"renameMark%d",i];
    
    newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 设置颜色
    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    //((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
    // 设置可拖拽
    ((BMKPinAnnotationView*)newAnnotation).draggable = YES;

    if (i==0) {
        //设置大头针图标
        ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"datouzhen"];
        
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        //设置弹出气泡图片
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对话框"]];
        image.frame = CGRectMake(0, 0, 80, 40);
        //image.layer.masksToBounds = YES;
        //image.layer.cornerRadius = 5;
        [popView addSubview:image];
        
        UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        driverName.text = @"我的位置";
        driverName.backgroundColor = [UIColor clearColor];
        driverName.font = [UIFont systemFontOfSize:14];
        driverName.textColor = [UIColor whiteColor];
        driverName.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:driverName];
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, 80, 40);
        ((BMKPinAnnotationView*)newAnnotation).paopaoView = nil;
        ((BMKPinAnnotationView*)newAnnotation).paopaoView = pView;
    }else{
        //设置大头针图标
        ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"khweizhi"];
        
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 110)];
        //设置弹出气泡图片
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对话框"]];
        image.frame = CGRectMake(0, 0, 150, 110);
        //image.layer.masksToBounds = YES;
        //image.layer.cornerRadius = 5;
        [popView addSubview:image];
        
        KHweizhiModel *model = _HttpArray[i-1];
        //自定义显示的内容
        UILabel *Name = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 145, 20)];
        Name.text = [NSString stringWithFormat:@"姓名:%@",model.name];
        Name.backgroundColor = [UIColor clearColor];
        Name.font = [UIFont systemFontOfSize:13];
        Name.textColor = [UIColor whiteColor];
        [popView addSubview:Name];
        
        UILabel *classname = [[UILabel alloc]initWithFrame:CGRectMake(3, 25, 145, 20)];
        classname.text = [NSString stringWithFormat:@"类型:%@",model.classname];
        classname.backgroundColor = [UIColor clearColor];
        classname.font = [UIFont systemFontOfSize:13];
        classname.textColor = [UIColor whiteColor];
        [popView addSubview:classname];
        
        UILabel *tracelevel = [[UILabel alloc]initWithFrame:CGRectMake(3, 45, 145, 20)];
        tracelevel.text = [NSString stringWithFormat:@"分类:%@",model.tracelevel];
        tracelevel.backgroundColor = [UIColor clearColor];
        tracelevel.font = [UIFont systemFontOfSize:13];
        tracelevel.textColor = [UIColor whiteColor];
        [popView addSubview:tracelevel];
        
        UILabel *receivercell = [[UILabel alloc]initWithFrame:CGRectMake(3, 65, 145, 20)];
        receivercell.text = [NSString stringWithFormat:@"电话:%@",model.receivercell];
        receivercell.backgroundColor = [UIColor clearColor];
        receivercell.font = [UIFont systemFontOfSize:13];
        receivercell.textColor = [UIColor whiteColor];
        [popView addSubview:receivercell];
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, 150, 90);
        ((BMKPinAnnotationView*)newAnnotation).paopaoView = nil;
        ((BMKPinAnnotationView*)newAnnotation).paopaoView = pView;
        i++;
    }
    return newAnnotation;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //textField放弃第一响应者 （收起键盘）
    //键盘是textField的第一响应者
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"已经停止编辑");
    [self DataRequest:textField.text];
    
}

#pragma mark - uitableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HttpArray.count;
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
        KHweizhiModel *model = _HttpArray[indexPath.row];
        commentCell.namelab.text = model.name;
        commentCell.addresslab.text = [NSString stringWithFormat:@"%@-%@",model.classname,model.tracelevel];
        
    }
    
    
    return commentCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _mapTableview.hidden = YES;

    KHweizhiModel *model = _HttpArray[indexPath.row];
    CLLocationCoordinate2D _location;
    _location.latitude = [model.latitudeafter doubleValue];
    _location.longitude = [model.longitudeafter doubleValue];

    i = (int)indexPath.row + 1;
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _location;
    [_mapView setCenterCoordinate:_location];
    _mapView.zoomLevel = 18;
    [_mapView addAnnotation:annotation];
    [_mapView selectAnnotation:annotation animated:YES];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    self.navigationItem.rightBarButtonItem = nil;

}

- (void)viewWillDisappear:(BOOL)animated
{   [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    //关闭定位
    [_locService stopUserLocationService];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
