//
//  JingPinTianJiaVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface JingPinTianJiaVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIScrollView *jingPinScrollView;
@property (strong, nonatomic) UIView * listView;

@property(nonatomic,retain)UITableView *provinceTableView;
@property(nonatomic,retain)NSMutableArray *shengArray;

@property(nonatomic,retain)UITableView *cityTableView;
@property(nonatomic,retain)NSMutableArray *shiArray;

@property(nonatomic,retain)UITableView *countyTableView;
@property(nonatomic,retain)NSMutableArray *xianArray;


@end
