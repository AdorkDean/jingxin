//
//  DDLiuLanDetailNewVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/27.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "DDguanliModel.h"
@interface DDLiuLanDetailNewVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UIScrollView *dingDanScrollView; //
@property(nonatomic,retain) UITableView *tbView;
//客户信息

@property (nonatomic,strong) DDguanliModel *model;
@property(nonatomic,retain)NSString *wuliuID;   //物流ID
@property(nonatomic,retain)NSString *chanpinID;   //产品ID
@property(nonatomic,retain)NSString *orderNo;     //订单单号
@property(nonatomic,retain)NSMutableArray *dataArray;          //产品信息
@property(nonatomic,assign)NSInteger spStatus;
@property(nonatomic,strong)NSString *vcType;            //为0的时候是从浏览页面如，为1的时候就是在审批页面进入。

@end
