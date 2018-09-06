//
//  PPLiuLanDetailproCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProMsgModel.h"
@interface PPLiuLanDetailproCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *proHeaderLabel;
@property (strong, nonatomic) IBOutlet UIButton *proNameBtn;
- (IBAction)proNameBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *proCountField;//单位
@property (strong, nonatomic) IBOutlet UIButton *proUnitBtn;
- (IBAction)proUnitBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *proPaytypeBtn;
- (IBAction)proPaytypeBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *proSpecLabel;
@property (strong, nonatomic) IBOutlet UILabel *prounitPriceLabel;//需求数量
@property (strong, nonatomic) IBOutlet UILabel *proDiscountedPriceLabel;//可用数量
@property (strong, nonatomic) IBOutlet UILabel *proDiscountedMoneyLabel;//计划数量
@property (strong, nonatomic) IBOutlet UILabel *isSpeed;//是否加急
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (strong,nonatomic) ProMsgModel* model;
@property (strong,nonatomic) NSString* count;
@end
