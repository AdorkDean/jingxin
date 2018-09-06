//
//  DingDanSousuoViewController.m
//  YiRuanTong
//
//  Created by apple on 17/7/27.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "DingDanSousuoViewController.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "KHmanageModel.h"
#import "CommonModel.h"
#import "KHnameModel.h"
#import "CustCell.h"

@interface DingDanSousuoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)NSMutableArray *dataArray;//客户名
@property(nonatomic,retain)NSMutableArray *salerArray;//业务员
@property(nonatomic,retain)UIDatePicker *datePicker;

@end

@implementation DingDanSousuoViewController{
    UITextField *_orderTextfield;
    UIButton *_custButton;
    UIButton *_salerButton;
    UIButton *_startButton;
    UIButton *_endButton;
    
    NSString *_custId;
    NSString *_salerID;
    
    UITextField *_custField;
    UITextField *_salerField;
    
    UIView *_timeView;

    NSInteger _page;
    UIButton* _hide_keHuPopViewBut;
    NSString *_currentDateStr;
    NSString * _pastDateStr;
    NSInteger _custpage;
    NSInteger _salerpage;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [[NSMutableArray alloc]init];
    _salerArray = [[NSMutableArray alloc]init];
    _page = 1;
    _custpage = 1;
    _salerpage = 1;
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    [self getDateStr];
    [self createUIview];

}
- (void)getDateStr{
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"---当前的时间的字符串 =%@",currentDateStr);
    _currentDateStr = currentDateStr;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    NSLog(@"---前一个月 =%@",beforDate);
    _pastDateStr = beforDate;
}
- (void)createUIview{
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    orderLabel.text = @"订单号";
    orderLabel.textColor = UIColorFromRGB(0x333333);
    orderLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    orderLabel.font = [UIFont systemFontOfSize:15.0];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    _orderTextfield = [[UITextField alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH)];
    _orderTextfield.textAlignment = NSTextAlignmentCenter;
    _orderTextfield.textColor = UIColorFromRGB(0x999999);
    _orderTextfield.placeholder = @"请输入订单号";  // 提示文本
    [_orderTextfield setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_orderTextfield setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];

    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, orderLabel.bottom, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:orderLabel];
    [self.view addSubview:_orderTextfield];
    [self.view addSubview:nameView];
    //
    UILabel *custLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    custLabel.text = @"客户名称";
    custLabel.textColor = UIColorFromRGB(0x333333);
    custLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    custLabel.font = [UIFont systemFontOfSize:15.0];
    custLabel.textAlignment = NSTextAlignmentCenter;
    _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _custButton.frame = CGRectMake(KscreenWidth/3, nameView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_custButton setTitle:@"请选择名称" forState:UIControlStateNormal];
    [_custButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, custLabel.bottom, KscreenWidth, 1)];
    salerView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:custLabel];
    [self.view addSubview:_custButton];
    [self.view addSubview:salerView];
    //
    UILabel *salerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, salerView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    salerLabel.text = @"业务员";
    salerLabel.textColor = UIColorFromRGB(0x333333);
    salerLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    salerLabel.font = [UIFont systemFontOfSize:15.0];
    salerLabel.textAlignment = NSTextAlignmentCenter;
    _salerButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, salerView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton setTitle:@"请选择业务员" forState:UIControlStateNormal];
    [_salerButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, salerLabel.bottom, KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:salerLabel];
    [self.view addSubview:_salerButton];
    [self.view addSubview:typeView];
    
    //
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, typeView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    startLabel.text = @"开始时间";
    startLabel.textColor = UIColorFromRGB(0x333333);
    startLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    startLabel.font = [UIFont systemFontOfSize:15.0];
    startLabel.textAlignment = NSTextAlignmentCenter;
    _startButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(KscreenWidth/3, typeView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_startButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, startLabel.bottom, KscreenWidth, 1)];
    startView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:startLabel];
    [self.view addSubview:_startButton];
    [self.view addSubview:startView];
    //
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    endLabel.text = @"结束时间";
    endLabel.textColor = UIColorFromRGB(0x333333);
    endLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    endLabel.font = [UIFont systemFontOfSize:15.0];
    endLabel.textAlignment = NSTextAlignmentCenter;
    _endButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(KscreenWidth/3, startView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_endButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, endLabel.bottom, KscreenWidth, 1)];
    endView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:endLabel];
    [self.view addSubview:_endButton];
    [self.view addSubview:endView];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, endView.bottom)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:fenGeXian];
    
    //
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, fenGeXian.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, fenGeXian.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)search{
    if (_block) {
        
        _block(_custId,_salerID,_orderTextfield.text,_startButton.titleLabel.text,_endButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)custAction{
    _custButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.m_keHuPopView addSubview:bgView];
    //
//    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64,KscreenWidth - 100 , 40)];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag = 102;
    _custField.placeholder = @"名称关键字";
//    _custField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_custField addSubview:line2];
    _custField.font = [UIFont systemFontOfSize:13];
//    [self.m_keHuPopView addSubview:_custField];
    [bgView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, _custField.top, 60, _custField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchcust:) forControlEvents:UIControlEventTouchUpInside];//getTHName
//    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.custTableView == nil) {
//        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 104,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 30;
    self.custTableView.rowHeight = 50;
    [bgView addSubview:self.custTableView];
//    [self.m_keHuPopView addSubview:self.custTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    [self nameRequest];
    //     下拉刷新
    self.custTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _custpage = 1;
        [self searchcust:nil];
        // 结束刷新
        [self.custTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.custTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.custTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _custpage ++ ;
        [self searchcust:nil];
        [self.custTableView.mj_footer endRefreshing];
        
    }];
    _custpage = 1;
    [self searchcust:nil];
    
}
- (void)salerAction{
    _salerButton.userInteractionEnabled = NO;
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.m_keHuPopView addSubview:bgView];
    //
    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _salerField.backgroundColor = [UIColor whiteColor];
    _salerField.delegate = self;
    _salerField.placeholder = @"名称关键字";
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_salerField.height-1,_salerField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_salerField addSubview:line2];
    _salerField.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:_salerField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_salerField.right, _salerField.top, 60, _salerField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchsaler) forControlEvents:UIControlEventTouchUpInside];//getSalerName
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _salerField.bottom+5,bgView.width-40, bgView.height - _salerField.bottom - 5) style:UITableViewStylePlain];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.rowHeight = 50;
    [bgView addSubview:self.salerTableView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _salerpage = 1;
        [self searchsaler];
        // 结束刷新
        [self.salerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _salerpage ++ ;
        [self searchsaler];
        [self.salerTableView.mj_footer endRefreshing];
        
    }];
    [_dataArray removeAllObjects];
    _salerpage = 1;
    [self searchsaler];

    
}
//开始时间
- (void)startAction{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-270, KscreenWidth, 270)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 240)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [_startButton setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
//结束时间
- (void)endAction{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-270, KscreenWidth, 270)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 240)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
- (void)chongZhi
{
    _orderTextfield.text = @" ";
    [_custButton setTitle:@" "forState:UIControlStateNormal];
    _custId = @" ";
    [_salerButton setTitle:@" "forState:UIControlStateNormal];
    _salerID = @" ";
    _startButton.titleLabel.text = @" ";
    [_endButton setTitle:@" "forState:UIControlStateNormal];
}

#pragma mark - 客户名称请求方法


- (void)searchcust:(UIButton *)but{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    if (but) {
        _custpage = 1;
        [_dataArray removeAllObjects];
    }
    NSLog(@"客户名称数据:%@",_dataArray);

    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"table":@"khxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_custpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    if (_custpage == 1) {
        [_dataArray removeAllObjects];
    }
    NSLog(@"par>>>%@",params);
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户名称数据:%@",dic);

        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    KHmanageModel *model = [[KHmanageModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }

            }
            
            [self.custTableView reloadData];

        }
        NSLog(@"客户名称数据:%@",_dataArray);

        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
}

#pragma mark - 业务员名称请求方法


- (void)searchsaler{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_salerpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    if (_salerpage == 1) {
        [_salerArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic  in  array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_salerArray addObject:model];
                }
            }
            NSLog(@"业务员点击后返回:%@",_salerArray);

            [self.salerTableView reloadData];

        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
    


}



//监听datePicker值发生变化
- (void)dateChange:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_startButton setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}



//监听datePicker值发生变化
- (void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_endButton setTitle:dateString forState:UIControlStateNormal];
}

- (void)closePop
{
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
        [_orderTextfield resignFirstResponder];
        [_salerField resignFirstResponder];
    }else{
        _custButton.userInteractionEnabled = YES;
        _salerButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        [self.custTableView removeFromSuperview];
        [self.salerTableView removeFromSuperview];
    }
    
}


#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.custTableView){
        return _dataArray.count;
    }else{
        return _salerArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    if (tableView == self.salerTableView){
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        if (_salerArray.count != 0) {
            CommonModel *model = _salerArray[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }
    
    
    CustCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"CustCell"];
    if (cell3 == nil) {
        cell3 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell3.backgroundColor = [UIColor whiteColor];
    }
    if (tableView == self.custTableView){
        if (_dataArray.count!=0) {
            cell3.model = _dataArray[indexPath.row];
        }
        return cell3;
    }
    
    return cell3;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.custTableView){
        if (_dataArray.count!=0) {
            KHnameModel *model = _dataArray[indexPath.row];
            [_custButton setTitle:model.name forState:UIControlStateNormal];
            _custButton.userInteractionEnabled = YES;
            _custId = [NSString stringWithFormat:@"%@",model.Id];
        }

    }else if (tableView == self.salerTableView){
        if (_salerArray.count!=0) {
            CommonModel *model = _salerArray[indexPath.row];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerID = [NSString stringWithFormat:@"%@",model.Id];
            _salerButton.userInteractionEnabled = YES;
        }
    }
    [self.m_keHuPopView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  45;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
