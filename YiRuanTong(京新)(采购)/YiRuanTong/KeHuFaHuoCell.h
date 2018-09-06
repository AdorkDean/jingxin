//
//  KeHuFaHuoCell.h
//  yiruantong
//
//  Created by lx on 15/3/5.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeHuFaHuoModel.h"
@interface KeHuFaHuoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *keHuMingCheng;
@property (strong, nonatomic) IBOutlet UILabel *faHuoShuLiang;

@property(nonatomic,retain) KeHuFaHuoModel *model;


@end
