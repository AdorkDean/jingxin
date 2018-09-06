//
//  AppDelegate.h
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BMapKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "BNCoreServices.h"
static NSString *appKey = @"d53e3435c6a9f0a26f692637";
static NSString *channel = @"Publish channel";
//static BOOL isProduction = FALSE;
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *lblLongitude;
@property (nonatomic,strong) NSString *lblLatitude;

@end

