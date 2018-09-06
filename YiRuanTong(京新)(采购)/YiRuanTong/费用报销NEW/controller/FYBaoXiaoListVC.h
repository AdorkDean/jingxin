//
//  FYBaoXiaoListVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FYBaoXiaoListVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@property(strong,nonatomic)NSMutableArray *m_xiangQingDataArray;

@property(strong,nonatomic)UIButton *souSuoButton;


@end
