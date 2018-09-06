//
//  LoginViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"
@class AppDelegate;

@interface LoginViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>{

    UILabel * _rememberLabel;
}

@property(strong,nonatomic)UIImageView * rememberImageView;
@property(strong,nonatomic)UITextField * userNameTextField;
@property(strong,nonatomic)UITextField * passwordTextField;
@property(strong,nonatomic)UIButton * loginButton;
@property(assign,nonatomic)BOOL isRemember;
@property(strong,nonatomic)MainViewController *mainViewController;

@end
