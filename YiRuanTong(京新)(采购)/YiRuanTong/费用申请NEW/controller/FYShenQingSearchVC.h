//
//  FYShenQingSearchVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FYShenQingSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *orederNo,NSString *applytype,NSString *spEQ,NSString *start,NSString *end);
@property (nonatomic,strong)NSString* vctype;//区分从浏览页面和审批页面；
@end
