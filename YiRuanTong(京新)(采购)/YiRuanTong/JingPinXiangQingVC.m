//
//  JingPinXiangQingVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "JingPinXiangQingVC.h"
#import "UIViewExt.h"
#import "CPINfoModel.h"
#import "MBProgressHUD.h"
#import "JingPinViewController.h"
#import "AFNetworking.h"
#import "KHmanageModel.h"
#import "DataService.h"
@interface JingPinXiangQingVC (){
    UIView *_timeView;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    NSInteger _page;
    NSString *_proid;
    NSString *_id;
    UIButton *_ChangeButton;
    MBProgressHUD *_hud;
    MBProgressHUD *_HUD;
    
    NSString *_currentDateStr;
    NSMutableArray *_viewArray;
    NSMutableArray *_text1Array;
    NSMutableArray *_text2Array;
    NSMutableArray *_text3Array;
    NSMutableArray *_text4Array;
    NSMutableArray *_text5Array;
    NSMutableArray *_text6Array;
    NSInteger _count;
    
    
    UIView *_ourProBackView;
}
@property (strong,nonatomic) NSMutableArray * shengArr;
@property (strong,nonatomic) NSMutableArray * shiArr;
@property (strong,nonatomic) NSMutableArray * xianArr;
@property (strong,nonatomic) NSArray *chanPinMingChenArr;

@property(nonatomic,retain)UITableView *proTableView;


@property (nonatomic) int ISCLICKWHERE;


@end

@implementation JingPinXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞品详情";
    self.navigationItem.rightBarButtonItem = nil;
    _page = 1;
    _viewArray = [NSMutableArray array];
    _text1Array = [NSMutableArray array];
    _text2Array = [NSMutableArray array];
    _text3Array = [NSMutableArray array];
    _text4Array = [NSMutableArray array];
    _text5Array = [NSMutableArray array];
    _text6Array = [NSMutableArray array];
    _dataArray1 = [NSMutableArray array];
   //initView
    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dataRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            //页面设置
            [self initView];
            [self initView2];
        });
    });

    
    
    
    
    //[self CPInfoRequest];
   //禁止button和textfield的点击事件
    self.shengButton.userInteractionEnabled = NO;
    self.shiButton.userInteractionEnabled = NO;
    self.xianButton.userInteractionEnabled = NO;
    self.chanPinMingChen1Button.userInteractionEnabled = NO;
    self.shengChanRiQi1Button.userInteractionEnabled = NO;
    self.shengChanRiQi2Button.userInteractionEnabled = NO;
    //textField
    self.chanPinMingChen2.userInteractionEnabled = NO;
    self.chanPinBianMa2.userInteractionEnabled = NO;
    self.gongYingShang1.userInteractionEnabled = NO;
    self.gongYingShang2.userInteractionEnabled = NO;
    self.shengChanChangJia1.userInteractionEnabled = NO;
    self.shengChanChangJia2.userInteractionEnabled = NO;
    self.shengChanFanWei1.userInteractionEnabled = NO;
    self.shengChanFanWei2.userInteractionEnabled = NO;
    self.guiGe1.userInteractionEnabled = NO;
    self.guiGe2.userInteractionEnabled = NO;
    self.danJia1.userInteractionEnabled = NO;
    self.danJia2.userInteractionEnabled = NO;
    self.baoZhiQi1.userInteractionEnabled = NO;
    self.baoZhiQi2.userInteractionEnabled = NO;
    self.youDian1.userInteractionEnabled = NO;
    self.youDian2.userInteractionEnabled = NO;
    self.queDian1.userInteractionEnabled = NO;
    self.queDian2.userInteractionEnabled = NO;
    self.beiZhu1.userInteractionEnabled = NO;
    self.beiZhu2.userInteractionEnabled = NO;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
}
#pragma mark - 本公司
- (void)initView{
    //滑动的scrollview
    _jingPinScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    
    self.jingPinScrollView.bounces = NO;
    self.jingPinScrollView.backgroundColor =[UIColor clearColor];
    self.jingPinScrollView.delegate =self;
    [self.view addSubview:_jingPinScrollView];
    _ourProBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 305)];
    _ourProBackView.backgroundColor = [UIColor whiteColor];
    [self.jingPinScrollView addSubview:_ourProBackView];
    _ourProBackView.userInteractionEnabled = NO;
    
    //    //修改按钮
    //    _ChangeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    _ChangeButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    //    [_ChangeButton setTitle:@"修改" forState:UIControlStateNormal];
    //    [_ChangeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_ChangeButton];
    //    self.navigationItem.rightBarButtonItem = right;
    //
    //产品详情
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label1.text = @"产品名称";
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [_ourProBackView addSubview:view1];
    [_ourProBackView addSubview:label1];
    _chanPinMingChen1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _chanPinMingChen1Button.titleLabel.font = [UIFont systemFontOfSize:13];
    [_chanPinMingChen1Button setTintColor:[UIColor blackColor]];
    _chanPinMingChen1Button.frame = CGRectMake(86, 0, KscreenWidth - 90, 40);
    _chanPinMingChen1Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_chanPinMingChen1Button addTarget:self action:@selector(chanpinmingchen) forControlEvents:UIControlEventTouchUpInside];
    [_ourProBackView addSubview:_chanPinMingChen1Button];
    
    [_chanPinMingChen1Button setTitle: _model.proname forState:UIControlStateNormal];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label2.text = @"供应商";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view2.backgroundColor = [UIColor grayColor];
    _gongYingShang1 =[[UITextField alloc] initWithFrame:CGRectMake(86, 41, KscreenWidth - 90, 40)];
    _gongYingShang1.font = [UIFont systemFontOfSize:13];
    _gongYingShang1.delegate = self;
    [_ourProBackView addSubview:label2];
    [_ourProBackView addSubview:view2];
    [_ourProBackView addSubview:_gongYingShang1];
    _gongYingShang1.text = _model.thissupplier;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label3.text = @"生产厂家";
    label3.backgroundColor = COLOR(231, 231, 231, 1);
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    _shengChanChangJia1 = [[UITextField alloc] initWithFrame:CGRectMake(86, 82, KscreenWidth - 90, 40)];
    _shengChanChangJia1.font = [UIFont systemFontOfSize:13];
    _shengChanChangJia1.delegate = self;
    [_ourProBackView addSubview:label3];
    [_ourProBackView addSubview:view3];
    [_ourProBackView addSubview:_shengChanChangJia1];
    _shengChanChangJia1.text  = _model.thisproducter;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label4.text = @"单价";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    view4.backgroundColor = [UIColor grayColor];
    _danJia1 = [[UILabel alloc] initWithFrame:CGRectMake(86, 123, KscreenWidth - 90, 40)];
    _danJia1.font = [UIFont systemFontOfSize:13];
    [_ourProBackView addSubview:label4];
    [_ourProBackView addSubview:view4];
    [_ourProBackView addSubview:_danJia1];
    _danJia1.text = [NSString stringWithFormat:@"%@",_model.thisprice];
    
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 140)];
    label6.text = @"备注";
    label6.backgroundColor = COLOR(231, 231, 231, 1);
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 304, KscreenWidth, 1)];
    view6.backgroundColor = [UIColor grayColor];
    _beiZhu1 = [[UITextView alloc]initWithFrame:CGRectMake(86, 164, KscreenWidth - 90, 140)];
    _beiZhu1.delegate = self;
    _beiZhu1.font = [UIFont systemFontOfSize:13];
    
    [_ourProBackView addSubview:label6];
    [_ourProBackView addSubview:view6];
    [_ourProBackView addSubview:_beiZhu1];
    _beiZhu1.text = _model.thisnote;
    //竖线
    UIView *fenge = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 305)];
    fenge.backgroundColor = [UIColor grayColor];
    [_ourProBackView addSubview:fenge];
    //
    //ID
    _proid = _model.thisproid;
    _shengId = _model.province;
    _shiId = _model.city;
    _xianId = _model.county;
    _id = _model.Id;
    
}
#pragma mark - 同行业的产品数据请求
- (void)dataRequest{
    /*
     competing
     action:"tonghangchanpin"
     1:"1"
     data:"{"comptingid":"42"}"
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/competing"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=tonghangchanpin&data={\"comptingid\":\"%@\"}",_model.Id];
    NSLog(@"字符串%@",str);
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil){
        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"产品信息返回:%@",array);
        for (NSDictionary *dic in array) {
            JPmanageModel *model = [[JPmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
        }
        _count = array.count;
        
    }
}
#pragma mark - 同行业
- (void)initView2{
    
    self.jingPinScrollView.contentSize = CGSizeMake(0, _count*350 +310);
    for (int i = 0; i < _count; i ++) {
        
        JPmanageModel *model =  _dataArray1[i];
        UIView *sameProduct = [[UIView alloc] initWithFrame:CGRectMake(0, 350*i + 310 , KscreenWidth, 350)];
        sameProduct.backgroundColor = [UIColor whiteColor];
        [_jingPinScrollView addSubview:sameProduct];
        sameProduct.userInteractionEnabled = NO;
        sameProduct.tag = 300+i;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-140, 0, 280, 40)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"同行业产品信息";
        [sameProduct addSubview:titleLabel];
        
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
        [sameProduct addSubview:field1];
        [_text1Array addObject:field1];
        field1.text = model.otherproname;
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
        [sameProduct addSubview:label2];
        [sameProduct addSubview:view2];
        [sameProduct addSubview:field2];
        [_text2Array addObject:field2];
        field2.text = model.othersupplier;
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
        [sameProduct addSubview:label3];
        [sameProduct addSubview:view3];
        [sameProduct addSubview:field3];
        [_text3Array addObject:field3];
        field3.text = model.otherproducter;
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
        field4.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [sameProduct addSubview:label4];
        [sameProduct addSubview:view4];
        [sameProduct addSubview:field4];
        [_text4Array addObject:field4];
        field4.text = [NSString stringWithFormat:@"%@",model.otherprice];
               UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 140)];
        label6.text = @"备注";
        label6.backgroundColor = COLOR(231, 231, 231, 1);
        label6.font =[UIFont systemFontOfSize:10];
        label6.textAlignment =NSTextAlignmentCenter;
        UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 345, KscreenWidth, 1)];
        view6.backgroundColor = [UIColor grayColor];
        UITextView *field6 = [[UITextView alloc] initWithFrame:CGRectMake(86, 205, KscreenWidth - 90, 140)];
        field6.font = [UIFont systemFontOfSize:13];
        [sameProduct addSubview:label6];
        [sameProduct addSubview:view6];
        [sameProduct addSubview:field6];
        [_text6Array addObject:field6];
        field6.text = model.othernote;
        //
        UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 41, 1, 305)];
        shu.backgroundColor = [UIColor grayColor];
        [sameProduct addSubview:shu];
        
    }
    
}
#pragma mark - 客户名称
//产品信息的  按钮
-(void)chanpinmingchen
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
    
    self.keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.keHuPopView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_keHuPopView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.keHuPopView addSubview:btn];
    
    if (self.proTableView == nil) {
        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.proTableView.backgroundColor = [UIColor grayColor];
    }
    self.proTableView.dataSource = self;
    self.proTableView.delegate = self;
    self.proTableView.tag = 10;
    [self.keHuPopView addSubview:self.proTableView];
    [self.view addSubview:self.keHuPopView];

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
    if (data1 != nil){
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",array);
        _dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CPINfoModel *model = [[CPINfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.tableView reloadData];

    }
}

//省
-(void)shengButtonClickMethod
{
    self.ISCLICKWHERE = 0;
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
    
    NSArray * dict8 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    self.arr = dict8;
    self.shengArr = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < dict8.count; i++) {
        NSString * str = dict8[i][@"name"];
        
        [self.shengArr addObject:str];
    }
    self.keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.keHuPopView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_keHuPopView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.keHuPopView addSubview:btn];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.keHuPopView addSubview:self.tableView];
    [self.view addSubview:self.keHuPopView];
    
    [self.tableView reloadData];
}

- (void)closePop
{
    [self.keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
    
}
//市    钮点击方法
-(void)shiButtonClickMethod
{
    /*市
     http://182.92.96.58:8005/yrt/servlet/customer
     parentid	1
     action	getCity
     params	{"newinfo":"true"}
     table	xzqy*/
    self.ISCLICKWHERE = 1;
    //市 接口   解析good
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCity&params={\"newinfo\":\"true\"}&table=xzqy",self.shengId];
    NSLog(@"str = %@",str);
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray * dict8 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    self.m_arr = dict8;
    NSLog(@"市信息:%@",self.m_arr);
    self.shiArr = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < dict8.count; i++) {
        NSString * str = dict8[i][@"name"];
        [self.shiArr addObject:str];
    }
    
    self.keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.keHuPopView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_keHuPopView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.keHuPopView addSubview:btn];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.keHuPopView addSubview:self.tableView];
    [self.view addSubview:self.keHuPopView];
    
    [self.tableView reloadData];
    
}
//县    钮点击方法
-(void)xianButtonClickMethod
{
    self.ISCLICKWHERE = 2;
    //县 接口   解析good
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCounties&params={\"newinfo\":\"true\"}&table=xzqy",self.shiId];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSArray * dict8 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    self.mm_arr = dict8;
    NSLog(@"县信息:%@",self.mm_arr);
    self.xianArr = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < dict8.count; i++) {
        NSString * str = dict8[i][@"name"];
        [self.xianArr addObject:str];
    }
    
    self.keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.keHuPopView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_keHuPopView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.keHuPopView addSubview:btn];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.keHuPopView addSubview:self.tableView];
    [self.view addSubview:self.keHuPopView];
    
    [self.tableView reloadData];
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


#pragma mark - TableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.ISCLICKWHERE == 0) {
        return self.shengArr.count;
    }else if(self.ISCLICKWHERE == 1){
        return self.shiArr.count;
    }else if(self.ISCLICKWHERE ==2){
        return self.xianArr.count;
    }else{
        return _dataArray.count;
    }
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
    if (self.ISCLICKWHERE == 0) {
        cell.textLabel.text = self.shengArr[indexPath.row];
        return cell;
        
    }else if(self.ISCLICKWHERE == 1){
        cell.textLabel.text = self.shiArr[indexPath.row];
         return cell;
    }
    else if (self.ISCLICKWHERE == 2){
        
        cell.textLabel.text = self.xianArr[indexPath.row];
         return cell;
    }else if (self.ISCLICKWHERE == 3){
        
        CPINfoModel *model = [_dataArray objectAtIndex:indexPath.row];
        NSLog(@"产品名字:%@",model.proname);
        cell.textLabel.text = model.proname;
        self.chanPinBianMa1.text = [NSString stringWithFormat:@"%@", model.prono];
        self.guiGe1.text = model.specification;
        self.danJia1.text = [NSString stringWithFormat:@"%@",model.proprice];
        return cell;
    }
    return cell;
}
//点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.keHuPopView removeFromSuperview];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.ISCLICKWHERE == 0) {
        
        [self.shengButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        NSDictionary * shengID = self.arr[indexPath.row];
        self.shengId = shengID[@"placeid"];
        
    }else if(self.ISCLICKWHERE == 1)
    {
        [self.shiButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        
        NSDictionary *shiID = self.m_arr[indexPath.row];
        self.shiId = shiID[@"placeid"];
    }
    else if (self.ISCLICKWHERE == 2){
        
        [self.xianButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        NSDictionary *xianID = self.mm_arr[indexPath.row];
        self.xianId = xianID[@"placeid"];
        
    }else if (self.ISCLICKWHERE == 3){
        
        CPINfoModel *model = [_dataArray objectAtIndex:indexPath.row];
        [self.chanPinMingChen1Button setTitle:cell.textLabel.text forState:UIControlStateNormal];
        _chanPinBianMa1.text = [NSString stringWithFormat:@"%@",model.prono];
        _guiGe1.text = [NSString stringWithFormat:@"%@",model.specification];
        _danJia1.text = [NSString stringWithFormat:@"%@",model.proprice];
        _proid = model.Id;
    }
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
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_timeView addSubview:_datePicker];
    [self.view addSubview:_timeView];
}

//监听datePicker值发生变化
-(void)dateChange:(id) sender
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
    [self.shengChanRiQi1Button setTitle:dateString forState:UIControlStateNormal];
}

//时间点击事件
-(void)date2
{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, KscreenWidth, 270)];
    _timeView.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth,230)];
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

- (void)closetime
{
    [_timeView removeFromSuperview];
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
    [self.shengChanRiQi2Button setTitle:dateString forState:UIControlStateNormal];
}

//修改的点击方法
- (void)change{
    if ([_ChangeButton.titleLabel.text isEqualToString:@"修改"]) {
        [_ChangeButton setTitle:@"确定" forState:UIControlStateNormal];
        self.shengButton.userInteractionEnabled = YES;
        self.shiButton.userInteractionEnabled = YES;
        self.xianButton.userInteractionEnabled = YES;
        self.chanPinMingChen1Button.userInteractionEnabled = YES;
        self.shengChanRiQi1Button.userInteractionEnabled = YES;
        self.shengChanRiQi2Button.userInteractionEnabled = YES;
        //textField
        self.chanPinMingChen2.userInteractionEnabled = YES;
        self.chanPinBianMa2.userInteractionEnabled = YES;
        self.gongYingShang1.userInteractionEnabled = YES;
        self.gongYingShang2.userInteractionEnabled = YES;
        self.shengChanChangJia1.userInteractionEnabled = YES;
        self.shengChanChangJia2.userInteractionEnabled = YES;
        self.shengChanFanWei1.userInteractionEnabled = YES;
        self.shengChanFanWei2.userInteractionEnabled = YES;
        self.guiGe1.userInteractionEnabled = YES;
        self.guiGe2.userInteractionEnabled = YES;
        self.danJia1.userInteractionEnabled = YES;
        self.danJia2.userInteractionEnabled = YES;
        self.baoZhiQi1.userInteractionEnabled = YES;
        self.baoZhiQi2.userInteractionEnabled = YES;
        self.youDian1.userInteractionEnabled = YES;
        self.youDian2.userInteractionEnabled = YES;
        self.queDian1.userInteractionEnabled = YES;
        self.queDian2.userInteractionEnabled = YES;
        self.beiZhu1.userInteractionEnabled = YES;
        self.beiZhu2.userInteractionEnabled = YES;
//        for (int i = 0; i < _count; i ++) {
//             UIView *view = _viewArray[i];
//            view.userInteractionEnabled = YES;
//        }
       
    }else if([_ChangeButton.titleLabel.text isEqualToString:@"确定"]){
    
        [self sure];
    }
}
-(void)sure
{
    /*
     修改的接口
     http://192.168.1.238:8080/lx/servlet/competing
     data	  {"table":"jpgl","id":"","province":"1","city":"36","county":"47","thisproid":"73","thisproname":"氟苯尼考","otherproname":"默默","thisprono":"P201410280030","otherprono":"","thissupplier":"","othersupplier":"","thisproducter":"","otherproducter":"","thisscope":"","otherscope":"","thisspecification":"25kg/桶","otherspecification":"","thisprice":"39","otherprice":"","thisproducetime":"2015-2-5","otherproducetime":"2015-2-5","thisvalidtime":"","othervalidtime":"","thisoptimal":"","otheroptimal":"","thislack":"","otherlack":"","thisnote":"","othernote":""}
     action	add
     table	   jpgl
     */
    
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/competing"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"data={\"table\":\"jpgl\",\"id\":\"%@\",\"province\":\"%@\",\"city\":\"%@\",\"county\":\"%@\",\"thisproid\":\"%@\",\"thisproname\":\"%@\",\"otherproname\":\"%@\",\"thisprono\":\"%@\",\"otherprono\":\"%@\",\"thissupplier\":\"%@\",\"othersupplier\":\"%@\",\"thisproducter\":\"%@\",\"otherproducter\":\"%@\",\"thisscope\":\"%@\",\"otherscope\":\"%@\",\"thisspecification\":\"%@\",\"otherspecification\":\"%@\",\"thisprice\":\"%@\",\"otherprice\":\"%@\",\"thisproducetime\":\"%@\",\"otherproducetime\":\"%@\",\"thisvalidtime\":\"%@\",\"othervalidtime\":\"%@\",\"thisoptimal\":\"%@\",\"otheroptimal\":\"%@\",\"thislack\":\"%@\",\"otherlack\":\"%@\",\"thisnote\":\"%@\",\"othernote\":\"%@\"}&action=update&table=jpgl",_id,self.shengId,self.shiId,self.xianId,_proid,self.chanPinMingChen1Button.titleLabel.text,self.chanPinMingChen2.text,self.chanPinBianMa1.text,self.chanPinBianMa2.text,self.gongYingShang1.text,self.gongYingShang2.text,self.shengChanChangJia1.text,self.shengChanChangJia2.text,self.shengChanFanWei1.text,self.shengChanFanWei2.text,self.guiGe1.text,self.guiGe2.text,_danJia1.text,self.danJia2.text,self.shengChanRiQi1Button.titleLabel.text,self.shengChanRiQi2Button.titleLabel.text,self.baoZhiQi1.text,self.baoZhiQi2.text,self.youDian1.text,self.youDian2.text,self.queDian1.text,self.queDian2.text,self.beiZhu1.text,self.beiZhu2.text];
    
    NSLog(@"竞品修改字符串:%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"修改返回:%@",str1);
    if (str1.length != 0) {
        NSRange range = {1,str1.length-2};
        NSString *reallystr = [str1 substringWithRange:range];
        if ([reallystr isEqualToString:@"true"]) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"修改成功";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            [_hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_hud removeFromSuperview];
            }];
            _ChangeButton.userInteractionEnabled = NO;
        }else {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"修改失败";
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
