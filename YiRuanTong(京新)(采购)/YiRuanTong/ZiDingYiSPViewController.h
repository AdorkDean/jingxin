//
//  ZiDingYiSPViewController.h
//  YiRuanTong
//
//  Created by lx on 15/5/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ZiDingYiSPViewController : BaseViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@property(strong,nonatomic)NSMutableArray *m_xiangQingDataArray;
@property(strong,nonatomic) NSString *riZhiID;

@property(strong,nonatomic)UIButton *souSuoButton;

@end
