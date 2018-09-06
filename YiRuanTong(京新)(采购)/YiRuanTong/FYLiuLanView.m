//
//  FYLiuLanView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/5/25.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FYLiuLanView.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "UIViewExt.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface FYLiuLanView (){
    UIScrollView *_fYScrollview;
    NSInteger _count;
    NSArray *_array;
    MBProgressHUD *_hud;
}
@property(nonatomic,retain)UIScrollView *fYScrollview;

@end

@implementation FYLiuLanView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"浏览详情";
    self.navigationItem.rightBarButtonItem = nil;
    self.view .backgroundColor = [UIColor whiteColor];
    [self dataRequest];
    [self initScrollView];
    [self initDetailView];
    [self initDetailView2];
    
    
}
- (void)initScrollView{
    _fYScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _fYScrollview.showsVerticalScrollIndicator = NO;
    
    _fYScrollview.bounces = NO;
    _fYScrollview.backgroundColor =[UIColor clearColor];
    _fYScrollview.delegate =self;
    [self.view addSubview:_fYScrollview];
    //发放
    UIButton *faFang = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    faFang.frame  = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [faFang setTitle:@"发放" forState:UIControlStateNormal];
    [faFang addTarget:self action:@selector(fafang) forControlEvents:UIControlEventTouchUpInside];
    //[faFang setTintColor:[UIColor blackColor]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:faFang];
    self.navigationItem.rightBarButtonItem = right;
    
}
- (void)initDetailView{
    //
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"报销人";
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentLeft;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.fYScrollview addSubview:view1];
    [self.fYScrollview addSubview:label1];
    UILabel * applyer = [[UILabel alloc]initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
    applyer.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:applyer];
    applyer.text = _model.applyer;
    //
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"日期";
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentLeft;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    [self.fYScrollview addSubview:view2];
    [self.fYScrollview addSubview:label2];
    UILabel *applytime =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
    applytime.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:applytime];
    applytime.text = _model.applytime;
    //
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"发票合计";
    label3.font =[UIFont systemFontOfSize:13];
//    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    [self.fYScrollview addSubview:view3];
    [self.fYScrollview addSubview:label3];
    UILabel *totalnum =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
    totalnum.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:totalnum];
    totalnum.text = [NSString stringWithFormat:@"%@",_model.totalnum];
    //
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"金额合计";
    label4.font =[UIFont systemFontOfSize:13];
   // label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    [self.fYScrollview addSubview:view4];
    [self.fYScrollview addSubview:label4];
    UILabel *applymoney =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
    applymoney.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:applymoney];
    applymoney.text = [NSString stringWithFormat:@"%@",_model.applymoney];

    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"还款合计";
    label5.font =[UIFont systemFontOfSize:13];
    label5.textAlignment = NSTextAlignmentLeft;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom , KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    [self.fYScrollview addSubview:view5];
    [self.fYScrollview addSubview:label5];
    UILabel *refundmoney =[[UILabel alloc]initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 100, 45)];
    refundmoney.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:refundmoney];
    refundmoney.text = [NSString stringWithFormat:@"%@",_model.refundmoney];
    //
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"实际报销";
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment = NSTextAlignmentLeft;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom , KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    [self.fYScrollview addSubview:view6];
    [self.fYScrollview addSubview:label6];
    UILabel *realapplymon =[[UILabel alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
    realapplymon.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:realapplymon];
    realapplymon.text = [NSString stringWithFormat:@"%@",_model.realapplymon];
    //
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"备注";
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentLeft;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom , KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.fYScrollview addSubview:view7];
    [self.fYScrollview addSubview:label7];
    UILabel *note =[[UILabel alloc]initWithFrame:CGRectMake(91, label6.bottom + 1, KscreenWidth - 100, 45)];
    note.font =[UIFont systemFontOfSize:13];
    [self.fYScrollview addSubview:note];
    note.text = _model.note;
}
- (void)dataRequest{
    /*
     costapply
     action:"getDetailReimBeans"
     table:"fybx"
     params:"{"idEQ":"200"}"
     */
    NSString *strAdress = @"/costapply?action=getDetailReimBeans";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=fybx&params={\"idEQ\":\"%@\"}",_model.Id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            _array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            _count = _array.count;
            NSLog(@"费用的详情:%@",_array);
        }
    }

    
}
- (void)initDetailView2{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 327, KscreenWidth, 40)];
    titleLabel.backgroundColor = COLOR(230, 230, 230, 1);

    titleLabel.text = @"费用详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.fYScrollview addSubview:titleLabel];
    _fYScrollview.contentSize = CGSizeMake(KscreenWidth, 370 + 190*_count);
    for (int i = 0; i< _count; i++) {
        NSDictionary *detailDic = _array[i];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 367 + 190*i , KscreenWidth, 190)];
        backView.backgroundColor = [UIColor clearColor];
        [self.fYScrollview addSubview:backView];
        //1
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
        label1.text = @"费用类型";
        
        label1.font =[UIFont systemFontOfSize:13];
        label1.textAlignment = NSTextAlignmentLeft;
        UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
        view1.backgroundColor = lineColor;
        [backView addSubview:view1];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 1)];
        view.backgroundColor = lineColor;
        [self.view addSubview:view];
        [backView addSubview:label1];
        UILabel * applyer = [[UILabel alloc]initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
        applyer.font =[UIFont systemFontOfSize:13];
        [backView addSubview:applyer];
        applyer.text = detailDic[@"costtype"];
        //2
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
        label2.text = @"发票张数";
        label2.font =[UIFont systemFontOfSize:13];
        label2.textAlignment = NSTextAlignmentLeft;
        UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
        view2.backgroundColor = lineColor;
        [backView addSubview:view2];
        [backView addSubview:label2];
        UILabel *applytime =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
        applytime.font =[UIFont systemFontOfSize:13];
        [backView addSubview:applytime];
        applytime.text = [NSString stringWithFormat:@"%@",detailDic[@"singelnum"]];
        //3
        UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
        label3.text = @"金额";
        label3.font =[UIFont systemFontOfSize:13];
        label3.textAlignment = NSTextAlignmentLeft;
        UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
        view3.backgroundColor = lineColor;
        [backView addSubview:view3];
        [backView addSubview:label3];
        UILabel *totalnum =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
        totalnum.font =[UIFont systemFontOfSize:13];
        [backView addSubview:totalnum];
        totalnum.text = [NSString stringWithFormat:@"%@",detailDic[@"applymon"]];
        //4
        UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
        label4.text = @"原因";
        label4.font =[UIFont systemFontOfSize:13];
        label4.textAlignment = NSTextAlignmentLeft;
        UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
        view4.backgroundColor = lineColor;
        [backView addSubview:view4];
        [backView addSubview:label4];
        UILabel *applymoney =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
        applymoney.font =[UIFont systemFontOfSize:13];
        [backView addSubview:applymoney];
        applymoney.text = [NSString stringWithFormat:@"%@",detailDic[@"costcause"]];
        UIView *show = [[UIView alloc] initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 5)];
        show.backgroundColor = COLOR(235, 235, 235, 1);
        [backView addSubview:show];
    }

}
- (void)fafang{
    NSString *isSp = _model.spstatus;
    int i = [isSp intValue];
    if (i == 1) {
        /*
         financinginfo
         action:"doReimIssue"
         data:"{"id":"202"}"
         */
    
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financinginfo?action=doReimIssue"];
        NSDictionary *params = @{@"action":@"doReimIssue",@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_model.Id]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSRange range = {1,str1.length-2};
            if (str1.length != 0) {
                str1 = [str1 substringWithRange:range];
                if ([str1 isEqualToString:@"true"]) {
                    [self showAlert:@"发放成功"];
                }
            }
            

        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"加载失败");
        }];
        
      
        
    }else if (i == 0){
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未经过审批，不能发放！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    
    }

}

@end
