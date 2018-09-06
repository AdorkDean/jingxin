//
//  QiXinViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "QiXinViewController.h"
#import "ChatViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface QiXinViewController ()
{
    NSMutableArray *_dataArray;
}
@end

@implementation QiXinViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //取消返回按钮 添加 logo
    [self setNavigationTitle:@"消息" textColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    //设置导航栏的背景图片
    UIImage *image = [UIImage imageNamed:@"navBack.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    // 设置用户信息提供者。
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:NO];
}

- (void)dataRequest
{
    NSString *strAdress = @"/rongcloud";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getFriendsList"};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = (NSArray *)responseObject;
        for (NSDictionary *dic in arr) {
            TongxunluModel *model = [[TongxunluModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.idEQ = dic[@"id"];
            [_dataArray addObject:model];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

// 获取用户信息的方法。
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    [self dataRequest];
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    //[self dataRequest];
    for (TongxunluModel *model in _dataArray) {
        
        if ([model.idEQ isEqual:userId]) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = model.idEQ;
            user.name = model.name;
            user.portraitUri = model.portraituri;
            return completion(user);
        }
    }
    return completion(nil);
}

- (void)onSelectedTableRow:(RCConversation*)conversation{
    
    // 该方法目的延长会话聊天 UI 的生命周期
    ChatViewController* chat = [self getChatController:conversation.targetId conversationType:conversation.conversationType];
    if (nil == chat) {
        chat =[[ChatViewController alloc]init];
        [self addChatController:chat];
    }
    chat.currentTarget = conversation.targetId;
    chat.conversationType = conversation.conversationType;
    //chat.currentTargetName = curCell.userNameLabel.text;
    chat.currentTargetName = conversation.conversationTitle;
    [self.navigationController pushViewController:chat animated:YES];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
