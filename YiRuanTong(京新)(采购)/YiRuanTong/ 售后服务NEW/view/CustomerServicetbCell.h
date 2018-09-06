//
//  CustomerServicetbCell.h
//  YiRuanTong
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerServiceModel.h"
@interface CustomerServicetbCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;

@property (nonatomic,strong)CustomerServiceModel* model;
@end
