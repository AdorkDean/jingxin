//
//  ProductMaterialSearchVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductMaterialSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *bomno,NSString *planno,NSString *status,NSString *proname);
@end
