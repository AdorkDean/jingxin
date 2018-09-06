//
//  ShangBaoVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ShangBaoVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) NSArray *leiXingDataArray;
@property(strong,nonatomic) UIView *leiXingPopView;
@property(strong,nonatomic) UITableView *tableView;

@property(assign,nonatomic) NSInteger nameID;

@end
