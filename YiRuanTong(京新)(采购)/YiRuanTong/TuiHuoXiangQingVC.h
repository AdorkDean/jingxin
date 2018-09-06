//
//  TuiHuoXiangQingVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "THmanagerModel.h"
@interface TuiHuoXiangQingVC : BaseViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *tuiHuoScrollView;
@property (nonatomic,strong) THmanagerModel *model;

//客户业务员信息
@property(nonatomic,retain)NSArray *xiangQinArray; //产品详情信息

@end

