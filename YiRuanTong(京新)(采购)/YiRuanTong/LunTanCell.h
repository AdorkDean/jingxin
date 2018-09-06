//
//  LunTanCell.h
//  yiruantong
//
//  Created by lx on 15/1/29.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTConnectionModel.h"
@interface LunTanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *biaoTi;
@property (strong, nonatomic) IBOutlet UILabel *faBuRen;
@property(nonatomic,retain) LTConnectionModel *model;


@end
