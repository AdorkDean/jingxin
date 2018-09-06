//
//  ChanPinFahuoSearchVC.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/4/27.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ChanPinFahuoSearchVC : BaseViewController
@property (nonatomic, copy)void(^block)(NSString *proid,NSString *proname,NSString *start,NSString *end);
//@property (nonatomic,strong)void(^searchProListBlcok)(NSDictionary * resultDic);
@end
