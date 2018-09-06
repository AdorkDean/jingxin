//
//  SHHFMOdel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHHFMOdel : NSObject
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *custname;
@property(nonatomic,copy)NSString *repairname;
@property(nonatomic,copy)NSString *repairdate;
@property(nonatomic,copy)NSString *visitorname; //回访人员
@property(nonatomic,copy)NSString *telno;
@property(nonatomic,copy)NSString *servicelevelname; //服务等级
@property(nonatomic,copy)NSString *repairsituation;
@property(nonatomic,copy)NSString *note;
@end
