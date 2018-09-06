//
//  ChangePassWordView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/27.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ChangePassWordView.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"

@interface ChangePassWordView (){
    
    UITextField *_oldPassWord1;
    UITextField *_newPassWord1;
    UITextField *_newPassWord2;
    MBProgressHUD *_hud;
}

@end

@implementation ChangePassWordView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView{
    UIImageView  *backView = [[UIImageView alloc ]initWithFrame:CGRectMake(5, 5, KscreenWidth - 10, 120)];
    backView.image = [UIImage imageNamed:@"set_back.png"];
    backView.userInteractionEnabled = NO;
    [self.view addSubview:backView];
    
    UILabel *oldPassWord = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 30)];
    oldPassWord.text = @"旧密码:";
    [backView addSubview:oldPassWord];
    _oldPassWord1 = [[UITextField alloc] initWithFrame:CGRectMake(oldPassWord.right+10, 10, backView.frame.size.width-80, 30)];
    _oldPassWord1.borderStyle = UITextBorderStyleRoundedRect;
    _oldPassWord1.userInteractionEnabled = YES;
    [self.view addSubview:_oldPassWord1];
    
    UILabel *newPassWord = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 60, 30)];
    newPassWord.text = @"新密码:";
    [backView addSubview:newPassWord];
    _newPassWord1 = [[UITextField alloc] initWithFrame:CGRectMake(newPassWord.right+10, 50, backView.frame.size.width-60-20, 30)];
    _newPassWord1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_newPassWord1];
    
    UILabel *confirmPassWord = [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 80, 30)];
    confirmPassWord.text = @"确认密码:";
    [backView addSubview:confirmPassWord];
    _newPassWord2 = [[UITextField alloc] initWithFrame:CGRectMake(confirmPassWord.right+10, 90,backView.frame.size.width - 100, 30)];
    _newPassWord2.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_newPassWord2];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(KscreenWidth/2 - 90, 140, 60, 40);
    cancelButton.layer.cornerRadius = 8;
    cancelButton.backgroundColor = COLOR(98, 198, 248, 1);
    [cancelButton setTitle:@"重置" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(reSet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton  *confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmButton.layer.cornerRadius = 8;
    confirmButton.frame = CGRectMake(KscreenWidth/2+30, 140, 60, 40);
    confirmButton.backgroundColor = COLOR(98, 198, 248, 1);;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(ChangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
}

- (void)reSet{

    _oldPassWord1.text = @"";
    _newPassWord1.text = @"";
    _newPassWord2.text = @"";
}

- (void)ChangeButton{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=updatePassword&data={\"table\":\"yhzh\",\"password\":\"%@\",\"oldpwd\":\"%@\"}",_newPassWord1.text,_oldPassWord1.text];
   
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSLog(@"更改密码返回:%@",str1);
    
    NSRange range = {1,str1.length-2};
    NSString *reallystr = [str1 substringWithRange:range];
    if ([reallystr isEqualToString:@"true"]) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"修改成功";
        _hud.margin = 10.f;
        _hud.yOffset = 150.f;
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"修改失败";
        _hud.margin = 10.f;
        _hud.yOffset = 150.f;
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1];
    }
}

@end
