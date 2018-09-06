//
//  ProPlanSearchViewController.h
//  YiRuanTong
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ProPlanSearchViewController : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *orederNo,NSString *start,NSString *end);
@end
