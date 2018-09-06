//
//  KQLiShiViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/16.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface KQLiShiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIButton *returnButton;
@property (strong, nonatomic) UITableView *kaoQinTableView;

@end
