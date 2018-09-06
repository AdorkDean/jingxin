//
//  LunTanXiangQingVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "LTConnectionModel.h"
@interface LunTanXiangQingVC : BaseViewController

@property(strong,nonatomic)UIButton *returnButton;

@property (nonatomic,strong) LTConnectionModel *model;

@property (strong, nonatomic) IBOutlet UILabel *biaoTi;

@property (strong, nonatomic) IBOutlet UILabel *faBuRen;

@property (strong, nonatomic) IBOutlet UILabel *faBuTime;

@property (strong, nonatomic) IBOutlet UILabel *leiXing;

@property (strong, nonatomic) IBOutlet UILabel *neiRong;

@end
