//
//  KeHuHuiKuanTQVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/10/8.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KeHuHuiKuanTQVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *keHuHuiKuaiTableView;


@property (strong, nonatomic) NSArray *m_keHuHuiKuanArray;

@property (strong, nonatomic) UILabel *m_quNian;
@property (strong, nonatomic) UILabel *m_jinNian;
//
@property(nonatomic,retain) NSMutableArray *DataArray;
@property(nonatomic,retain) NSMutableArray *nameArray;
@property(nonatomic,retain) NSMutableArray *thisYearArray;
@property(nonatomic,retain) NSMutableArray *lastYearArray;



@end
