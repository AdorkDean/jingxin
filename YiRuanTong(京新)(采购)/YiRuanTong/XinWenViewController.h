//
//  XinWenViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface XinWenViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *XinWenTableView; //
@property(strong,nonatomic)UIButton *returnButton;

@end
