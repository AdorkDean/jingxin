//
//  ProStoreListModel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseModel.h"

@interface ProStoreListModel : BaseModel
@property (nonatomic,strong)NSString* bomno;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* creator;
@property (nonatomic,strong)NSString* creatorid;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isstockout;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* mainunitid;
@property (nonatomic,strong)NSString* mainunitname;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* pickinglistid;
@property (nonatomic,strong)NSString* plancount;
@property (nonatomic,strong)NSString* planno;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* sono;
@property (nonatomic,strong)NSString* specification;
@property (nonatomic,strong)NSString* spnodename;
@property (nonatomic,strong)NSString* spstatus;
@property (nonatomic,strong)NSString* stopreason;
/*
 bomno = BM201807100002;
 createtime = "2018-07-10 09:55:31";
 creator = cs1;
 creatorid = 236;
 id = 83;
 isstockout = 0;
 isvalid = 1;
 mainunitid = 0;
 mainunitname = "\U4ef6";
 note = 1;
 pickinglistid = 106;
 plancount = 1;
 planno = SJ201807100001;
 proid = 152;
 proname = "\U6ce8\U5c04\U7528\U9752\U9709\U7d20\U94a0(160\U4e07\U5355\U4f4d)\U4eac\U65b0";
 sono = SK201807100001;
 specification = "0.96g\Uff08160\U4e07\U5355\U4f4d\Uff0950\U74f6/\U76d2/20\U76d2/\U4ef6";
 spnodename = "\U5ba1\U6279\U7ed3\U675f";
 spstatus = 1;
 stopreason = "";
 */
@end
