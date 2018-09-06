//
//  WLXXdetailVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "WLXXdetailVC.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "UIViewExt.h"
#define LineColor COLOR(240, 240, 240, 1);
@interface WLXXdetailVC (){
    NSInteger _page;
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
    UILabel *_label5;
    UILabel *_label6;
    UILabel *_label7;
    UILabel *_label8;
    UILabel* _label9;
    UILabel* _label10;
}

@end


@implementation WLXXdetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物料详情";
    self.navigationItem.rightBarButtonItem = nil;
    _page = 1;
    [self initView];
    [self settLabelModel];
    
}

- (void)initView{
    UIScrollView *back = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    back.contentSize = CGSizeMake(0, KscreenHeight);
    [self.view addSubview:back];
    //
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45)];
    label11.font = [UIFont systemFontOfSize:14];
    label11.text = @"物料分类";
    [back addSubview:label11];
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, KscreenWidth - 110, 45)];
    _label1.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label1];
    UIView *view1  = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = LineColor;
    [back addSubview:view1];
    //
    UILabel *label22 = [[UILabel alloc] initWithFrame:CGRectMake(label11.left, label11.bottom + 1, label11.width, label11.height)];
    label22.font = label11.font;
    label22.text = @"物料名称";
    [back addSubview:label22];
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(_label1.left, label11.bottom + 1, _label1.width, _label1.height)];
    _label2.font = _label1.font;
    [back addSubview:_label2];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, label22.bottom, KscreenWidth, 1)];
    view2.backgroundColor = LineColor;
    [back addSubview:view2];
    //
    UILabel *label33 = [[UILabel alloc] initWithFrame:CGRectMake(label22.left, label22.bottom + 1, label22.width, label22.height)];
    label33.font = label22.font;
    label33.text = @"供货商";
    [back addSubview:label33];
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(_label2.left, label22.bottom + 1, _label2.width, _label2.height)];
    _label3.font = _label2.font;
    [back addSubview:_label3];
    UIView *view3  = [[UIView alloc] initWithFrame:CGRectMake(0, label33.bottom, KscreenWidth, 1)];
    view3.backgroundColor = LineColor;
    [back addSubview:view3];
    //
    UILabel *label44 = [[UILabel alloc] initWithFrame:CGRectMake(label33.left, label33.bottom + 1, label33.width, label33.height)];
    label44.font = label33.font;
    label44.text = @"标签编码";
    [back addSubview:label44];
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(_label3.left, label33.bottom + 1, _label3.width, _label3.height)];
    _label4.font = _label3.font;
    [back addSubview:_label4];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, label44.bottom, KscreenWidth, 1)];
    view4.backgroundColor = LineColor;
    [back addSubview:view4];
    //
    UILabel *label55 = [[UILabel alloc] initWithFrame:CGRectMake(label44.left, label44.bottom + 1, label44.width, label44.height)];
    label55.font = label44.font;
    label55.text = @"物料规格";
    [back addSubview:label55];
    _label5= [[UILabel alloc] initWithFrame:CGRectMake(_label4.left, label44.bottom + 1, _label4.width, _label4.height)];
    _label5.font = _label4.font;
    [back addSubview:_label5];
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, label55.bottom, KscreenWidth, 1)];
    view5.backgroundColor = LineColor;
    [back addSubview:view5];
    //
    UILabel *label66 = [[UILabel alloc] initWithFrame:CGRectMake(label55.left, label55.bottom + 1, label55.width, label55.height)];
    label66.font = label55.font;
    label66.text =@"助记码";
    [back addSubview:label66];
    _label6 = [[UILabel alloc] initWithFrame:CGRectMake(_label5.left, label55.bottom + 1, _label5.width, _label5.height)];
    _label6.font = _label5.font;
    [back addSubview:_label6];
    UIView *view6  = [[UIView alloc] initWithFrame:CGRectMake(0, label66.bottom, KscreenWidth, 1)];
    view6.backgroundColor = LineColor;
    [back addSubview:view6];
    //
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(label66.left, label66.bottom + 1, label66.width, label66.height)];
    label77.font = label66.font;
    label77.text = @"物料简称";
    [back addSubview:label77];
    _label7 = [[UILabel alloc] initWithFrame:CGRectMake(_label6.left, label66.bottom + 1, _label6.width, _label6.height)];
    _label7.font = _label1.font;
    [back addSubview:_label7];
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(0, label77.bottom, KscreenWidth, 1)];
    view7.backgroundColor = LineColor;
    [back addSubview:view7];
    //
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(label77.left, label77.bottom + 1, label77.width, label77.height)];
    label88.font = label77.font;
    label88.text = @"物料价格";
    [back addSubview:label88];
    _label8 = [[UILabel alloc] initWithFrame:CGRectMake(_label7.left, label77.bottom + 1, _label7.width, _label7.height)];
    _label8.font = _label7.font;
    [back addSubview:_label8];
    UIView *view8  = [[UIView alloc] initWithFrame:CGRectMake(0, label88.bottom, KscreenWidth, 1)];
    view8.backgroundColor = LineColor;
    [back addSubview:view8];
    
    UILabel* label99 = [[UILabel alloc]initWithFrame:CGRectMake(label88.left, label88.bottom+1, label88.width, label88.height)];
    label99.font = label88.font;
    label99.text = @"计量单位";
    [back addSubview:label99];
    _label9 = [[UILabel alloc]initWithFrame:CGRectMake(_label8.left, label88.bottom+1, _label8.width, _label8.height)];
    _label9.font = _label8.font;
    [back addSubview:_label9];
    UIView* view9 = [[UIView alloc]initWithFrame:CGRectMake(0, label99.bottom, KscreenWidth, 1)];
    view9.backgroundColor = LineColor;
    [back addSubview:view9];
    
    UILabel* label100 = [[UILabel alloc]initWithFrame:CGRectMake(label99.left, label99.bottom+1, label99.width, label99.height)];
    label100.font = label99.font;
    label100.text = @"备注";
    [back addSubview:label100];
    _label10 = [[UILabel alloc]initWithFrame:CGRectMake(_label9.left, label99.bottom+1, _label9.width, _label9.height)];
    _label10.font = _label9.font;
    [back addSubview:_label10];
    UIView* view10 = [[UIView alloc]initWithFrame:CGRectMake(0, label100.bottom, KscreenWidth, 1)];
    view10.backgroundColor = LineColor;
    [back addSubview:view10];
    
}

- (void)settLabelModel{
    /*
     //物料分类  typename
     //分类ID  typeid
     //物料名称  name
     //物料规格  size
     //物料价格  price
     //助记码   helpno
     //计量单位  measureunit
     //计量单位id    measureunitid
     //供货商       suppliername
     //标签编码  labelno
     //物料简称  shortname
     //备注    note
     */
    _label1.text = [NSString stringWithFormat:@"%@",self.promodel.typename];
    _label2.text = [NSString stringWithFormat:@"%@",self.promodel.name];
    _label3.text = [NSString stringWithFormat:@"%@",self.promodel.suppliername];
    _label4.text = [NSString stringWithFormat:@"%@",self.promodel.labelno];
    _label5.text = [NSString stringWithFormat:@"%@",self.promodel.size];
    _label6.text = [NSString stringWithFormat:@"%@",self.promodel.helpno];
    _label7.text = [NSString stringWithFormat:@"%@",self.promodel.shortname];
    _label8.text = [NSString stringWithFormat:@"%@",self.promodel.price];
    _label9.text = [NSString stringWithFormat:@"%@",self.promodel.measureunit];
    _label10.text = [NSString stringWithFormat:@"%@",self.promodel.note];
}


@end
