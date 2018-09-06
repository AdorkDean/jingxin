//
//  KHCPXiaoShouVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KHCPXiaoShouVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *CustSaleTableView;



@property(strong,nonatomic)UILabel *zongShuLiang2;
@property(strong,nonatomic)UILabel *zongJinE2;
@property(nonatomic,retain)NSMutableArray *faHuoData;
@property(nonatomic,retain)NSMutableArray *faHuoShuData;
@property(nonatomic,retain)NSMutableArray *faHuoJinEData;
@property(nonatomic,retain)NSMutableArray *faHuoRenData;

@end
