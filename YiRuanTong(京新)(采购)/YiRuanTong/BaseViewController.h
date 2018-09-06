//
//  BaseViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface BaseViewController : UIViewController

@property(nonatomic,retain) UIButton *BackButton;
@property(nonatomic,retain) UIButton *AddButton;

@property(nonatomic,retain) UIBarButtonItem *left;

@property(nonatomic,retain) UIBarButtonItem *right;
//检测网络状态
- (NSString *)stringFromStatus:(NetworkStatus)status;
//导航栏右侧按钮
- (UIBarButtonItem *)showBarWithName:(NSString *)BarName
                      addBarWithName:(NSString *)name;

//弹出提示框
- (void)showAlert:(NSString *)message;
//转换NULL为空
-(NSString*)convertNull:(id)object;
-(NSString*)convertNullkongge:(id)object;
//自动登录方法
- (void)selfLogin;
//去除字符串的双引号
- (NSString *)replaceOthers:(NSString *)responseString;
//替换英文字符
- (NSString *)replaceChar:(NSString *)EnString;
//四舍五入取整
- (NSString *)getNumber:(NSString *)numString;
- (void)backButtonAction:(UIButton*)button;
-(BOOL)keyboardDid;


@end
