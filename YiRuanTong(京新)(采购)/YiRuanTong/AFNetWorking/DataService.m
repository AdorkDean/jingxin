//
//  DataService.m
//  weibo
//
//  Created by zsm on 14-11-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "DataService.h"
@implementation DataService

+ (AFHTTPRequestOperation *)requestAFWithUrl:(NSString *)urlString
                                      params:(NSMutableDictionary *)params
                                reqestHeader:(NSDictionary *)headerDic
                                  httpMethod:(NSString *)httpMethod
                              finishDidBlock:(FinishDidBlock)finishDidBlock
                                failureBlock:(FailureBlock)failureBlock
{
    // 拼接路径
    // 获取令牌
        // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    // 2.添加请求头
    for (NSString *key in headerDic.allKeys) {
        [request addValue:headerDic[key] forHTTPHeaderField:key];
    }
    
    // 3.如果是GET请求
    if ([httpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
        // 设置GET请求
        [request setHTTPMethod:@"GET"];
        
        // 把参数拼接到URL的后面 www.baidu.com?count=123&
        // 创建一个可变字符串
        NSMutableString *paramString = [NSMutableString string];
        for (NSString *key in params) {
            NSString *value = [params objectForKey:key];
            [paramString appendFormat:@"&%@=%@",key,value];
        }
        
        // 如果有参数我们就从新设定URL
        if (params.count > 0) {
            [request setURL:[NSURL URLWithString:[urlString stringByAppendingString:paramString]]];
        }
        
    }
    
    // 4.如果是POST请求
    if ([httpMethod caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        // 设置GET请求
        [request setHTTPMethod:@"POST"];
        
        // 把参数添加到请求体里面面
        for (NSString *key in params) {
            id value = [params objectForKey:key];
//            if ([value isKindOfClass:[NSData class]]) {
//                [request setHTTPBody:value];
//            } else {
                [request setValue:value forKey:key];
            //}
        }
        
    }
    
    // 4.发送请求
    AFHTTPRequestOperation *requstOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    // 设置返回数据的解析方式
    requstOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requstOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (finishDidBlock) {
            finishDidBlock(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation,error);
        }
    }];
    
    [requstOperation start];
    return requstOperation;
}
@end
