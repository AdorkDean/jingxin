//
//  TuiHuosousuoViewController.h
//  YiRuanTong
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface TuiHuosousuoViewController : BaseViewController
@property (nonatomic, copy)void(^tuihuoblock)(NSString *custId,NSString *salerID,NSString *create1,NSString *create2,NSString *sp);

@end
