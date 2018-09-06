//
//  CgInformationSearchVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface CgInformationSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *orederNo,NSString *start,NSString *end);
@end
