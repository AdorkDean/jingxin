//
//  KCcheckModel.h
//  YiRuanTong
//
//  Created by lx on 15/4/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCcheckModel : NSObject

@property (nonatomic,copy) NSString *storagename;
@property (nonatomic,copy) NSString *proname;
@property (nonatomic,copy) NSString *totalcount;

@property (nonatomic,copy) NSString *singleprice;
@property (nonatomic,copy) NSString *probatch;    // 批次
@property (nonatomic,copy) NSString *prono;
@property (nonatomic,copy) NSString *specification;
@property (nonatomic,copy) NSString *prounitname;
@property (nonatomic,copy) NSString *validtime;
@property (nonatomic,copy) NSString *producedate;//生产日期
@property (nonatomic,copy) NSString *totalmoney;
@property (nonatomic,copy) NSString *instocktime;
//主副单位数量
@property (nonatomic,copy) NSString *zhudanwei;
@property (nonatomic,copy) NSString *zhudanweishuliang;
@property (nonatomic,copy) NSString *fudanwei;
@property (nonatomic,copy) NSString *fudanweishuliang;



@end
