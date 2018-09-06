//
//  KaoQinHistoryModel.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/14.
//  Copyright © 2018年 联祥. All rights reserved.
//


/*
 absentcount = 21;
 depart = "\U7231\U5ba0\U4e1a\U52a1\U5458";
 empid = 278;
 empname = "\U9ec4\U9510";
 latecount = 0;
 leaveearlycount = 0;
 */
#import <Foundation/Foundation.h>

@interface KaoQinHistoryModel : NSObject
@property (nonatomic,copy) NSString *absentcount;
@property (nonatomic,copy) NSString *depart;
@property (nonatomic,copy) NSString *empid;
@property (nonatomic,copy) NSString *empname;
@property (nonatomic,copy) NSString *latecount;
@property (nonatomic,copy) NSString *leaveearlycount;





@end
