//
//  FYBXDetailModel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseModel.h"

@interface FYBXDetailModel : BaseModel
@property (nonatomic,strong)NSString* costtype;
@property (nonatomic,strong)NSString* costtypeid;
@property (nonatomic,strong)NSString* singelnum;
@property (nonatomic,strong)NSString* singlemoney;
@property (nonatomic,strong)NSString* applymon;
@property (nonatomic,strong)NSString* costcause;
@property (nonatomic,strong)NSString* costreimid;
@property (nonatomic,strong)NSString* Id;

/*
 applymon = 88;
 costcause = "";
 costreimid = 24;
 costtype = "\U4f4f\U5bbf";
 costtypeid = 151;
 id = 31;
 singelnum = 33;
 singlemoney = 0;
 */
@end
