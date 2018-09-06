//
//  ProMsgModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/8/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProMsgModel : NSObject

@property(nonatomic,copy) NSString *prono;
//@property(nonatomic,copy) NSString *specification;
@property(nonatomic,copy) NSString *prounitname;
@property(nonatomic,copy) NSString *singleprice;
@property(nonatomic,copy) NSString *maincount;
@property(nonatomic,copy) NSString *totalmoney;
@property(nonatomic,copy) NSString *saletypename;
@property(nonatomic,copy) NSString *stockcount;
@property(nonatomic,copy) NSString *returnrate;
@property(nonatomic,copy) NSString *saledmoney;
@property(nonatomic,copy) NSString *saledprice;



//新增的
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *remaincount;  //数量
@property(nonatomic,copy)NSString *saletype;
@property(nonatomic,copy)NSString *prounitid;
@property(nonatomic,copy)NSString *prounitType;   //主副单位
//@property(nonatomic,copy)NSString *proid;
@property(nonatomic,copy)NSString *addtype;

/*
 freecount = 0;
 id = 292;
 isurgent = 0;
 mainunitid = 206;
 mainunitname = "\U4ef6";
 needcount = 0;
 plancount = 1;
 planid = 139;
 proid = 154;
 proname = "P\U6ce8\U5c04\U7528\U9752\U9709\U7d20\U94a0(400\U4e07\U5355\U4f4d)\U4eac\U65b0";
 pronote = 1;
 specification = "2.4g(400\U4e07\U5355\U4f4d\Uff0940\U74f6/\U76d2/20\U76d2/\U4ef6";
*/
@property(nonatomic,copy)NSString *freecount;
@property(nonatomic,copy)NSString *Id;  //
@property(nonatomic,copy)NSString *isurgent;
@property(nonatomic,copy)NSString *mainunitid;
@property(nonatomic,copy)NSString *mainunitname;
@property(nonatomic,copy)NSString *needcount;
@property(nonatomic,copy)NSString *plancount;
@property(nonatomic,copy)NSString *planid;
@property(nonatomic,copy)NSString *proid;
@property(nonatomic,copy)NSString *proname;
@property(nonatomic,copy)NSString *pronote;
@property(nonatomic,copy) NSString *specification;







@end
