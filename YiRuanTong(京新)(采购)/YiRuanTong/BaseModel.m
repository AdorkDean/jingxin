//
//  BaseModel.m
//  YiRuanTong
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
//-(id)valueForUndefinedKey:(NSString *)key
//{
//    return nil;
//}
//有些属性 为空了我后续用到经常会崩溃 下面这个方法把<null>转为空字符串

-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:keyedValues];
    
    NSArray *valueArray= [dic allKeys];
    
    for (NSString *key in valueArray) {
        
        if ([[dic objectForKey:key]isEqual:[NSNull null]]) {
            
            [dic setObject:@" " forKey:key];
    
        }else if ([[dic objectForKey:key]isKindOfClass:[NSNull class]]){
            
            [dic setObject:@" " forKey:key];
            
        }else if ([dic objectForKey:key] == nil){
            
            [dic setObject:@" " forKey:key];
            
        }
        
    }
    
    [super setValuesForKeysWithDictionary:dic];
    
}
@end
