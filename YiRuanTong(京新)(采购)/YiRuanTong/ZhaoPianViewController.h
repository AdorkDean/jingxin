//
//  ZhaoPianViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ZhaoPianViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) NSMutableArray *phtotNameData; // 分类
@property(nonatomic,assign) NSInteger count;

@property(nonatomic,retain) UITableView *ZhaoPianLeiXingTableView;//

@end
