//
//  QLKucunSearchVC.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface QLKucunSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *stoname,NSString *proname);
@end
