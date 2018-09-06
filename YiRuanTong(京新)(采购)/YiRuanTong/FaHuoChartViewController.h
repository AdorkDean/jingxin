//
//  FaHuoChartViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FaHuoChartViewController : BaseViewController<UIScrollViewDelegate>

@property(nonatomic,retain)NSArray *countData;//数量
@property(nonatomic,retain)NSArray *moneyData;//金额
@property(nonatomic,retain)NSArray *nameData; //名字


@end
