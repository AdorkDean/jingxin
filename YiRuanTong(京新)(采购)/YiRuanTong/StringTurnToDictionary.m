//
//  StringTurnToDictionary.m
//  YiRuanTong
//
//  Created by lx on 15/4/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "StringTurnToDictionary.h"

@implementation StringTurnToDictionary

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

@end
