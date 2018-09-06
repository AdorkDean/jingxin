//
//  ProPlanListModel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ProPlanListModel : BaseModel
@property (nonatomic,copy) NSString *creator;       //计划制定人
@property (nonatomic,copy) NSString *creatorid;       //
@property (nonatomic,copy) NSString *freecount;       //
@property (nonatomic,copy) NSString *Id;       //
@property (nonatomic,copy) NSString *inserttime;       // 创建时间
@property (nonatomic,copy) NSString *iscreatedbom;       //是否生成bom单
@property (nonatomic,copy) NSString *isurgent;       // 是否加急
@property (nonatomic,copy) NSString *isvalid;       // 是否有效
@property (nonatomic,copy) NSString *mainunitid;       // 单位ID
@property (nonatomic,copy) NSString *mainunitname;       // 单位
@property (nonatomic,copy) NSString *needcount;       //
@property (nonatomic,copy) NSString *note;       //
@property (nonatomic,copy) NSString *plancount;     //计划生产数量
@property (nonatomic,copy) NSString *planno;        //生产计划单号
@property (nonatomic,copy) NSString *plantime;      //计划日期
@property (nonatomic,copy) NSString *proid;
@property (nonatomic,copy) NSString *proname;   //产品名称
@property (nonatomic,copy) NSString *pronote;   //备注
@property (nonatomic,copy) NSString *prostatus; //生产状态是否生产入库
@property (nonatomic,copy) NSString *specification;     //规格
@property (nonatomic,copy) NSString *spnodename;
@property (nonatomic,copy) NSString *spstatus;      //审核状态
/*
 creator = lx02;
 creatorid = 198;
 freecount = 0;
 id = 128;
 inserttime = "2018-07-09 09:56:38";
 iscreatedbom = 1;
 isurgent = 1;
 isvalid = 1;
 mainunitid = 206;
 mainunitname = "\U4ef6";
 needcount = 0;
 note = "";
 plancount = 3;
 planno = SJ201807090001;
 plantime = "2018-07-09 00:00:00";
 proid = 388;
 proname = "J\U6bd2\U75e2\U505c";
 pronote = "";
 prostatus = 0;
 specification = "100g*200\U888b/\U4ef6";
 spnodename = "\U5ba1\U6279\U7ed3\U675f";
 spstatus = 1;
 */
@end
