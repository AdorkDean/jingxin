//
//  FYShenQingDetailVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "FYSQModel.h"

@interface FYShenQingDetailVC : BaseViewController
<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UIScrollView *dingDanScrollView; //
@property(nonatomic,retain) UITableView *tbView;
@property(nonatomic,retain)NSMutableArray *dataArray;          //产品信息
@property (nonatomic,strong)FYSQModel* model;
@property (nonatomic,strong)NSString* chanpinID;
@property(nonatomic,strong)NSString *vcType;            //为0的时候是从浏览页面如，为1的时候就是在审批页面进入。
@end
