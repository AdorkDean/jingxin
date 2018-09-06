//
//  KucunManagerSearchVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KucunManagerSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *cangkuName,NSString *proname,NSString *pici,NSString *prono,NSString *start,NSString *end);
@end
