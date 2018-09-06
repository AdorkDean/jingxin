//
//  PPLiuLanCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProPlanListModel.h"
@interface PPLiuLanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *proNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *proNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *proDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *spStatus;
@property (weak, nonatomic) IBOutlet UILabel *isbomLabel;
@property (weak, nonatomic) IBOutlet UILabel *isexportLabel;
- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong)void(^transValue)(BOOL isClick,NSString* orderID);
@property(nonatomic,retain)ProPlanListModel *model;
@end
