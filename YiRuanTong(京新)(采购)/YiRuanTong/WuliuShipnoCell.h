//
//  WuliuShipnoCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/19.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipnoAndWuliuModel.h"

@interface WuliuShipnoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *shipnoLabel;
@property (strong, nonatomic) IBOutlet UILabel *logistNoLabel;
@property (strong, nonatomic) IBOutlet UIButton *wuliuBtn;
- (IBAction)wuliuBtnClick:(id)sender;

@property (nonatomic,strong)ShipnoAndWuliuModel* model;
@property (nonatomic,strong)void(^transValue)(BOOL isClick);

@end
