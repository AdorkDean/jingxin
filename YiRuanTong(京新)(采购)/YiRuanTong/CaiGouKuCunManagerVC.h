//
//  CaiGouKuCunManagerVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CaiGouKuCunManagerVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIButton *returnButton;
@property (strong, nonatomic)  UITableView *kuCunTableView;

@end
