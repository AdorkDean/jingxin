//
//  WuliuDetailModel.h
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/20.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WuliuDetailModel : NSObject
@property (nonatomic,strong)NSString* EBusinessID;
@property (nonatomic,strong)NSString* ShipperCode;
@property (nonatomic,strong)NSString* Success;
@property (nonatomic,strong)NSString* LogisticCode;
@property (nonatomic,strong)NSString* State;
@property (nonatomic,assign)NSArray* Traces;
@property (nonatomic,strong)NSString* Reason;

@end

@interface WuliuDetailTracesModel : NSObject
@property (nonatomic,strong)NSString* AcceptStation;
@property (nonatomic,strong)NSString* AcceptTime;
@property (nonatomic,strong)NSString* Remark;
@end

