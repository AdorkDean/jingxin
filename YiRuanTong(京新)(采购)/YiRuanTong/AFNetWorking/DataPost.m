//
//  DataPost.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/6.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "DataPost.h"

@implementation DataPost
+ (AFHTTPRequestOperationManager *)requestAFWithUrl:(NSString *)urlString
                                             params:(NSDictionary *)params

                                     finishDidBlock:(FinishDidBlock)finishDidBlock
                                       failureBlock:(FailureBlock)failureBlock
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (finishDidBlock) {
            finishDidBlock(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation,error);
        }
        
    }];
    
    
    
    
    
    return manager;
    
    
}

















- (NSString *)replaceOhter:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"null(\"" withString:@""];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"\")" withString:@""];
    return returnString;
}




@end
