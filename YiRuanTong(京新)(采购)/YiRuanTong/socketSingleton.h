//
//  socketSingleton.h
//  YiRuanTong
//
//  Created by apple on 17/8/11.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface socketSingleton : NSObject

//单例方法
+(instancetype)sharedSingleton;
+(void)socketSingletonOpen;
+(void)socketSingletonClose;
@end
