//
//  ChanPinFaHuoModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/4/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChanPinFaHuoModel : NSObject
@property(nonatomic,copy)NSString *prono;
@property(nonatomic,copy)NSString *protypename;
@property(nonatomic,copy)NSString *prounitname;
@property(nonatomic,copy)NSString *specification;
@property(nonatomic,copy)NSString *singleprice;
@property(nonatomic,copy)NSString *proname;
@property(nonatomic,copy)NSString *totalcount;
@property(nonatomic,copy)NSString *totalmoney;
@property(nonatomic,copy)NSString *saler;
@property(nonatomic,copy)NSString *salerid;

/*
 proid = 175;
 proname = "C\U6c2f\U5316\U94a0\U6ce8\U5c04\U6db2(0.9\Uff05\U76d0\U6c34\Uff09\U4eac\U65b0";
 prono = P201411110025;
 prounitname = "\U4ef6";
 saler = "\U516c\U53f8\U5ba2\U6237";
 salerid = 146;
 singleprice = 31;
 specification = "500ml\Uff1a4.5g*20\U74f6/\U4ef6\Uff080.9%\U76d0\U6c34\Uff09";
 totalcount = 1904;
 totalmoney = 59024;
 
 
 
 
proname = "P\U6db2\U72b6\U77f3\U8721(\U4eac\U65b0)";
prono = P201411110051;
protypename = "\U53e3\U670d\U6db2";
prounitname = "\U4ef6";
singleprice = 270;
specification = "500ml*30\U74f6/\U4ef6";
totalcount = 270;
totalmoney = 72900;
 */

@end
