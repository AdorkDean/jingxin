//
//  JingPinTianJiaVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "JingPinTianJiaVC.h"
#import "JingPinViewController.h"
#import "UIViewExt.h"
#import "CPINfoModel.h"
#import "MBProgressHUD.h"

@interface JingPinTianJiaVC ()
{
    UIView *_timeView;
    NSMutableArray *_dataArray;
    NSInteger _page;
    UILabel *_chanPinBianMa1;
    UILabel *_guiGe1;
    UILabel *_danJia1;
    NSString *_proid;
    MBProgressHUD *_hud;
    
    NSString *_currentDateStr;
    //本公司产品信息
    UIButton *_chanpinButton;
    UITextField *_gongyingshang;
    UITextField *_shengchanchangjia;
    UITextField *_danjia;
    UIButton *_dateButton;
    UITextView *_beizhu;
    NSInteger _flag1;
    
    //同行业的
    NSMutableArray *_viewArray;
    NSMutableArray *_text1Array;
    NSMutableArray *_text2Array;
    NSMutableArray *_text3Array;
    NSMutableArray *_text4Array;
    NSMutableArray *_text5Array;
    NSMutableArray *_text6Array;
    NSString *_chanPinBianMa;
    NSString *_guiGe;
    NSString *_danJia;
    NSString *_shengId;
    NSString *_shiId;
    NSString *_xianId;
    //隐藏的字符串
    NSString *_shengchanfanwei;
    NSString *_youdian;
    NSString *_quedian;
}
@property(nonatomic,retain)UIDatePicker *datePicker;
@property (strong,nonatomic) NSArray *chanPinMingChenArr;
@property(nonatomic,retain) UITableView *ProtableView;

@end

@implementation JingPinTianJiaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _viewArray = [NSMutableArray array];
    _text1Array = [NSMutableArray array];
    _text2Array = [NSMutableArray array];
    _text3Array = [NSMutableArray array];
    _text4Array = [NSMutableArray array];
    _text5Array = [NSMutableArray array];
    _text6Array = [NSMutableArray array];
    _page = 1;
    self.title = @"竞品添加";
    self.navigationItem.rightBarButtonItem = nil;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    [_dateButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [self initScrollView];
    [self initProductView];

}
- (void)initScrollView{
    
    _jingPinScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.jingPinScrollView.bounces= NO;
    self.jingPinScrollView.backgroundColor =[UIColor clearColor];
    self.jingPinScrollView.delegate = self;
    [self.view addSubview:_jingPinScrollView];

    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setTitle:@"添加" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(shangBaoClickMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;

}
#pragma mark  - 本公司产品信息
- (void)initProductView{
    //本公司产品信息
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label1.text = @"产品名称";
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [_jingPinScrollView addSubview:view1];
    [_jingPinScrollView addSubview:label1];
    _chanpinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _chanpinButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_chanpinButton setTintColor:[UIColor blackColor]];
    _chanpinButton.frame = CGRectMake(86, 0, KscreenWidth - 90, 40);
    _chanpinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_chanpinButton addTarget:self action:@selector(chanPinMingChen) forControlEvents:UIControlEventTouchUpInside];
    [_jingPinScrollView addSubview:_chanpinButton];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label2.text = @"供应商";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view2.backgroundColor = [UIColor grayColor];
    _gongyingshang =[[UITextField alloc] initWithFrame:CGRectMake(86, 41, KscreenWidth - 90, 40)];
    _gongyingshang.font = [UIFont systemFontOfSize:13];
    _gongyingshang.delegate = self;
    [_jingPinScrollView addSubview:label2];
    [_jingPinScrollView addSubview:view2];
    [_jingPinScrollView addSubview:_gongyingshang];
    
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label3.text = @"生产厂家";
    label3.backgroundColor = COLOR(231, 231, 231, 1);
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    _shengchanchangjia = [[UITextField alloc] initWithFrame:CGRectMake(86, 82, KscreenWidth - 90, 40)];
    _shengchanchangjia.font = [UIFont systemFontOfSize:13];
    _shengchanchangjia.delegate = self;
    [_jingPinScrollView addSubview:label3];
    [_jingPinScrollView addSubview:view3];
    [_jingPinScrollView addSubview:_shengchanchangjia];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label4.text = @"单价";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    view4.backgroundColor = [UIColor grayColor];
    _danjia = [[UITextField alloc] initWithFrame:CGRectMake(86, 123, KscreenWidth - 90, 40)];
    _danjia.font = [UIFont systemFontOfSize:13];
    [_jingPinScrollView addSubview:label4];
    [_jingPinScrollView addSubview:view4];
    [_jingPinScrollView addSubview:_danjia];
    //6
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 140)];
    label6.text = @"备注";
    label6.backgroundColor = COLOR(231, 231, 231, 1);
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 305, KscreenWidth, 1)];
    view6.backgroundColor = [UIColor grayColor];
    _beizhu = [[UITextView alloc]initWithFrame:CGRectMake(86, 164, KscreenWidth - 90, 140)];
    
    _beizhu.delegate = self;
    _beizhu.font = [UIFont systemFontOfSize:13];
    
    [_jingPinScrollView addSubview:label6];
    [_jingPinScrollView addSubview:view6];
    [_jingPinScrollView addSubview:_beizhu];
    //竖线
    UIView *fenge = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 305)];
    fenge.backgroundColor = [UIColor grayColor];
    [_jingPinScrollView addSubview:fenge];
    //
    UIButton *addPro = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addPro.frame = CGRectMake(40, 310, KscreenWidth - 80 , 40);
    [addPro setBackgroundColor:[UIColor darkGrayColor]];
    [addPro setTintColor:[UIColor whiteColor]];
    [addPro setTitle:@"添加同行业产品信息" forState:UIControlStateNormal];
    addPro.titleLabel.font = [UIFont systemFontOfSize:18.0];
    //addLinker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [addPro addTarget:self action:@selector(initProduct1) forControlEvents:UIControlEventTouchUpInside];
    [_jingPinScrollView addSubview:addPro];
    
}
#pragma mark  - 同行业产品信息添加
- (void)initProduct1{
    _flag1 = _flag1 + 1;
    _jingPinScrollView.contentSize = CGSizeMake(KscreenWidth, _flag1*390 +320);
    
    
    UIView  *sameProduct= [[UIView alloc] initWithFrame:CGRectMake(0, (_flag1-1)*350 +310, KscreenWidth, 390)];
    sameProduct.backgroundColor = [UIColor whiteColor];
    [_jingPinScrollView addSubview:sameProduct];
    [_viewArray addObject:sameProduct];
    //标题 取消按钮
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-140, 0, 280, 40)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"同行业产品信息";
    [sameProduct addSubview:titleLabel];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(KscreenWidth - 40, 0, 40, 30);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [sameProduct addSubview:cancel];
    //同行业信息详情
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view0.backgroundColor = [UIColor grayColor];
    [sameProduct addSubview:view0];
    //1
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label1.text = @"产品名称";
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [sameProduct addSubview:view1];
    [sameProduct addSubview:label1];
    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(86, 41, KscreenWidth - 90, 40)];
    field1.delegate = self;
    field1.font = [UIFont systemFontOfSize:13];
    field1.placeholder = @"必填";
    field1.text = @" ";
    [sameProduct addSubview:field1];
    [_text1Array addObject:field1];
    //2
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label2.text = @"供应商";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    view2.backgroundColor = [UIColor grayColor];
    UITextField *field2 =[[UITextField alloc]initWithFrame:CGRectMake(86, 82, KscreenWidth - 90, 40)];
    field2.font =[UIFont systemFontOfSize:13];
    field2.placeholder = @"必填";
    field2.text = @" ";
    [sameProduct addSubview:label2];
    [sameProduct addSubview:view2];
    [sameProduct addSubview:field2];
    [_text2Array addObject:field2];
    //3
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label3.text = @"生产厂家";
    label3.backgroundColor = COLOR(231, 231, 231, 1);
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    UITextField *field3 = [[UITextField alloc] initWithFrame:CGRectMake(86, 123, KscreenWidth - 90, 40)];
    field3.font = [UIFont systemFontOfSize:13];
    field3.placeholder = @"必填";
    field3.text = @" ";
    [sameProduct addSubview:label3];
    [sameProduct addSubview:view3];
    [sameProduct addSubview:field3];
    [_text3Array addObject:field3];
    //4
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 40)];
    label4.text = @"单价";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 204, KscreenWidth, 1)];
    view4.backgroundColor = [UIColor grayColor];
    UITextField *field4 =[[UITextField alloc]initWithFrame:CGRectMake(86, 164, KscreenWidth - 90, 40)];
    field4.font =[UIFont systemFontOfSize:13];
    field4.placeholder = @"必填";
    field4.text = @" ";
    field4.keyboardType = UIKeyboardTypeNumberPad;
    [sameProduct addSubview:label4];
    [sameProduct addSubview:view4];
    [sameProduct addSubview:field4];
    [_text4Array addObject:field4];
    
    //
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 140)];
    label6.text = @"备注";
    label6.backgroundColor = COLOR(231, 231, 231, 1);
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 345, KscreenWidth, 1)];
    view6.backgroundColor = [UIColor grayColor];
    UITextView *field6 = [[UITextView alloc] initWithFrame:CGRectMake(86, 205, KscreenWidth - 90, 140)];
    field6.font = [UIFont systemFontOfSize:13];
    field6.text = @" ";
    [sameProduct addSubview:label6];
    [sameProduct addSubview:view6];
    [sameProduct addSubview:field6];
    [_text6Array addObject:field6];
    //
    UIButton *add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    add.frame = CGRectMake(40, 350, KscreenWidth - 80, 40);
    [add setBackgroundColor:[UIColor darkGrayColor]];
    [add setTintColor:[UIColor whiteColor]];
    [add setTitle:@"添加同行业产品信息" forState:UIControlStateNormal];
    add.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    [add addTarget:self action:@selector(initProduct1) forControlEvents:UIControlEventTouchUpInside];
    [sameProduct addSubview:add];
    //竖线
    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 41, 1, 305)];
    shu.backgroundColor = [UIColor grayColor];
    [sameProduct addSubview:shu];
    
}
#pragma mark  - 取消按钮的点击事件
- (void)closeView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除此条？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //移除删掉的view中的各种信息
        [_text1Array removeObjectAtIndex: _flag1 -1];
        [_text2Array removeObjectAtIndex:_flag1 - 1];
        [_text3Array removeObjectAtIndex:_flag1 - 1];
        [_text4Array removeObjectAtIndex:_flag1 - 1];
        [_text5Array removeObjectAtIndex:_flag1 - 1];
        [_text6Array removeObjectAtIndex:_flag1 - 1];
        UIView *view = [_viewArray objectAtIndex:_flag1 - 1];
        [view removeFromSuperview];
        [_viewArray removeObjectAtIndex:_flag1 - 1];
        
        _jingPinScrollView.contentSize = CGSizeMake(KscreenWidth, _jingPinScrollView.contentSize.height - 330);
        _flag1 -= 1;
    }
    
}













//省 
-(void)m_shengButtonClickMethod
{
    
    //省 接口   解析good
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];

    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =@"action=getProvince&params={\"newinfo\":\"true\"}&table=xzqy";
  
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    
    self.shengArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSString * str = array[i][@"name"];
      
        [self.shengArray addObject:str];
    }
    self.listView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.listView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.listView addSubview:btn];
    
    if (self.provinceTableView == nil) {
        self.provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.provinceTableView.backgroundColor = [UIColor grayColor];
    }
    self.provinceTableView.dataSource = self;
    self.provinceTableView.delegate = self;
    [self.listView addSubview:self.provinceTableView];
    [self.view addSubview:self.listView];
    
    [self.provinceTableView reloadData];
}

- (void)closePop
{
    [self.listView removeFromSuperview];
    [self.provinceTableView removeFromSuperview];
    
}
//市    钮点击方法
-(void)m_shiButtonClickMethod
{
    /*市
     http://182.92.96.58:8005/yrt/servlet/customer
     parentid	1
     action	getCity
     params	{"newinfo":"true"}
     table	xzqy*/
   
    //市 接口   解析good
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCity&params={\"newinfo\":\"true\"}&table=xzqy",_shengId];
    NSLog(@"str = %@",str);
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    
    NSLog(@"市信息:%@",array);
    self.shiArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSString * str = array[i][@"name"];
        [self.shiArray addObject:str];
    }
    
    self.listView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.listView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.listView addSubview:btn];
    
    if (self.cityTableView == nil) {
        self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.cityTableView.backgroundColor = [UIColor grayColor];
    }
    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    [self.listView addSubview:self.cityTableView];
    [self.view addSubview:self.listView];
    
    [self.cityTableView reloadData];
    
}
//县    钮点击方法
-(void)m_xianButtonClickMethod
{
   
    //县 接口   解析good
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCounties&params={\"newinfo\":\"true\"}&table=xzqy",_shiId];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    
    NSLog(@"县信息:%@",array);
    self.xianArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSString * str = array[i][@"name"];
        [self.xianArray addObject:str];
    }
    
    self.listView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.listView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.listView addSubview:btn];
    
    if (self.countyTableView == nil) {
        self.countyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.countyTableView.backgroundColor = [UIColor grayColor];
    }
    self.countyTableView.dataSource = self;
    self.countyTableView.delegate = self;
    [self.listView addSubview:self.countyTableView];
    [self.view addSubview:self.listView];
    
    [self.countyTableView reloadData];}

//产品信息的  按钮
-(void)chanPinMingChen
{
       /*
     产品名称
     http://182.92.96.58:8005/yrt/servlet/order
     action	fuzzyQuery
     mobile	true
     page	1
     rows	10
     table	cpxx
     */
   
    self.listView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.listView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.listView addSubview:btn];
    
    if (self.ProtableView == nil) {
        self.ProtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.ProtableView.backgroundColor = [UIColor grayColor];
    }
    self.ProtableView.dataSource = self;
    self.ProtableView.delegate = self;
    self.ProtableView.tag = 10;
    [self.listView addSubview:self.ProtableView];
    [self.view addSubview:self.listView];
    [self CPInfoRequest];
}

- (void)CPInfoRequest
{
    //产品名称－－的接口  解析good
    NSString *strAdress = @"/order";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=fuzzyQuery&mobile=true&page=%zi&rows=10&table=cpxx",_page];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",array);
        for (NSDictionary *dic in array) {
            CPINfoModel *model = [[CPINfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.ProtableView reloadData];

    }
}

- (void)upRefresh
{
    _page++;
    [self CPInfoRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh];
        }
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (tableView == self.ProtableView) {
        return _dataArray.count;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }
    if (tableView == self.ProtableView){
        
        CPINfoModel *model = [_dataArray objectAtIndex:indexPath.row];
        NSLog(@"产品名字:%@",model.proname);
        cell.textLabel.text = model.proname;
        return cell;
    }
    return cell;
}
//点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

     if (tableView == self.ProtableView){
        
        CPINfoModel *model = [_dataArray objectAtIndex:indexPath.row];
        [_chanpinButton setTitle:model.proname forState:UIControlStateNormal];
        _chanPinBianMa = [NSString stringWithFormat:@"%@",model.prono];
        _guiGe = [NSString stringWithFormat:@"%@",model.specification];
        _danJia= [NSString stringWithFormat:@"%@",model.proprice];
         _danjia.text = [NSString stringWithFormat:@"%@",model.proprice];
        _proid = model.Id;
         _chanpinButton.userInteractionEnabled = YES;
    }
    [self.listView removeFromSuperview];
}


//时间点击事件
-(void)date1
{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, KscreenWidth, 270)];
    _timeView.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_timeView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_timeView addSubview:_datePicker];
    [self.view addSubview:_timeView];
}

//监听datePicker值发生变化
-(void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [datePicker addSubview:button];
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
}

//时间点击事件
-(void)date2
{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, KscreenWidth, 270)];
    _timeView.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_timeView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange2:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_timeView addSubview:_datePicker];
    [self.view addSubview:_timeView];
}

- (void)closetime
{
    [_timeView removeFromSuperview];
}

//监听datePicker值发生变化
-(void)dateChange2:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [datePicker addSubview:button];
    
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    for (UIButton *Btn in _text5Array) {
        [Btn setTitle:dateString forState:UIControlStateNormal];

    }
}

-(void)shangBaoClickMethod
{
    /*
     添加的接口
     competing
     action:"add"
     table:"competing_goods_detail"
     data:"{"table":"jpgl","id":"","province":"37","provincename":"","city":"3701","cityname":"济南","county":"370102","countyname":"历下区","thisproid":"44","thisprono":"P201410280001","thissupplier":"","thisproducter":"","thisscope":"","thisspecification":"25kg/桶","thisprice":"10.11","thisvalidtime":"36","thisoptimal":"","thislack":"","thisnote":"","thyjpList":[{"table":"competing_goods_detail","otherproname":"cesss","otherprono":"","othersupplier":"","otherproducter":"","otherscope":"","otherspecification":"","otherprice":"","othervalidtime":"","otheroptimal":"","otherlack":"","othernote":""},{"table":"competing_goods_detail","otherproname":"dddddd","otherprono":"","othersupplier":"ddd","otherproducter":"ddd","otherscope":"","otherspecification":"","otherprice":"","othervalidtime":"","otheroptimal":"","otherlack":"","othernote":""}]}"
     
     */
    _shengchanfanwei = @"";
    _youdian = @"";
    _quedian = @"";
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/competing?action=add&table=competing_goods_detail"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSMutableString *str = [NSMutableString stringWithFormat:@"action=add&table=competing_goods_detail&data={\"table\":\"jpgl\",\"id\":\"\",\"province\":\"37\",\"provincename\":\"山东省\",\"city\":\"3701\",\"cityname\":\"济南\",\"county\":\"370102\",\"countyname\":\"历下区\",\"thisproid\":\"%@\",\"thisprono\":\"%@\",\"thissupplier\":\"%@\",\"thisproducter\":\"%@\",\"thisscope\":\"%@\",\"thisspecification\":\"%@\",\"thisprice\":\"%@\",\"thisvalidtime\":\"11\",\"thisoptimal\":\"%@\",\"thislack\":\"%@\",\"thisnote\":\"%@\",}",_proid,_chanPinBianMa,_gongyingshang.text,_shengchanchangjia.text,_shengchanfanwei,_guiGe,_danJia,_youdian,_quedian,_beizhu.text];
    
    NSMutableString *proStr = [NSMutableString stringWithFormat:@"\"thyjpList\":[]"];
    for (int i = 0; i < _flag1; i++) {
        
        UITextField *proname = [_text1Array objectAtIndex:i];
        UITextField *supplier = [_text2Array objectAtIndex:i];
        UITextField *producter = [_text3Array objectAtIndex:i];
        UITextField *price = [_text4Array objectAtIndex:i];
       // UIButton *date = [_text5Array objectAtIndex:i];
        UITextView *note = [_text6Array objectAtIndex:i];
        
        [proStr insertString:[NSString stringWithFormat:@"{\"province\":\"37\",\"provincename\":\"山东省\",\"city\":\"3701\",\"cityname\":\"济南\",\"county\":\"370102\",\"countyname\":\"历下区\",\"table\":\"competing_goods_detail\",\"otherproname\":\"%@\",\"otherprono\":\"\",\"othersupplier\":\"%@\",\"otherproducter\":\"%@\",\"otherscope\":\"\",\"otherspecification\":\"\",\"otherprice\":\"%@\",\"othervalidtime\":\"11\",\"otheroptimal\":\"\",\"otherlack\":\"\",\"othernote\":\"%@\"},",proname.text,supplier.text,producter.text,price.text,note.text] atIndex:proStr.length - 1];
    }
    [proStr deleteCharactersInRange:NSMakeRange(proStr.length - 2, 1)];
    [str insertString:[NSString stringWithFormat:@"%@",proStr] atIndex:str.length-1];
    
    NSLog(@"竞品添加字符串:%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"添加竞品返回:%@",str1);
    if (str1.length != 0) {
        NSRange range = {1,str1.length-2};
        NSString *reallystr = [str1 substringWithRange:range];
        if ([reallystr isEqualToString:@"true"]) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"添加成功";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            [_hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_hud removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"添加失败";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            [_hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_hud removeFromSuperview];
            }];
        }
    }
}

@end
