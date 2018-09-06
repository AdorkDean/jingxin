//
//  XiaoShouFahuoVC.h
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface XiaoShouFahuoVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *chanPinFaHuoTableView;



@property (strong, nonatomic) UILabel *zongShuLiang2;
@property (strong, nonatomic) UILabel *zongJinE2;
//
@property(nonatomic,retain)NSMutableArray *DataArray;
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *countArray;
@property(nonatomic,retain)NSMutableArray *moneyArray;
@end
