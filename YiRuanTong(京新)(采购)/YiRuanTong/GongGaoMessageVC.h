//
//  GongGaoMessageVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "GGliulanModel.h"

@interface GongGaoMessageVC : BaseViewController

@property (nonatomic,strong) GGliulanModel *model;
@property (strong, nonatomic) IBOutlet UILabel *gongGaoTitle;

@property (strong, nonatomic) IBOutlet UILabel *gongGaoName;

@property (strong, nonatomic) IBOutlet UILabel *gongGaoTime;
@property (weak, nonatomic) IBOutlet UIWebView *gongGaoNeiRong;


@end
