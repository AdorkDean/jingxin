//
//  ChaiWuXinXiViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ChaiWuXinXiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong,nonatomic) NSArray * souhouArray;
@property(strong,nonatomic) UIButton *souSuoButton;

@property(nonatomic,retain)UITableView *xianJinTableView;
@property(nonatomic,retain)UITableView *yinHangTableView;
@property(nonatomic,retain)UITableView *yuETableView;

@property (strong, nonatomic) UILabel *xianJinYuE;

@property(nonatomic,retain) UIScrollView *mainScrollView;
@end
