//
//  BaiDuMapViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
//#import "BMapKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface BaiDuMapViewController : BaseViewController<BMKMapViewDelegate>

@property(nonatomic,strong)BMKMapView *mapView;

@end
