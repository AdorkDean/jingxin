//
//  FYSQLiuLanView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FYSQLiuLanView.h"
#import "FYSQModel.h"
#import "UIViewExt.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface FYSQLiuLanView (){

    FYSQModel *_model;

}

@property(nonatomic,retain)UIScrollView *fyScrollView;

@end

@implementation FYSQLiuLanView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"浏览详情";
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
}
- (void)initView{
 
    _fyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    _fyScrollView.contentSize = CGSizeMake(KscreenWidth, 400);
    _fyScrollView.backgroundColor =  [UIColor clearColor];
    _fyScrollView.delegate = self;
    [self.view addSubview:_fyScrollView];
    
    //页面设置
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"申请人";
    label1.font =[UIFont systemFontOfSize:13];
    //label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [self.fyScrollView addSubview:view1];
    [self.fyScrollView addSubview:label1];
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
    label11.font = [UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label11];
    label11.text = _model.applyer;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"申请编号";
    label2.font =[UIFont systemFontOfSize:13];
    //label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom , KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    UILabel  *label22 =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
    label22.font =[UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label2];
    [self.fyScrollView addSubview:view2];
    [self.fyScrollView addSubview:label22];
    label22.text = [NSString stringWithFormat:@"%@",_model.costno];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"申请时间";
    label3.font =[UIFont systemFontOfSize:13];
   // label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    UILabel *label33 =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
    label33.font =[UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label3];
    [self.fyScrollView addSubview:view3];
    [self.fyScrollView addSubview:label33];
    label33.text = _model.applytime;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"费用类型";
    label4.font =[UIFont systemFontOfSize:13];
    //label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    UILabel *label44 =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
    label44.font =[UIFont systemFontOfSize:13];
    
    [self.fyScrollView addSubview:label4];
    [self.fyScrollView addSubview:view4];
    [self.fyScrollView addSubview:label44];
    label44.text = _model.costtype;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"申请原因";
    label5.font =[UIFont systemFontOfSize:13];
   // label5.textAlignment =NSTextAlignmentCenter;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom , KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    UILabel *label55 =[[UILabel alloc]initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 100, 45)];
    label55.font =[UIFont systemFontOfSize:13];
    
    [self.fyScrollView addSubview:label5];
    [self.fyScrollView addSubview:view5];
    [self.fyScrollView addSubview:label55];
    label55.text = _model.applyaim;
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"申请金额";
    label6.font =[UIFont systemFontOfSize:13];
    //label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom , KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    UILabel *label66 =[[UILabel alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
    label66.font = [UIFont systemFontOfSize:13];
    
    [self.fyScrollView addSubview:label6];
    [self.fyScrollView addSubview:view6];
    [self.fyScrollView addSubview:label66];
    label66.text =  [NSString stringWithFormat:@"%@",_model.applymoney];
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"审批状态";
    label7.font =[UIFont systemFontOfSize:13];
    //label7.textAlignment = NSTextAlignmentCenter;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom , KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.fyScrollView addSubview:label7];
    [self.fyScrollView addSubview:view7];
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(91, label6.bottom + 1, KscreenWidth - 100, 45)];
    label77.font = [UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label77];
    label77.text = _model.spnodename;
    
    
    CGSize titleSize = [_model.note boundingRectWithSize:CGSizeMake(KscreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, titleSize.height)];
    label8.text = @"备注";
    label8.font =[UIFont systemFontOfSize:13];
    //label8.textAlignment =NSTextAlignmentCenter;
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, label8.bottom , KscreenWidth, 1)];
    view8.backgroundColor = lineColor;
    [self.fyScrollView addSubview:label8];
    [self.fyScrollView addSubview:view8];
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(91, label7.bottom + 1, KscreenWidth - 100, titleSize.height)];
    label88.numberOfLines = 0;
    label88.font = [UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label88];
    label88.text = _model.note;
}


@end
