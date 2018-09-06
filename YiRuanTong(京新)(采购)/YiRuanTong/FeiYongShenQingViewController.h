//
//  FeiYongShenQingViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FeiYongShenQingViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@property(strong,nonatomic)NSMutableArray *m_xiangQingDataArray;

@property(strong,nonatomic)UIButton *souSuoButton;


@end
