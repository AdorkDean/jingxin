//
//  ProStoreDetailModel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseModel.h"

@interface ProStoreDetailModel : BaseModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* mainunitid;
@property (nonatomic,strong)NSString* mtbatch;
@property (nonatomic,strong)NSString* mtcontent;
@property (nonatomic,strong)NSString* mtfreecount;//可用库存
@property (nonatomic,strong)NSString* mtid;
@property (nonatomic,strong)NSString* mtname;//物料名称
@property (nonatomic,strong)NSString* mtneedcount;//需求量
@property (nonatomic,strong)NSString* mtnormcount;
@property (nonatomic,strong)NSString* mtsize;//编码
@property (nonatomic,strong)NSString* mtunitname;//单位
@property (nonatomic,strong)NSString* storagename;//仓库名称
@property (nonatomic,strong)NSString* mtstockcount;//实际库存

/*
 {
 id = 275;
 mainunitid = 0;
 mtbatch = 3;
 mtcontent = "";
 mtfreecount = 2;
 mtid = 1;
 mtname = "\U6d4b\U8bd5\U7269\U6599";
 mtneedcount = 0;
 mtnormcount = 1;
 mtsize = 32323;
 mtstockcount = 2;
 mtunitid = 241;
 mtunitname = "\U5428";
 note = "";
 producedate = "2018-07-02 09:35:22";
 singleprice = 122;
 soid = 93;
 storageid = 47;
 storagename = "\U6210\U54c1\U4e8c\U5e93";
 validtime = "1900-01-01 00:00:00";
 }
 */
@end
