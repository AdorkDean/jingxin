//
//  TuiHuoShenPiVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/15.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "THmanagerModel.h"
@interface TuiHuoShenPiVC : BaseViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *shenPiScrollView;

 //客户业务员信息
@property (nonatomic,strong) THmanagerModel *model;
@property(nonatomic,retain)NSArray *xiangQinArray; //产品详情信息

@property (nonatomic,strong) UIView *m_keHuPopView;
@property (nonatomic,strong) UITableView *tableView;

@end
