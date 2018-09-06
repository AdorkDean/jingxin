//
//  ProStoreSearchVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ProStoreSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *bomno,NSString* sono,NSString *planno,NSString *status,NSString *proname,NSString* creator);
@end
