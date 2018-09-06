//
//  CgApplyVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CgApplyVC : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


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

@end
