//
//  DingDanViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface DingDanViewController : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@property (strong,nonatomic) NSArray * souhouArray;
@property (nonatomic) BOOL YESORNO;

@property (strong,nonatomic) NSString * orderNo;
@property (strong,nonatomic) NSString * isNotice;
@end
