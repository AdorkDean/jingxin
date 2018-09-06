//
//  FYBaoXiaoLiuLanCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYModel.h"
@interface FYBaoXiaoLiuLanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *baoXiaoRen;
@property (strong, nonatomic) IBOutlet UILabel *baoXiaoBianHao;
@property (strong, nonatomic) IBOutlet UILabel *baoXiaoType;
@property (strong, nonatomic) IBOutlet UILabel *baoXiaoPrice;
@property (strong, nonatomic) IBOutlet UILabel *baoXiaoDate;
@property (strong, nonatomic) IBOutlet UILabel *baoXiaoStatus;
@property (strong, nonatomic) IBOutlet UILabel *shenPiLabel;
@property (nonatomic,strong)FYModel* model;

@end
