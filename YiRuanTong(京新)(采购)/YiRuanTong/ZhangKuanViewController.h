//
//  ZhangKuanViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
@interface ZhangKuanViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic)UIButton *tianjiaButton;
@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * keHuYFKTableView;
@property(strong,nonatomic) UITableView * yeWuYuanYFKTableView;


@property (strong,nonatomic) NSArray * souhouArray;
@property(strong,nonatomic) UIButton *souSuoButton;

@property (nonatomic) BOOL YESORNO;

@end
