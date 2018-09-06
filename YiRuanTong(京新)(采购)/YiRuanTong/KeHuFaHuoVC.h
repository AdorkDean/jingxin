//
//  KeHuFaHuoVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KeHuFaHuoVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *faHuoTableView;



@property(strong,nonatomic)UILabel *zongShuLiang2;
@property(strong,nonatomic)UILabel *zongJinE2;
@property(nonatomic,retain)NSMutableArray *faHuoData;
@property(nonatomic,retain)NSMutableArray *faHuoShuData;
@property(nonatomic,retain)NSMutableArray *faHuoJinEData;
@property(nonatomic,retain)NSMutableArray *faHuoRenData;

@end
