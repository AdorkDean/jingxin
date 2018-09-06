//
//  CgInformationManageVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CgInformationManageVC : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@property (strong,nonatomic) NSArray * souhouArray;
@property (nonatomic) BOOL YESORNO;

@property (strong,nonatomic) NSString * orderNo;
@property (strong,nonatomic) NSString * isNotice;

@end
