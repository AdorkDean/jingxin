//
//  ChanPinXiaoShouVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ChanPinXiaoShouVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *chanPinTableView;
@property (strong, nonatomic) UILabel *zongShuLiang2;
@property (strong, nonatomic) UILabel *zongJinE2;

//
@property(nonatomic,retain) NSMutableArray *DataArray; //
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *countArray;
@property(nonatomic,retain)NSMutableArray *moneyArray;


@end
