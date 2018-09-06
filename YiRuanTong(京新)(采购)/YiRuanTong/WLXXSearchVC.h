//
//  WLXXSearchVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface WLXXSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *proid,NSString *proname,NSString *start,NSString *end);
@end
