//
//  CPFahuoDuiBiChartVC.h
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CPFahuoDuiBiChartVC : BaseViewController<UIScrollViewDelegate>
@property(nonatomic,retain)NSArray *nameData; //名字
@property(nonatomic,retain)NSArray *thisYearData;//今年
@property(nonatomic,retain)NSArray *lastYearData;//去年
@end
