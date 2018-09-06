//
//  DDLiuLanDetailproCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/28.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProMsgModel.h"

@interface DDLiuLanDetailproCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *proHeaderLabel;
@property (strong, nonatomic) IBOutlet UIButton *proNameBtn;
- (IBAction)proNameBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *proCountField;
@property (strong, nonatomic) IBOutlet UIButton *proUnitBtn;
- (IBAction)proUnitBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *proPaytypeBtn;
- (IBAction)proPaytypeBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *proSpecLabel;
@property (strong, nonatomic) IBOutlet UILabel *prounitPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *proDiscountedPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *proDiscountedMoneyLabel;
@property (strong,nonatomic) ProMsgModel* model;
@property (strong,nonatomic) NSString* count;
@end
