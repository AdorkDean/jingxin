//
//  JJAnnotationView.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ArroundModel.h"
@interface JJAnnotationView : BMKPointAnnotation
@property (nonatomic,strong) ArroundModel *model;
@end
