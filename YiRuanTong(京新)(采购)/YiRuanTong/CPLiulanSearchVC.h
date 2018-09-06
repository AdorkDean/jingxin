//
//  CPLiulanSearchVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/22.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CPLiulanSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *proid,NSString *proname,NSString *start,NSString *end);
@end
