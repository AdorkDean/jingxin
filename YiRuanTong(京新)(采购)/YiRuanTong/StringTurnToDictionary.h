//
//  StringTurnToDictionary.h
//  YiRuanTong
//
//  Created by lx on 15/4/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringTurnToDictionary : NSObject

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

@end
