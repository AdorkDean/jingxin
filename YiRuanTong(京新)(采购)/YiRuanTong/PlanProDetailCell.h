//
//  PlanProDetailCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/12.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanProDetailModel.h"
@interface PlanProDetailCell : UITableViewCell
@property(nonatomic,strong)void(^delBtnBlock)();

@property (strong, nonatomic) IBOutlet UIButton *proname;
@property (strong, nonatomic) IBOutlet UILabel *prospe;
@property (strong, nonatomic) IBOutlet UITextField *prodanwei;
@property (strong, nonatomic) IBOutlet UITextField *plancount;
@property (strong, nonatomic) IBOutlet UITextField *isUrgent;

@property (strong, nonatomic) IBOutlet UITextField *note;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;

@property (nonatomic,strong) PlanProDetailModel *model;
@property (nonatomic,strong) NSString *count;
@end
