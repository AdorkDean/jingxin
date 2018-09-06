//
//  JingPinViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface JingPinViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *jingPinTableView;

@property(strong,nonatomic)UIButton *tianjiaButton;
@property(strong,nonatomic)UIButton *returnButton;


@end
