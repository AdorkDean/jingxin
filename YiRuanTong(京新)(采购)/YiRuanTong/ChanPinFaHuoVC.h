//
//  ChanPinFaHuoVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ChanPinFaHuoVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *chanPinFaHuoTableView;



@property (strong, nonatomic) UILabel *zongShuLiang2;
@property (strong, nonatomic) UILabel *zongJinE2;
//
@property(nonatomic,retain)NSMutableArray *DataArray;
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *countArray;
@property(nonatomic,retain)NSMutableArray *moneyArray;

@end
