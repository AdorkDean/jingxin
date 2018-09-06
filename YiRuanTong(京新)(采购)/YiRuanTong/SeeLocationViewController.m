//
//  SeeLocationViewController.m
//  YiRuanTong
//
//  Created by lx on 15/4/3.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "SeeLocationViewController.h"
//#import "BMapKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface SeeLocationViewController ()<BMKMapViewDelegate>

{
    BMKMapView *_mapView;
}

@end

@implementation SeeLocationViewController

- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    double a = [self.longtitude doubleValue];
    double b = [self.latitude doubleValue];

    CLLocationCoordinate2D coor;
    coor.latitude = b;
    coor.longitude = a;
    annotation.coordinate = coor;
    annotation.title = @"客户位置";
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:coor];
    _mapView.zoomLevel = 14;
}
- (void)viewWillDisappear:(BOOL)animated
{   [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"客户位置";
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.view = _mapView;
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
