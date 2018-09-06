//
//  ProFinishModel.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProFinishModel : NSObject
@property (nonatomic,strong)NSString* mainunitid;
@property (nonatomic,strong)NSString* mtbatch;
@property (nonatomic,strong)NSString* mtcontent;
@property (nonatomic,strong)NSString* mtfreecount;
@property (nonatomic,strong)NSString* mtid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* mtname;
@property (nonatomic,strong)NSString* mtneedcount;
@property (nonatomic,strong)NSString* mtnormcount;
@property (nonatomic,strong)NSString* mtsize;
@property (nonatomic,strong)NSString* mtstockcount;
@property (nonatomic,strong)NSString* mtunitid;
@property (nonatomic,strong)NSString* mtunitname;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* producedate;
@property (nonatomic,strong)NSString* singleprice;
@property (nonatomic,strong)NSString* soid;
@property (nonatomic,strong)NSString* storageid;
@property (nonatomic,strong)NSString* storagename;
@property (nonatomic,strong)NSString* validtime;


@property (nonatomic,strong)NSString* mtcount;
@property (nonatomic,strong)NSString* mtno;
@property (nonatomic,strong)NSString* mtprice;
@property (nonatomic,strong)NSString* name;
//自己计算的
@property (nonatomic,strong)NSString* plancount;

/*
 id = 2;
 mtcount = 1;
 mtno = WL201807030001;
 mtprice = 100;
 mtsize = 4545;
 mtunitid = 241;
 mtunitname = "\U5428";
 name = "\U560e\U5566\U6cb9";
*/
@end
