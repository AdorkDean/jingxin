//
//  TuiHuoDetailVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/31.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "THmanagerModel.h"

@interface TuiHuoDetailVC : BaseViewController
@property(nonatomic,retain) UIScrollView *dingDanScrollView; //
@property(nonatomic,retain) UITableView *tbView;
//客户信息

@property (nonatomic,strong) THmanagerModel *model;
@property(nonatomic,retain)NSMutableArray *dataArray;          //产品信息
@property(nonatomic,strong)NSString *vcType;
@end
