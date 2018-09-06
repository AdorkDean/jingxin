//
//  RiZhiShangBaoViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
@interface RiZhiShangBaoViewController : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@property(strong,nonatomic)NSMutableArray *m_xiangQingDataArray;
@property(strong,nonatomic) NSString *riZhiID;

@property(strong,nonatomic)UIButton *souSuoButton;
@property(strong,nonatomic)NSArray *souhouArry;

@end
