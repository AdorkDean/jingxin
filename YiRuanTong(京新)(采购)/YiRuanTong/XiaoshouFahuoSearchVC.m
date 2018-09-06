//
//  XiaoshouFahuoSearchVC.m
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "XiaoshouFahuoSearchVC.h"
#import "UIViewExt.h"
#import "AFNetworking.h"
#import "DataPost.h"
#import "THCPModel.h"
#import "DWandLXModel.h"
#import "THCpInfoCell.h"
#import "CustModel.h"
@interface XiaoshouFahuoSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *areaTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;

@end

@implementation XiaoshouFahuoSearchVC
{
    UIButton *_salerButton;
    UIButton *_areaButton;
    UIButton *_startButton;
    UIButton *_endButton;
    
    //搜索
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    UIView *_timeView;
    NSString *_salerId;
    UITextField *_proField;
    UITextField *_custField;
//    NSMutableArray *_dataArray;
    NSString *_areaId;
    NSMutableArray *_areaArray;
    NSMutableArray * _proArray;
    
    NSString *_pastDateStr;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _propage;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
//    _dataArray = [[NSMutableArray alloc]init];
    _areaArray = [[NSMutableArray alloc]init];
    _proArray = [[NSMutableArray alloc]init];
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
    ///
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    Label1.text = @"销售员";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    [_salerButton setTintColor:UIColorFromRGB(0x999999)];
    [_salerButton setTitle:@"请选择销售员" forState:UIControlStateNormal];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*MYWIDTH, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label1];
    [self.view addSubview:_salerButton];
    [self.view addSubview:nameView];
    //
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label4.text = @"产品名称";
    Label4.backgroundColor = COLOR(231, 231, 231, 1);
    Label4.font = [UIFont systemFontOfSize:15.0];
    Label4.textAlignment = NSTextAlignmentCenter;
    
    _areaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _areaButton.frame = CGRectMake(KscreenWidth/3, Label1.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_areaButton addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    [_areaButton setTintColor:UIColorFromRGB(0x999999)];
    [_areaButton setTitle:@"请选择产品" forState:UIControlStateNormal];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label4];
    [self.view addSubview:_areaButton];
    [self.view addSubview:view4];
    //
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label4.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label2.text = @"开始时间";
    Label2.backgroundColor = COLOR(231, 231, 231, 1);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(KscreenWidth/3, Label4.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_startButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, Label2.bottom , KscreenWidth, 1)];
    salerView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label2];
    [self.view addSubview:_startButton];
    [self.view addSubview:salerView];
    //
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label2.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label3.text = @"结束时间";
    Label3.backgroundColor = COLOR(231, 231, 231, 1);
    Label3.font = [UIFont systemFontOfSize:15.0];
    Label3.textAlignment = NSTextAlignmentCenter;
    _endButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(KscreenWidth/3, Label2.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_endButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, Label3.bottom, KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label3];
    [self.view addSubview:_endButton];
    [self.view addSubview:typeView];
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, _endButton.bottom)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:fenGeXian];
    //
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, typeView.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, typeView.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)search{
    NSString *_saler = _salerButton.titleLabel.text;
    if ([_saler isEqualToString:@"请选择销售员"]) {
        _saler = @"";
    }
    NSString *_area = _areaButton.titleLabel.text;
    if ([_area isEqualToString:@"请选择产品"]) {
        _area = @"";
    }
    if (_block) {
        self.block(_areaId, _salerId, _startButton.titleLabel.text, _endButton.titleLabel.text, @"", @"");
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//产品
- (void)proAction{
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
    //    _proField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _proField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _proField.backgroundColor = [UIColor whiteColor];
    _proField.delegate = self;
    _proField.placeholder = @"名称关键字";
    //    _proField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_proField.height-1,_proField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_proField addSubview:line2];
    _proField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_proField];
    [bgView addSubview:_proField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_proField.right, _proField.top, 60, _proField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchpro) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.proTableView == nil) {
        //        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _proField.bottom+5,bgView.width-40, bgView.height - _proField.bottom - 5) style:UITableViewStylePlain];
        self.proTableView.backgroundColor = [UIColor whiteColor];
    }
    self.proTableView.dataSource = self;
    self.proTableView.delegate = self;
    self.proTableView.tag = 102;
    self.proTableView.rowHeight = 80;
    [bgView addSubview:self.proTableView];
    //    [self.m_keHuPopView addSubview:self.proTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.proTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _propage = 1;
        [self searchpro];
        // 结束刷新
        [self.proTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.proTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.proTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _propage ++ ;
        [self searchpro];
        [self.proTableView.mj_footer endRefreshing];
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //    [self proRequest];
    _propage = 1;
    [self searchpro];
}
- (void)searchpro{
    [_proArray removeAllObjects];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *pro = _proField.text;
    pro = [self convertNull:pro];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order?action=fuzzyQuery"];
    NSDictionary *params = @{@"action":@"fuzzyQuery",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"table":@"fhxx",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\"}",pro]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dictResponse =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        [hud hide:YES];
        NSLog(@"产品数据%@",dictResponse);
        
        NSMutableArray * rowArr = dictResponse[@"rows"];
        _proArray = [NSMutableArray array];
        for (NSDictionary *dic in rowArr) {
            CPINfoModel *model = [[CPINfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_proArray addObject:model];
        }
        [self.proTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"产品加载失败");
    }];
    
}
- (void)nameAction{
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
    //    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  1001;
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
    [btn addTarget:self action:@selector(searchcust) forControlEvents:UIControlEventTouchUpInside];//getName
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.areaTableView == nil) {
        //        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.areaTableView.backgroundColor = [UIColor whiteColor];
    }
    self.areaTableView.dataSource = self;
    self.areaTableView.delegate = self;
    self.areaTableView.tag = 10002;
    self.areaTableView.rowHeight = 45;
    [bgView addSubview:self.areaTableView];
    //    [self.m_keHuPopView addSubview:self.salerTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //    [self nameRequest];
    //     下拉刷新
    self.areaTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _propage = 1;
        [self searchcust];
        // 结束刷新
        [self.areaTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.areaTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.areaTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _propage ++ ;
        [self searchcust];
        [self.areaTableView.mj_footer endRefreshing];
        
    }];
    _propage = 1;
    [self searchcust];
    
}
- (void)searchcust{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    if (_propage == 1) {
        [_areaArray removeAllObjects];
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"ddxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                NSLog(@"客户名称数据:%@",array);
                for (NSDictionary *dic in array) {
                    CustModel *model = [[CustModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_areaArray addObject:model];
                }
            }
            
        }
        [self.areaTableView reloadData];

        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
    
}
- (void)startAction{
    
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
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
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
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
- (void)chongZhi
{
    [_salerButton setTitle:@"" forState:UIControlStateNormal];
    [_startButton setTitle:@"" forState:UIControlStateNormal];
    [_endButton setTitle:@"" forState:UIControlStateNormal];
    [_areaButton setTitle:@"" forState:UIControlStateNormal];
}
- (void)closePop
{
    if ([self keyboardDid]) {
        [_proField resignFirstResponder];
        
    }else{
        _salerButton.userInteractionEnabled = YES;
        
        [self.m_keHuPopView removeFromSuperview];
    }
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
#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.proTableView) {
        return _proArray.count;
    }else{
        return _areaArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.areaTableView){
        //定义个静态字符串为了防止与其他类的tableivew重复
        static NSString *CellIdentifier =@"Cell";
        //定义cell的复用性当处理大量数据时减少内存开销
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
            
        }
        if (_areaArray.count != 0) {
            CustModel *model = _areaArray[indexPath.row];
            cell.textLabel.text = model.name;
        }
        return cell;
    }else{
    THCpInfoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"THCpInfoCell"];
    if (cell1 == nil) {
        cell1 = (THCpInfoCell *) [[[NSBundle mainBundle] loadNibNamed:@"THCpInfoCell" owner:self options:nil]firstObject];
    }
    if (_proArray.count!=0) {
        cell1.model = _proArray[indexPath.row];
    }
    return cell1;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.proTableView){
        
        [self.m_keHuPopView removeFromSuperview];
        if (_proArray.count!=0) {
            CPINfoModel *model = _proArray[indexPath.row];
            [_areaButton setTitle:model.proname forState:UIControlStateNormal];
            _areaId = model.Id;
        }
    }else if(tableView == self.areaTableView){
        
        [self .m_keHuPopView removeFromSuperview];
        CustModel *model = _areaArray[indexPath.row];
        [_salerButton setTitle:model.name forState:UIControlStateNormal];
        _salerId = model.Id;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.proTableView) {
        return 75;
    }
    return  45;
    
}
@end
