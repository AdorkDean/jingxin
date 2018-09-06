//
//  BaoBiaoTongJiViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface BaoBiaoTongJiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIButton *returnButton;

@property (strong, nonatomic) UITableView *baoBiaoTableView;
@property (strong, nonatomic) NSArray *m_baoBiaoArray;


@end
