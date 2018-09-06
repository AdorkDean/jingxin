//
//  CPINfoModel.h
//  YiRuanTong
//
//  Created by lx on 15/4/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPINfoModel : NSObject
@property (nonatomic,copy) NSString *proname;       //产品名称
@property (nonatomic,copy) NSString *prono;         //产品编码
@property (nonatomic,copy) NSString *specification; //规格
@property (nonatomic,copy) NSString *proprice;
@property (nonatomic,copy) NSString *maincount;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *returnrate;
@property (nonatomic,copy) NSString *freecount;

@property (nonatomic,copy) NSString *acctype;
@property (nonatomic,copy) NSString *fileurl;   //图片地址
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *mainunit;   //主单位
@property (nonatomic,copy) NSString *mainunitid; //主单位ID
@property (nonatomic,copy) NSString *weightunit;

@property(nonatomic,copy) NSString *sendno;  //发货单号
@property(nonatomic,copy) NSString *prounitname; //产品单位
@property(nonatomic,copy) NSString *singleprice; //单价
@property(nonatomic,copy) NSString *probatch;    //产品批号
@property(nonatomic,copy) NSString *remaincount; //发货数量
@property(nonatomic,copy) NSString *saledprice;
@property(nonatomic,copy) NSString *proid;       //产品
@property(nonatomic,copy) NSString *totalmoney;
@property(nonatomic,copy) NSString *saledmoney;

@property(nonatomic,copy) NSString *inserttime;
@property(nonatomic,copy) NSString *materialsno;
@property(nonatomic,copy) NSString *measureunit;
@property(nonatomic,copy) NSString *measureunitid;
@property(nonatomic,copy) NSString *mainunitname;

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *size;
@property(nonatomic,copy) NSString *typeName;
@property(nonatomic,copy) NSString *typeId;
@end
