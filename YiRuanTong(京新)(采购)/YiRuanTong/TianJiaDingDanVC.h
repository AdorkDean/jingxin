//
//  TianJiaDingDanVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface TianJiaDingDanVC : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (strong, nonatomic) UIScrollView *dingDanAddScrollView;

@property (strong, nonatomic) UIView * m_keHuPopView;

@property (strong, nonatomic) UITableView * tableView;

@property(strong,nonatomic) NSDictionary *custInfo;
@property (nonatomic,strong) NSArray *yewuYuanArr;
@property(strong,nonatomic) NSString *keHuID;
@property(strong,nonatomic) NSString *custid;
@property(strong,nonatomic) NSArray *m_wuLiuArr;
@property(strong,nonatomic) NSArray *wuLiuArr;
@property(strong,nonatomic) NSString *wuLiuID;
@property(strong,nonatomic) NSArray *m_chanPinArr;
//客户信息



@end
