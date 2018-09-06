//
//  WXGLDetailView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "WXGLDetailView.h"
#import "UIViewExt.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface WXGLDetailView ()
@property(nonatomic,retain)UIScrollView *mainScrollView;
@end

@implementation WXGLDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"季度巡检详情";
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
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"维修人员";
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentLeft;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [self.mainScrollView addSubview:view1];
    [self.mainScrollView addSubview:label1];
    
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
    label11.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label11];
    label11.text = _model.repairname;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"客户名称";
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentLeft;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    UILabel  *label22 =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
    label22.font =[UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label2];
    [self.mainScrollView addSubview:view2];
    [self.mainScrollView addSubview:label22];
    label22.text = _model.custname;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"联系人";
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =  NSTextAlignmentLeft;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    UILabel *label33 =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
    label33.font =[UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label3];
    [self.mainScrollView addSubview:view3];
    [self.mainScrollView addSubview:label33];
    label33.text = _model.linker;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"联系电话";
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment = NSTextAlignmentLeft;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    UILabel *label44 =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
    label44.font =[UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label4];
    [self.mainScrollView addSubview:view4];
    [self.mainScrollView addSubview:label44];
    label44.text = _model.linkertel;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"维修日期";
    label5.font =[UIFont systemFontOfSize:13];
    label5.textAlignment = NSTextAlignmentLeft;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    UILabel *label55 =[[UILabel alloc]initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 100, 45)];
    label55.font =[UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label5];
    [self.mainScrollView addSubview:view5];
    [self.mainScrollView addSubview:label55];
    
    if (_model.repairtdate.length > 0) {
        NSString *str = _model.repairtdate;
        NSRange range = {0,10};
        str = [str substringWithRange:range];
        label55.text = str;
    }

    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"设备名称";
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment = NSTextAlignmentLeft;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom , KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    UILabel *label66 =[[UILabel alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
    label66.font = [UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label6];
    [self.mainScrollView addSubview:view6];
    [self.mainScrollView addSubview:label66];
    label66.text = _model.equiname;
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"维修情况";
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentLeft;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom , KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label7];
    [self.mainScrollView addSubview:view7];
    
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(91, label6.bottom + 1, KscreenWidth - 100, 45)];
    label77.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label77];
    label77.text = _model.repairsituation;
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
    label8.text = @"备注";
    label8.font =[UIFont systemFontOfSize:13];
    label8.textAlignment = NSTextAlignmentLeft;
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, label8.bottom, KscreenWidth, 1)];
    view8.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label8];
    [self.mainScrollView addSubview:view8];
    
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(91, label7.bottom + 1, KscreenWidth - 100, 45)];
    label88.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label88];
    label88.text = _model.note;
    
//    //
//    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 327)];
//    shu.backgroundColor = [UIColor grayColor];
 //   [self.mainScrollView addSubview:shu];
}

@end
