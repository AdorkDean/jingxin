//
//  ProPlanLiuLanVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "ProPlanListModel.h"
@interface ProPlanLiuLanVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UIScrollView *dingDanScrollView; //
@property(nonatomic,retain) UITableView *tbView;
//客户信息

@property (nonatomic,strong) ProPlanListModel *model;
@property(nonatomic,retain)NSString *wuliuID;   //物流ID
@property(nonatomic,retain)NSString *chanpinID;   //产品ID
@property(nonatomic,retain)NSString *orderNo;     //订单单号
@property(nonatomic,retain)NSMutableArray *dataArray;          //产品信息
@property(nonatomic,assign)NSInteger spStatus;
@property(nonatomic,strong)NSString *vcType;            //为0的时候是从浏览页面如，为1的时候就是在审批页面进入。

@end
