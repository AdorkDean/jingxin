//
//  ZiDingYiSPdetailVC.h
//  YiRuanTong
//
//  Created by lx on 15/5/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "ZiDingYiSPModel.h"
@interface ZiDingYiSPdetailVC : BaseViewController

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) ZiDingYiSPModel *model;
@property (nonatomic,strong) UIView *m_keHuPopView;
@property (nonatomic,strong) UITableView *tableView;

@end
