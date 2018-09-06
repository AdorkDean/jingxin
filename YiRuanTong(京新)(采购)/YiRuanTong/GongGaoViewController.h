//
//  GongGaoViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface GongGaoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *gongGaoTableView;

@end
