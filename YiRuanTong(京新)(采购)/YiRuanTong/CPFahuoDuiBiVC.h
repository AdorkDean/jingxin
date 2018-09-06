//
//  CPFahuoDuiBiVC.h
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CPFahuoDuiBiVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

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
