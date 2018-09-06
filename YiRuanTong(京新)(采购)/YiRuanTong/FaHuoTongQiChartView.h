//
//  FaHuoTongQiChartView.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/22.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FaHuoTongQiChartView : BaseViewController<UIScrollViewDelegate>
@property(nonatomic,retain)NSArray *nameData; //名字
@property(nonatomic,retain)NSArray *thisYearData;//今年
@property(nonatomic,retain)NSArray *lastYearData;//去年


@end
