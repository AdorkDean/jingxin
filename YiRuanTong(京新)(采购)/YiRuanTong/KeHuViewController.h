//
//  KeHuViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface KeHuViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

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
