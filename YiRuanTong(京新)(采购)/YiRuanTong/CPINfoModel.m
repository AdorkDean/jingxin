//
//  CPINfoModel.m
//  YiRuanTong
//
//  Created by lx on 15/4/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "CPINfoModel.h"

@implementation CPINfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"typeid"]){
        self.typeId = value;
    }
    if([key isEqualToString:@"typename"]){
        self.typeName = value;
    }
}
@end
