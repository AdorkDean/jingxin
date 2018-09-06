
//
//  THCpInfoCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/8/13.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPINfoModel.h"
@interface THCpInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *proNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProSpecificationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property(nonatomic,retain) CPINfoModel *model;
@end
