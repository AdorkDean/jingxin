//
//  ZhouBianViewController.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "BNCoreServices.h"
@interface ZhouBianViewController : BaseViewController<BMKMapViewDelegate,BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>{
    CLLocationCoordinate2D _myLoc;
}
@property(nonatomic,assign)CLLocationCoordinate2D myLoc;

@end
