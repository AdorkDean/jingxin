//
//  KuCunDetailView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/7/3.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KuCunDetailView.h"
#import "UIViewExt.h"
#define lineColor  COLOR(240, 240, 240, 1);
@interface KuCunDetailView ()<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *mainScrollView;
@end

@implementation KuCunDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库存查询详情";
    self.navigationItem.rightBarButtonItem = nil;
    
    [self initScrollView];
    [self initDetailView];
    //[self initDetailView1];
    
}
- (void)initScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(KscreenWidth, 610);
    _mainScrollView.bounces = NO;
    _mainScrollView.backgroundColor =[UIColor clearColor];
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
}
- (void)initDetailView{
    
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"仓库名称";
    label1.font =[UIFont systemFontOfSize:13];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [self.mainScrollView addSubview:view1];
    [self.mainScrollView addSubview:label1];
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, KscreenWidth - 100, 45)];
    label11.font = [UIFont systemFontOfSize:13];
    label11.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label11];
    label11.text = _model.storagename;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"产品名称";
    label2.font =[UIFont systemFontOfSize:13];
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    UILabel  *label22 =[[UILabel alloc]initWithFrame:CGRectMake(90, label1.bottom + 1, KscreenWidth - 100, 45)];
    label22.font =[UIFont systemFontOfSize:13];
    label22.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label2];
    [self.mainScrollView addSubview:view2];
    [self.mainScrollView addSubview:label22];
    label22.text =  _model.proname;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"产品编码";
    label3.font =[UIFont systemFontOfSize:13];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    UILabel *label33 =[[UILabel alloc]initWithFrame:CGRectMake(90, label2.bottom + 1, KscreenWidth - 100, 45)];
    label33.font =[UIFont systemFontOfSize:13];
    label33.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label3];
    [self.mainScrollView addSubview:view3];
    [self.mainScrollView addSubview:label33];
    label33.text = _model.prono;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"规格";
    label4.font =[UIFont systemFontOfSize:13];
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    UILabel *label44 =[[UILabel alloc]initWithFrame:CGRectMake(90, label3.bottom + 1, KscreenWidth - 100, 45)];
    label44.font =[UIFont systemFontOfSize:13];
    label44.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label4];
    [self.mainScrollView addSubview:view4];
    [self.mainScrollView addSubview:label44];
    label44.text = _model.specification;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"单价";
    label5.font =[UIFont systemFontOfSize:13];
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom , KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    UILabel *label55 =[[UILabel alloc]initWithFrame:CGRectMake(90, label4.bottom + 1, KscreenWidth - 100, 45)];
    label55.font =[UIFont systemFontOfSize:13];
    label55.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label5];
    [self.mainScrollView addSubview:view5];
    [self.mainScrollView addSubview:label55];
    label55.text = [NSString stringWithFormat:@"%@",_model.singleprice];
    
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"批次";
    label6.font =[UIFont systemFontOfSize:13];
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    UILabel *label66 =[[UILabel alloc]initWithFrame:CGRectMake(90, label5.bottom + 1, KscreenWidth - 100, 45)];
    label66.font = [UIFont systemFontOfSize:13];
    label66.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label6];
    [self.mainScrollView addSubview:view6];
    [self.mainScrollView addSubview:label66];
    label66.text = [NSString stringWithFormat:@"%@",_model.probatch];
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"主单位";
    label7.font =[UIFont systemFontOfSize:13];
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom , KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label7];
    [self.mainScrollView addSubview:view7];
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(90, label6.bottom + 1, KscreenWidth - 100, 45)];
    label77.font = [UIFont systemFontOfSize:13];
    label77.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label77];
    label77.text = _model.zhudanwei;
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
    label8.text = @"主单位数量";
    label8.font =[UIFont systemFontOfSize:13];
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, label8.bottom , KscreenWidth, 1)];
    view8.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label8];
    [self.mainScrollView addSubview:view8];
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(90, label7.bottom + 1, KscreenWidth - 100, 45)];
    label88.font = [UIFont systemFontOfSize:13];
    label88.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label88];
    label88.text = [NSString stringWithFormat:@"%@",_model.zhudanweishuliang];
    
    
    UILabel * label9 = [[UILabel alloc]initWithFrame:CGRectMake(10, label8.bottom + 1, 80, 45)];
    label9.text = @"副单位";
    label9.font =[UIFont systemFontOfSize:13];
    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, label9.bottom , KscreenWidth, 1)];
    view9.backgroundColor =  lineColor;
    [self.mainScrollView addSubview:label9];
    [self.mainScrollView addSubview:view9];
    UILabel *label99 = [[UILabel alloc] initWithFrame:CGRectMake(90, label8.bottom + 1, KscreenWidth - 100, 45)];
    label99.font = [UIFont systemFontOfSize:13];
    label99.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label99];
    label99.text = [NSString stringWithFormat:@"%@",_model.fudanwei];
    
    UILabel * label10 = [[UILabel alloc]initWithFrame:CGRectMake(10, label9.bottom + 1, 80, 45)];
    label10.text = @"副单位数量";
    label10.font =[UIFont systemFontOfSize:13];
    UIView *view10 = [[UIView alloc]initWithFrame:CGRectMake(0, label10.bottom , KscreenWidth, 1)];
    view10.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label10];
    [self.mainScrollView addSubview:view10];
    UILabel *label101 = [[UILabel alloc] initWithFrame:CGRectMake(90, label9.bottom + 1, KscreenWidth - 100, 45)];
    label101.font = [UIFont systemFontOfSize:13];
    label101.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label101];
    label101.text = [NSString stringWithFormat:@"%@",_model.fudanweishuliang];

    
    //
    UILabel *label1101 = [[UILabel alloc]initWithFrame:CGRectMake(10, label10.bottom + 1, 80, 45)];
    label1101.text = @"库存金额";
    label1101.font =[UIFont systemFontOfSize:13];
    UIView *view1101 = [[UIView alloc]initWithFrame:CGRectMake(0, label1101.bottom , KscreenWidth, 1)];
    view1101.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label1101];
    [self.mainScrollView addSubview:view1101];
    UILabel *label1102 = [[UILabel alloc] initWithFrame:CGRectMake(90, label10.bottom + 1, KscreenWidth - 100, 45)];
    label1102.font = [UIFont systemFontOfSize:13];
    label1102.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label1102];
    label1102.text = [NSString stringWithFormat:@"%@",_model.totalmoney];
    
    //
    UILabel *label1201 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1101.bottom + 1, 80, 45)];
    label1201.text = @"生产日期";
    label1201.font =[UIFont systemFontOfSize:13];
    UIView *view1201 = [[UIView alloc]initWithFrame:CGRectMake(0, label1201.bottom , KscreenWidth, 1)];
    view1201.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label1201];
    [self.mainScrollView addSubview:view1201];
    UILabel *label1202 = [[UILabel alloc] initWithFrame:CGRectMake(90, label1101.bottom + 1, KscreenWidth - 100, 45)];
    label1202.font = [UIFont systemFontOfSize:13];
    label1202.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label1202];
    if (_model.producedate.length > 0) {
        label1202.text = [_model.producedate substringToIndex:10];
    }
    

    //
    UILabel *label1301 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1201.bottom + 1, 80, 45)];
    label1301.text = @"有效期至";
    label1301.font =[UIFont systemFontOfSize:13];
    UIView *view1301 = [[UIView alloc]initWithFrame:CGRectMake(0, label1301.bottom , KscreenWidth, 1)];
    view1301.backgroundColor = lineColor;
    [self.mainScrollView addSubview:label1301];
    [self.mainScrollView addSubview:view1301];
    UILabel *label1302 = [[UILabel alloc] initWithFrame:CGRectMake(90, label1201.bottom + 1, KscreenWidth - 100, 45)];
    label1302.font = [UIFont systemFontOfSize:13];
    label1302.textAlignment = NSTextAlignmentLeft;
    [self.mainScrollView addSubview:label1302];
    if (_model.validtime.length > 0) {
        label1302.text = [_model.validtime substringToIndex:10];
    }


    
    
}


#pragma mark  圣地宝去掉单价
- (void)initDetailView1{
    //
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label1.text = @"仓库名称";
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
    label11.text = _model.storagename;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label2.text = @"产品名称";
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
    label22.text =  _model.proname;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label3.text = @"产品编码";
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
    label33.text = _model.prono;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label4.text = @"规格";
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
    label44.text = _model.specification;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 40)];
    label5.text = @"单位";
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
    label55.text = _model.prounitname;
    
    
//    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 40)];
//    label6.text = @"单价";
//    label6.backgroundColor = COLOR(231, 231, 231, 1);
//    label6.font =[UIFont systemFontOfSize:13];
//    label6.textAlignment =NSTextAlignmentCenter;
//    UILabel *label66 =[[UILabel alloc]initWithFrame:CGRectMake(86, 205, KscreenWidth - 90, 40)];
//    label66.font = [UIFont systemFontOfSize:13];
//    
//    [self.mainScrollView addSubview:label6];

//    [self.mainScrollView addSubview:label66];
//    label66.text = [NSString stringWithFormat:@"%@",_model.singleprice];
        UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 245, KscreenWidth, 1)];
        view6.backgroundColor = [UIColor grayColor];
        [self.mainScrollView addSubview:view6];

    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 40)];
    label7.text = @"批次";
    label7.backgroundColor = COLOR(231, 231, 231, 1);
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentCenter;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, 286, KscreenWidth, 1)];
    view7.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label7];
    [self.mainScrollView addSubview:view7];
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(86, 205, KscreenWidth - 90, 40)];
    label77.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label77];
    label77.text = _model.probatch;
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(0, 246, 80, 40)];
    label8.text = @"库存数量";
    label8.backgroundColor = COLOR(231, 231, 231, 1);
    label8.font =[UIFont systemFontOfSize:13];
    label8.textAlignment =NSTextAlignmentCenter;
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, 327, KscreenWidth, 1)];
    view8.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label8];
    [self.mainScrollView addSubview:view8];
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(86, 246, KscreenWidth - 90, 40)];
    label88.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label88];
    label88.text = [NSString stringWithFormat:@"%@",_model.totalcount];
    
    
    UILabel * label9 = [[UILabel alloc]initWithFrame:CGRectMake(0, 287, 80, 40)];
    label9.text = @"库存金额";
    label9.backgroundColor = COLOR(231, 231, 231, 1);
    label9.font =[UIFont systemFontOfSize:13];
    label9.textAlignment =NSTextAlignmentCenter;
    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, 368, KscreenWidth, 1)];
    view9.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label9];
    [self.mainScrollView addSubview:view9];
    UILabel *label99 = [[UILabel alloc] initWithFrame:CGRectMake(86, 287, KscreenWidth - 90, 40)];
    label99.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label99];
    label99.text = [NSString stringWithFormat:@"%@",_model.totalmoney];
    
    UILabel * label10 = [[UILabel alloc]initWithFrame:CGRectMake(0, 328, 80, 40)];
    label10.text = @"生产日期";
    label10.backgroundColor = COLOR(231, 231, 231, 1);
    label10.font =[UIFont systemFontOfSize:13];
    label10.textAlignment =NSTextAlignmentCenter;
    UIView *view10 = [[UIView alloc]initWithFrame:CGRectMake(0, 409, KscreenWidth, 1)];
    view10.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label10];
    [self.mainScrollView addSubview:view10];
    UILabel *label101 = [[UILabel alloc] initWithFrame:CGRectMake(86, 328, KscreenWidth - 90, 40)];
    label101.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label101];
    if (_model.instocktime.length > 0) {
        label101.text = [_model.instocktime substringToIndex:10];
    }
    
    
    UILabel *label1101 = [[UILabel alloc]initWithFrame:CGRectMake(0, 369, 80, 40)];
    label1101.text = @"有效期至";
    label1101.backgroundColor = COLOR(231, 231, 231, 1);
    label1101.font =[UIFont systemFontOfSize:13];
    label1101.textAlignment =NSTextAlignmentCenter;
    UIView *view1101 = [[UIView alloc]initWithFrame:CGRectMake(0, 450, KscreenWidth, 1)];
    view1101.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label1101];
    //[self.mainScrollView addSubview:view1101];
    UILabel *label1102 = [[UILabel alloc] initWithFrame:CGRectMake(86, 369, KscreenWidth - 90, 40)];
    label1102.font = [UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label1102];
    if (_model.validtime.length > 0) {
        label1102.text = [_model.validtime substringToIndex:10];
    }
    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 409)];
    shu.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:shu];
}


@end
