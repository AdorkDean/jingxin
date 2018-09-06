//
//  KeHuFaHuoDuiBiVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KeHuFaHuoDuiBiVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *KeHuFaHuoTableView;


@property (strong, nonatomic) UILabel *m_quNian;
@property (strong, nonatomic) UILabel *m_jinNian;


//@property (strong, nonatomic) NSString *dangQianRiQi;
//@property (strong, nonatomic) NSString *guoQuRiQi;
//
@property(nonatomic,retain)NSMutableArray *DataArray;
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *thisYearArray;
@property(nonatomic,retain)NSMutableArray *lastYearArray;


@end
