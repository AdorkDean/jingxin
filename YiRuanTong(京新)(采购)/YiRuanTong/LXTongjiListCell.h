//
//  LXTongjiListCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/7.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TongjiModel.h"
@interface LXTongjiListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *shibao;
@property (strong, nonatomic) IBOutlet UILabel *quebao;
@property (strong, nonatomic) IBOutlet UILabel *yingbao;

@property (strong, nonatomic) IBOutlet UIButton *sacnBtn;
@property (nonatomic,strong)void(^scanBtnBlock)();
@property (strong, nonatomic) TongjiModel *model;
@end
