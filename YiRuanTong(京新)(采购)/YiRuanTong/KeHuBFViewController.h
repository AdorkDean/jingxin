//
//  KeHuBFViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KeHuBFViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIButton *tianjiaButton;
@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic)UITableView *liuLanTableView;
@property(strong,nonatomic)UITableView *shenPiTableView;

@property (strong,nonatomic) NSArray * souhouArray;
@property(strong,nonatomic) UIButton *souSuoButton;

@property (nonatomic) BOOL YESORNO;

@end
/*
 action:"getBeans"
 table:"khxx"
 page:"1"
 rows:"20"
 params:"{"table":"khxx","nameLIKE":"陈小健","principalLIKE":"贾雨萌","departnameLIKE":"","linkerLIKE":"","isteamworkEQ":"","typenameLIKE":"门市销售","classnameLIKE":"往来客户","tracelevelLIKE":"A级客户","telnoLIKE":"","isvalidEQ":"1"}"
 
 */