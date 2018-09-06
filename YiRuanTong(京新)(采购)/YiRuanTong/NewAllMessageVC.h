//
//  NewAllMessageVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "GGliulanModel.h"

@interface NewAllMessageVC : BaseViewController<UIScrollViewDelegate>
@property (nonatomic,strong) GGliulanModel *model;
@property (strong, nonatomic) IBOutlet UILabel *m_newTitle;

@property (strong, nonatomic) IBOutlet UILabel *m_newName;

@property (strong, nonatomic) IBOutlet UILabel *m_newTime;

@property (weak, nonatomic) IBOutlet UIWebView *m_newNeiRong;

@end
