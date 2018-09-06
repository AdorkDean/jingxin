//
//  IsNumberOrNot.m
//  YiRuanTong
//
//  Created by lx on 15/3/30.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "IsNumberOrNot.h"

@implementation IsNumberOrNot

+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
@end
