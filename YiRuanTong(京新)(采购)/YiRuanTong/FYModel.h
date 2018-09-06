//
//  FYModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/5/25.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYModel : NSObject

@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *applyer;
@property(nonatomic,copy)NSString *applytime;
@property(nonatomic,copy)NSString *reimno;
@property(nonatomic,copy)NSString *spstatus;
@property(nonatomic,copy)NSString *isreim;
@property(nonatomic,copy)NSString *refundmoney;//还款合计
@property(nonatomic,copy)NSString *reimmoney;
@property(nonatomic,copy)NSString *totalnum;   //发票合计
@property(nonatomic,copy)NSString *realapplymon;//实际报销金额
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *applymoney; //金额合计
@property(nonatomic,copy)NSString *spnodename;
@property(nonatomic,copy)NSString* tongji;

@end
