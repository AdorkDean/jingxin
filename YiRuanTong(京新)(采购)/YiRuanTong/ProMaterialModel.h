//
//  ProMaterialModel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseModel.h"

@interface ProMaterialModel : BaseModel
@property (nonatomic,strong)NSString* bomno;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* creator;
@property (nonatomic,strong)NSString* creatorid;
@property (nonatomic,strong)NSString* flag;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isstockout;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* mainunitid;
@property (nonatomic,strong)NSString* mainunitname;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* plancount;
@property (nonatomic,strong)NSString* planno;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* prostatus;
@property (nonatomic,strong)NSString* specification;
//搜索中新增
@property (nonatomic,strong)NSString* name;
/*{
 bomno = BM201807110004;
 createtime = "2018-07-11 10:18:42";
 creator = cs1;
 creatorid = 236;
 flag = 0;
 id = 111;
 isstockout = 0;
 isvalid = 1;
 mainunitid = 206;
 mainunitname = "\U4ef6";
 note = 1;
 plancount = 1;
 planno = SJ201807110001;
 proid = 154;
 proname = "P\U6ce8\U5c04\U7528\U9752\U9709\U7d20\U94a0(400\U4e07\U5355\U4f4d)\U4eac\U65b0";
 prostatus = 0;
 specification = "2.4g(400\U4e07\U5355\U4f4d\Uff0940\U74f6/\U76d2/20\U76d2/\U4ef6";
 }*/
@end
