//
//  QLXiaoShouHuiZongCell.h
//  YiRuanTong
//
//  Created by LONG on 2018/5/2.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustSaleModel.h"
@interface QLXiaoShouHuiZongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *proname;
@property (weak, nonatomic) IBOutlet UILabel *custname;
@property (weak, nonatomic) IBOutlet UILabel *singePrice;
@property (weak, nonatomic) IBOutlet UILabel *danwei;
@property (weak, nonatomic) IBOutlet UILabel *guige;
@property (weak, nonatomic) IBOutlet UILabel *totalcount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *sendtime;



@property(nonatomic,retain) CustSaleModel *model;
@end
