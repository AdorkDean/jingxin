//
//  CustomerServiceAddVC.m
//  YiRuanTong
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CustomerServiceAddVC.h"
#import "UIViewExt.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"
#import "DataPost.h"
@interface CustomerServiceAddVC ()
{
    UITextView* _questionText;
    MBProgressHUD* _HUD;
    
}
@end

@implementation CustomerServiceAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后问题添加";
    self.navigationItem.rightBarButtonItem = nil;
    [self creatUI];
    
}
- (void)creatUI{
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, KscreenWidth - 20, 30)];
    titleLabel.text = @"售后问题描述：";
    [self.view addSubview:titleLabel];
    _questionText = [[UITextView alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+10, KscreenWidth - titleLabel.left*2, KscreenHeight - titleLabel.bottom - 64 - 50 - 200)];
    _questionText.layer.borderWidth = 1;
    _questionText.font = [UIFont systemFontOfSize:14];
    _questionText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _questionText.zw_placeHolder = @"请您在此描述问题";
    _questionText.zw_limitCount = 500;
    _questionText.zw_placeHolderColor = [UIColor grayColor];
    
    [self.view addSubview:_questionText];
    
    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(20, _questionText.bottom+10, KscreenWidth - 40, 45);
    [addBtn setTitle:@"提交" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 5;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
}
- (void)addBtnClick:(UIButton*)sender{
    [self addRequestData:_questionText.text];
}
- (void)addRequestData:(NSString*)text{
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText =  @"网络不给力,正在加载中...";
    [_HUD show:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/questions"];
    NSDictionary* params = @{@"action":@"addQuestions",@"data":[NSString stringWithFormat:@"{\"question\":\"%@\"}",text]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            if ([realStr isEqualToString:@"\"true\""]||[realStr isEqualToString:@"true"]) {
                [self showAlert:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomerServiceVCNewRefresh" object:self];
            }else if ([realStr isEqualToString:@"false"]||[realStr isEqualToString:@"\"false\""]){
                [self showAlert:@"保存失败"];
            }else{
                [self showAlert:realStr];
            }
        }
        [_HUD hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD removeFromSuperview];
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
    }];
}





@end
