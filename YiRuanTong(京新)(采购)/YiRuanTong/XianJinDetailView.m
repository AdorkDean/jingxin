//
//  XianJinDetailView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/7/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "XianJinDetailView.h"

@interface XianJinDetailView ()<UIScrollViewDelegate>


@property(nonatomic,retain)UIScrollView *mainScrollView;
@end

@implementation XianJinDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"现金帐出入详情";
    self.navigationItem.rightBarButtonItem = nil;
    
    [self initScrollView];
    [self initDetailView];
    
    
}
- (void)initScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(KscreenWidth, 330+17);
    _mainScrollView.bounces = NO;
    _mainScrollView.backgroundColor =[UIColor clearColor];
    _mainScrollView.delegate =self;
    [self.view addSubview:_mainScrollView];
    
}
- (void)initDetailView{
    //
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label1.text = @"原始单据";
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:view1];
    [self.mainScrollView addSubview:label1];
    
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(86, 0, KscreenWidth - 90, 40)];
    label11.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label11];
    label11.text = _model.firstbill;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label2.text = @"原始单号";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view2.backgroundColor = [UIColor grayColor];
    UILabel  *label22 =[[UILabel alloc]initWithFrame:CGRectMake(86, 41, KscreenWidth - 90, 40)];
    label22.font =[UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label2];
    [self.mainScrollView addSubview:view2];
    [self.mainScrollView addSubview:label22];
    label22.text = [NSString stringWithFormat:@"%@",_model.firstbillno];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label3.text = @"审批状态";
    label3.backgroundColor = COLOR(231, 231, 231, 1);
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    UILabel *label33 =[[UILabel alloc]initWithFrame:CGRectMake(86, 82, KscreenWidth - 90, 40)];
    label33.font =[UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label3];
    [self.mainScrollView addSubview:view3];
    [self.mainScrollView addSubview:label33];
    label33.text = _model.spnodename;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label4.text = @"摘要";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    view4.backgroundColor = [UIColor grayColor];
    UILabel *label44 =[[UILabel alloc]initWithFrame:CGRectMake(86, 123, KscreenWidth - 90, 40)];
    label44.font =[UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label4];
    [self.mainScrollView addSubview:view4];
    [self.mainScrollView addSubview:label44];
    label44.text = _model.summary;
    
    int i =    [_model.ioflag intValue];
    //出入帐区别
    if (i == 0) {
        UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 40)];
        label5.text = @"出账金额";
        label5.backgroundColor = COLOR(231, 231, 231, 1);
        label5.font =[UIFont systemFontOfSize:13];
        label5.textAlignment =NSTextAlignmentCenter;
        UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, 204, KscreenWidth, 1)];
        view5.backgroundColor = [UIColor grayColor];
        UILabel *label55 =[[UILabel alloc]initWithFrame:CGRectMake(86, 164, KscreenWidth - 90, 40)];
        label55.font =[UIFont systemFontOfSize:13];
        
        [self.mainScrollView addSubview:label5];
        [self.mainScrollView addSubview:view5];
        [self.mainScrollView addSubview:label55];
        label55.text = [NSString stringWithFormat:@"%@",_model.outmoney];

    }else if(i == 1){
        UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 40)];
        label5.text = @"入账金额";
        label5.backgroundColor = COLOR(231, 231, 231, 1);
        label5.font =[UIFont systemFontOfSize:13];
        label5.textAlignment =NSTextAlignmentCenter;
        UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, 204, KscreenWidth, 1)];
        view5.backgroundColor = [UIColor grayColor];
        UILabel *label55 =[[UILabel alloc]initWithFrame:CGRectMake(86, 164, KscreenWidth - 90, 40)];
        label55.font =[UIFont systemFontOfSize:13];
        
        [self.mainScrollView addSubview:label5];
        [self.mainScrollView addSubview:view5];
        [self.mainScrollView addSubview:label55];
        label55.text = [NSString stringWithFormat:@"%@",_model.inmoney];
    
    }
    
    
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 40)];
    label6.text = @"出入账时间";
    label6.backgroundColor = COLOR(231, 231, 231, 1);
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 245, KscreenWidth, 1)];
    view6.backgroundColor = [UIColor grayColor];
    UILabel *label66 =[[UILabel alloc]initWithFrame:CGRectMake(86, 205, KscreenWidth - 90, 40)];
    label66.font = [UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label6];
    [self.mainScrollView addSubview:view6];
    [self.mainScrollView addSubview:label66];
    label66.text = _model.time;
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, 246, 80, 40)];
    label7.text = @"操作人";
    label7.backgroundColor = COLOR(231, 231, 231, 1);
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentCenter;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, 286, KscreenWidth, 1)];
    view7.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label7];
    [self.mainScrollView addSubview:view7];
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(86, 246, KscreenWidth - 90, 40)];
    label77.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label77];
    label77.text = _model.creator;
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(0, 287, 80, 40)];
    label8.text = @"操作时间";
    label8.backgroundColor = COLOR(231, 231, 231, 1);
    label8.font =[UIFont systemFontOfSize:13];
    label8.textAlignment =NSTextAlignmentCenter;
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, 327, KscreenWidth, 1)];
    view8.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label8];
    [self.mainScrollView addSubview:view8];
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(86, 287, KscreenWidth - 90, 40)];
    label88.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label88];
    label88.text = _model.createtime;
    
    
    UILabel * label9 = [[UILabel alloc]initWithFrame:CGRectMake(0, 328, 80, 40)];
    label9.text = @"余额";
    label9.backgroundColor = COLOR(231, 231, 231, 1);
    label9.font =[UIFont systemFontOfSize:13];
    label9.textAlignment =NSTextAlignmentCenter;
    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, 368, KscreenWidth, 1)];
    view9.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label9];
    [self.mainScrollView addSubview:view9];
    UILabel *label99 = [[UILabel alloc] initWithFrame:CGRectMake(86, 328, KscreenWidth - 90, 40)];
    label99.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label99];
    label99.text = [NSString stringWithFormat:@"%@",_model.balance];
    
    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 368)];
    shu.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:shu];
}



@end
