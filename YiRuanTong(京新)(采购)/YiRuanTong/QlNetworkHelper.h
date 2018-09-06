//
//  QlNetworkHelper.h
//  TYBProject
//
//  Created by 钱龙 on 16/11/18.
//  Copyright © 2016年 钱龙. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^QlNetworkHelperBlock)(id obj);
@interface QlNetworkHelper : NSObject

+(instancetype)sharedManager;
-(void)networkReaching;
-(void)getWithURL:(NSString *)urlString WithParameters:(NSDictionary *)parameter compeletionWithBlock:(QlNetworkHelperBlock)block;
-(void)postWithURL:(NSString *)urlString WithParameters:(NSDictionary *)parameter compeletionWithBlock:(QlNetworkHelperBlock)block;
-(void)uploadPictureWithURL:(NSString *)urlString WithParameters:(NSDictionary *)parameter imageFileName:(NSString *)fileName image:(UIImage *)image compoletionWithBlock:(QlNetworkHelperBlock)block;
@end
