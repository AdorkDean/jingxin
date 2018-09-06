//
//  KeHuManagerCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHmanageModel.h"
@interface KeHuManagerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *kehuName;
@property (strong, nonatomic) IBOutlet UILabel *fuzeren;
@property (strong, nonatomic) IBOutlet UILabel *kehuStatus;
@property (strong, nonatomic) IBOutlet UILabel *kehuStyle;
@property (strong, nonatomic) IBOutlet UILabel *xiadanCount;
@property (strong, nonatomic) IBOutlet UILabel *kehuAddress;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;
@property(nonatomic,strong)KHmanageModel * model;
@property (nonatomic,strong)void(^moreBtnBlock)();
@end
