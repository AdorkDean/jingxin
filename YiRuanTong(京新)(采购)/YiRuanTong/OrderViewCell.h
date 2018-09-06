//
//  OrderViewCell.h
//  YiRuanTong
//
//  Created by 联祥 on 16/4/5.
//  Copyright © 2016年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderViewCell : UITableViewCell
@property(nonatomic,retain)UILabel *titleLabel;        //产品信息标题
@property(nonatomic,retain)UILabel *proCodeLabel;           //产品编码
@property(nonatomic,retain)UILabel *specLabel;         //产品规格
@property(nonatomic,retain)UILabel *priceLabel;        //单价
@property(nonatomic,retain)UILabel *moneyLabel;        //金额
@property(nonatomic,retain)UILabel *rateMoneyLabel;    //产品规格


@property(nonatomic,retain)OrderModel *model;


@end
