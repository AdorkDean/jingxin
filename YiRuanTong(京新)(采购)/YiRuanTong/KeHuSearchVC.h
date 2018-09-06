//
//  KeHuSearchVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface KeHuSearchVC : BaseViewController
//_custId,_accountId,_classId,_tracelevelId,_provinceId,_cityId,_countyId
@property (nonatomic, copy)void(^block)(NSString *custid,NSString *accountId,NSString *classId,NSString *tracelevelId,NSString *provinceId,NSString *cityId,NSString *countyId);

@property(strong,nonatomic)UIButton *tianjiaButton;

@property(strong, nonatomic)UITableView *keHuTableView;

@property(assign,nonatomic) NSInteger Selected;

@property(strong,nonatomic)CLLocationManager * locationManager;
@property(nonatomic,copy) NSString *shoWstr;
@property(nonatomic)NSString * lblLatitude;
@property(nonatomic)NSString * lblLongitude;

//省市县
@property(strong,nonatomic) NSMutableArray *shengArr;
@property(strong,nonatomic) NSMutableArray *shiArr;
@property(strong,nonatomic) NSMutableArray *xianArr;
@property (nonatomic,strong) NSMutableArray *shengIDArr;
@property (nonatomic,strong) NSMutableArray *shiIDArr;
@property (nonatomic,strong) NSMutableArray *xianIDArr;
@end
