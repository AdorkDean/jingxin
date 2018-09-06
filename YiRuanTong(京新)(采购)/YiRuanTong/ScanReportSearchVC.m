//
//  ScanReportSearchVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ScanReportSearchVC.h"
#import "UIViewExt.h"
#import "AFNetworking.h"
#import "DataPost.h"
#import "THCPModel.h"
#import "DWandLXModel.h"
#import "THCpInfoCell.h"
#import "TypeRbModel.h"
#import "TongjiModel.h"
@interface ScanReportSearchVC ()
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *areaTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation ScanReportSearchVC
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
    NSMutableArray *_dataArray;
    NSString *_areaId;
    NSMutableArray *_areaArray;
    
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
    _dataArray = [[NSMutableArray alloc]init];
    _areaArray = [[NSMutableArray alloc]init];
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
    Label1.text = @"姓名";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    [_salerButton setTintColor:UIColorFromRGB(0x999999)];
    [_salerButton setTitle:@"请选择姓名" forState:UIControlStateNormal];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*MYWIDTH, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label1];
    [self.view addSubview:_salerButton];
    [self.view addSubview:nameView];
    //
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label4.text = @"日志类型";
    Label4.backgroundColor = COLOR(231, 231, 231, 1);
    Label4.font = [UIFont systemFontOfSize:15.0];
    Label4.textAlignment = NSTextAlignmentCenter;
    
    _areaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _areaButton.frame = CGRectMake(KscreenWidth/3, Label1.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_areaButton addTarget:self action:@selector(areaAction) forControlEvents:UIControlEventTouchUpInside];
    [_areaButton setTintColor:UIColorFromRGB(0x999999)];
    [_areaButton setTitle:@"请选择类型" forState:UIControlStateNormal];
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
//    if ([_salerButton.titleLabel.text isEqualToString:@"请选择姓名"]) {
//        [self showAlert:@"请选择姓名"];
//        return;
//    }
    NSString *_saler = _salerButton.titleLabel.text;
    if ([_saler isEqualToString:@"请选择姓名"]) {
        _saler = @"";
    }
    NSString *_area = _areaButton.titleLabel.text;
    if ([_area isEqualToString:@"请选择类型"]) {
        _area = @"";
        _areaId = @"";
    }
    if (_block) {
        self.block(_saler, _area, _areaId,_startButton.titleLabel.text, _endButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//产品
- (void)salerAction{
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
    if (self.index == 0) {
        [self searchpro];
    }else{
        [self searchpros];
    }
    
}
- (void)searchpros{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
//    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_propage],@"action":@"getBeansDepart",@"allflag":@"1",@"table":@"rzsb",@"params":@"{\"isreplyEQ\":\"0\"}"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_propage],@"action":@"getCountDepart",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"isstop\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",@"",@"0",_pastDateStr,_currentDateStr]};
    if (_propage == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    TongjiModel *model = [[TongjiModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.proTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
    
}
- (void)searchpro{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    //    NSString *proName = _salerField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_propage],@"action":@"getCountDepart",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"isstop\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",@"",@"0",_pastDateStr,_currentDateStr]};
    if (_propage == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    TongjiModel *model = [[TongjiModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.proTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
    
}
//区域
- (void)areaAction{
    
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
    if (self.areaTableView == nil) {
        self.areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-160) style:UITableViewStylePlain];
        self.areaTableView.backgroundColor = [UIColor whiteColor];
    }
    self.areaTableView.dataSource = self;
    self.areaTableView.delegate = self;
    self.areaTableView.rowHeight = 45;
    [self.m_keHuPopView addSubview:self.areaTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self areaRquest];
    
}
- (void)areaRquest{
    
    NSString *strAdress = @"/dailyreport";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getTypeComBox";
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            [_areaArray removeAllObjects];
            NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            NSLog(@"日志类型输出:%@",array);
            for (NSDictionary * dic in array) {
                TypeRbModel *model = [[TypeRbModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_areaArray addObject:model];
            }
            [self.areaTableView reloadData];
        }
    }
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
    _salerId = @"";
    _areaId = @"";
     [_salerButton setTitle:@""forState:UIControlStateNormal];
     [_areaButton setTitle:@""forState:UIControlStateNormal];
    _salerButton.titleLabel.text = @"";
    _areaButton.titleLabel.text = @"";
    [_startButton setTitle:@""forState:UIControlStateNormal];
    [_endButton setTitle:@""forState:UIControlStateNormal];
    _startButton.titleLabel.text = @"";
    _endButton.titleLabel.text = @"";
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
        return _dataArray.count;
    }else{
        return _areaArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cell";
    if (tableView == self.areaTableView){
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        if (_areaArray.count != 0) {
            TypeRbModel *model = _areaArray[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }
    
    
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cellgod"];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellgod"];
    }
    if (_dataArray.count!=0) {
        TongjiModel *model = _dataArray[indexPath.row];
        cell1.textLabel.text = model.name;
    }
    return cell1;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.proTableView){
        
        [self.m_keHuPopView removeFromSuperview];
        if (_dataArray.count!=0) {
            TongjiModel *model = _dataArray[indexPath.row];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerId = model.Id;
            
        }
    }else if(tableView == self.areaTableView){
        
        [self .m_keHuPopView removeFromSuperview];
        TypeRbModel *model = _areaArray[indexPath.row];
        [_areaButton setTitle:model.name forState:UIControlStateNormal];
        _areaId = model.Id;
        
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
