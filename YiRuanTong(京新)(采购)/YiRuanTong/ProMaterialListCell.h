//
//  ProMaterialListCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProMaterialModel.h"
@interface ProMaterialListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bomnoLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *creattimeLabel;
@property (nonatomic,weak)ProMaterialModel* model;
@end
