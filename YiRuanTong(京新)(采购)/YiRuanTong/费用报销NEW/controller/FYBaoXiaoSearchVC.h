//
//  FYBaoXiaoSearchVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FYBaoXiaoSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *orederNo,NSString *start,NSString *end);
@end
