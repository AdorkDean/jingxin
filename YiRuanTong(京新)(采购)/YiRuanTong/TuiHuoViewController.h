//
//  TuiHuoViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface TuiHuoViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIButton *souSuoButton;
@property(strong,nonatomic) UILabel *m_keHuID;
@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic) UITableView *liuLanTableView;
@property (strong,nonatomic)UITableView *shenPiTableView;

@property (strong,nonatomic) NSArray * souhouArray;
@property (nonatomic) BOOL YESORNO;


@end
