//
//  CustomerServiceModel.h
//  YiRuanTong
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerServiceModel : BaseModel
@property (nonatomic,strong)NSString* creator;
@property (nonatomic,strong)NSString* creatorid;
@property (nonatomic,strong)NSString* dealcreator;
@property (nonatomic,strong)NSString* dealcreatorid;
@property (nonatomic,strong)NSString* dealresult;
@property (nonatomic,strong)NSString* dealtime;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isdeal;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* question;
@property (nonatomic,strong)NSString* submittime;
/*
 creator = 3232;
 creatorid = 22;
 dealcreator = cs1;
 dealcreatorid = 236;
 dealresult = "<null>";
 dealtime = "2018-08-08 17:15:54";
 id = 1;
 isdeal = 0;
 isvalid = 1;
 question = 434343434;
 submittime = "2018-08-08 16:24:21";
 */
@end
