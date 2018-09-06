//
//  DingDanSousuoViewController.h
//  YiRuanTong
//
//  Created by apple on 17/7/27.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface DingDanSousuoViewController : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *custId,NSString *salerID,NSString *orederNo,NSString *start,NSString *end);
@end
