//
//  KaoQinViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface KaoQinViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIWebViewDelegate>

@property(strong,nonatomic)UIButton *returnButton;

@property(strong,nonatomic)UITableView *tabView; // 签到签退
@property(strong,nonatomic)NSDate *date;
@property (strong,nonatomic) UILabel * lab1; //时间
@property (strong,nonatomic) UILabel * lab2; //日期
@property (nonatomic,retain)UILabel *lab3; //星期
@property(strong,nonatomic) NSArray *photoArray; //图片
@property(strong,nonatomic) NSArray *nameArray;  //名字

@property(strong,nonatomic)CLLocationManager * locationManager;

@property(nonatomic)NSString * lblLatitude;
@property(nonatomic)NSString * lblLongitude;



@end
