//
//  socketSingleton.m
//  YiRuanTong
//
//  Created by apple on 17/8/11.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "socketSingleton.h"
#import "SRWebSocket.h"

#define socket_ADDRESS @"ws://118.190.47.231/jx/WXWebSocket"
@interface socketSingleton ()<SRWebSocketDelegate>

@end
@implementation socketSingleton{
    SRWebSocket *socket;
}

//全局变量
static id _instance = nil;
//单例方法
+(instancetype)sharedSingleton{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (void)setSocket{
    socket.delegate = nil;
    
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:socket_ADDRESS]]];
    socket.delegate = self;
    [socket open];

}
+ (void)socketSingletonOpen{
    [_instance setSocket];
}

+ (void)socketSingletonClose{
    [_instance closee];
}
- (void)closee{
    [socket close];

}
- (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    else {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

//2.连接成功会调用这个代理方法
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功，可以立刻登录你公司后台的服务器了，还有开启心跳");
    
    if (socket) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSDictionary * loginInfo = @{
                                     @"sessionid" : [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"cookievalue"]],
                                     @"accountid" : [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"id"]],
                                     @"accountname" : [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"account"]] ,
                                     @"ismobile" : @"0",
                                     @"biaoshi" : @"add"
                                     };
        NSString * jsonString = [self jsonStringFromDictionary:loginInfo];
        NSLog(@"jsonString%@",jsonString);
        
        [socket send:jsonString];
    }
}
//3.连接失败会调用这个方法，看 NSLog 里面的东西
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    
}
//4.连接关闭调用这个方法，注意连接关闭不是连接断开，关闭是 [socket close] 客户端主动关闭，断开可能是断网了，被动断开的。
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"连接断开，清空socket对象，清空该清空的东西，还有关闭心跳！");
}
//5.收到服务器发来的数据会调用这个方法
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    NSLog(@"收到数据了，id 是 %@",message);
}
@end
