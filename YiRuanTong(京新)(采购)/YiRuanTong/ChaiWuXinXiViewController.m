//
//  ChaiWuXinXiViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ChaiWuXinXiViewController.h"
#import "ChaiWuCell.h"
#import "YuEDetailViewViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "XianJinCell.h"
#import "yinHangCell.h"
#import "MBProgressHUD.h"
#import "XianJinDetailView.h"
#import "YinHangZhangDetailView.h"
#import "XianJinZhangModel.h"
#import "YinHangZhangModel.h"
#import "YuEModel.h"
#import "BankMessageModel.h"

@interface ChaiWuXinXiViewController ()

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    UIRefreshControl *_refreshControl4;
    MBProgressHUD *_HUD;
    UIView *_searchView;
    UIView *_backView;
    UIView *_timeView;
    
    NSString *_currentDateStr;
    NSString *_bankID;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;
    NSMutableArray *_bankData;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
    NSInteger _page5;
    NSInteger _page6;
    
    
    UIButton *_xianJinButton;
    UIButton *_yinHangButton;
    UIButton *_yuEButton;
    UIButton *_currentBtn;
    NSMutableArray *_btnArray;
    UITextField *_order;
    UIButton *_startButton;
    UIButton *_endButton;
    UIButton *_bankButton;
    UITextField *_cardNo;
    UIButton* _hide_keHuPopViewBut;
}

@property(nonatomic,retain)UIDatePicker *datePicker;
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *bankTableView;

@end

@implementation ChaiWuXinXiViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray1 = [[NSMutableArray alloc] init];
    _page1 = 1;
    _dataArray2 = [[NSMutableArray alloc] init];
    _page2 = 1;
    _dataArray3 = [[NSMutableArray alloc] init];
    _page3 = 1;
    _btnArray = [[NSMutableArray alloc] init];
    _page4 = 1;

    self.title = @"财务信息";
    
    self.navigationItem.rightBarButtonItem = nil;
        //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DataRequest];
        [self DataRequest1];
        [self DataRequest2];
        [self DataRequest3];
        dispatch_async(dispatch_get_main_queue(), ^{
            //页面设置
            [self initView];
            //进度HUD
            _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //设置模式为进度框形的
            _HUD.mode = MBProgressHUDModeIndeterminate;
            _HUD.labelText = @"网络不给力，正在加载中...";
            [_HUD show:YES];

        });
    });
    

    
    //将搜索数据置空 默认
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    _order.text = @" ";
    [_startButton setTitle:@" "forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
   
}

#pragma mark - 搜索页面设置
- (void)searchView{
#pragma mark - 现金帐
    if (_currentBtn.tag == 0) {
        //右侧模糊视图
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 80, KscreenWidth/3, KscreenHeight -64 - 50)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        
        //信息视图
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, KscreenWidth/3*2, KscreenHeight - 64 -50)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"原始单号";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _order = [[UITextField alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40)];
        UIView *View1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        View1.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_order];
        [_searchView addSubview:View1];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"操作日期";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _startButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_startButton];
        [_searchView addSubview:salerView];
        //
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
        Label3.text = @"至";
        Label3.backgroundColor = COLOR(231, 231, 231, 1);
        Label3.font = [UIFont systemFontOfSize:15.0];
        Label3.textAlignment = NSTextAlignmentCenter;
        _endButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _endButton.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
        [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
        typeView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label3];
        [_searchView addSubview:_endButton];
        [_searchView addSubview:typeView];
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 150, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 150, 60, 30);
        [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
        _order.text = @" ";
        _startButton.titleLabel.text = @" ";
        [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    

#pragma mark - 银行帐
    }else if(_currentBtn.tag == 1){
        //右侧模糊视图
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 80, KscreenWidth/3, KscreenHeight -64 - 50)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        
        //信息视图
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, KscreenWidth/3*2, KscreenHeight - 64 -50)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"银行名称";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _bankButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _bankButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
        [_bankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bankButton addTarget:self action:@selector(bankAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *View1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        View1.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_bankButton];
        [_searchView addSubview:View1];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"操作日期";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _startButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_startButton];
        [_searchView addSubview:salerView];
        //
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
        Label3.text = @"至";
        Label3.backgroundColor = COLOR(231, 231, 231, 1);
        Label3.font = [UIFont systemFontOfSize:15.0];
        Label3.textAlignment = NSTextAlignmentCenter;
        _endButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _endButton.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
        [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
        typeView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label3];
        [_searchView addSubview:_endButton];
        [_searchView addSubview:typeView];
        
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 150, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 150, 60, 30);
        [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
        _bankID = @" ";
        _startButton.titleLabel.text = @" ";
        _endButton.titleLabel.text = @" ";
        [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];

#pragma mark - 余额
    }else if(_currentBtn.tag ==2){
        
        //右侧模糊视图
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 80, KscreenWidth/3, KscreenHeight -64 - 50)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        
        //信息视图
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, KscreenWidth/3*2, KscreenHeight - 64 -50)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"银行名称";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _bankButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _bankButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
        [_bankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bankButton addTarget:self action:@selector(bankAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *View1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        View1.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_bankButton];
        [_searchView addSubview:View1];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"卡号";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _cardNo = [[UITextField alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40)];
        
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_cardNo];
        [_searchView addSubview:salerView];
    
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 110, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 110, 60, 30);
        [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
        _bankButton.titleLabel.text = @" ";
        _cardNo.text = @" ";
        

    }
    
}
#pragma mark - 搜索页面点击方法
-(void)bankAction{
    _bankButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.bankTableView == nil) {
        self.bankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.bankTableView.backgroundColor = [UIColor grayColor];
    }
    self.bankTableView.dataSource = self;
    self.bankTableView.delegate = self;
    self.bankTableView.tag = 400;
    _refreshControl4 = [[UIRefreshControl alloc] init];
    
    [_refreshControl4 addTarget:self action:@selector(refreshData4) forControlEvents:UIControlEventValueChanged];
    [self.bankTableView addSubview:_refreshControl4];
    
    [bgView addSubview:self.bankTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self bankReqest];
}
- (void)bankReqest{
    /*
     http://182.92.96.58:8005/yrt/servlet/financinginfo
     action:"getBankIdList"
     params:""
     */
    _bankData = [NSMutableArray array];
    NSString *strAdress = @"/financinginfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getBankIdList&rows=20&params="""];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"搜索上传的字符串%@",str);
        NSLog(@"搜索列表数据:%@",array);
        for (NSDictionary *dic in array) {
            BankMessageModel *model = [[BankMessageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_bankData addObject:model];
        }
        [self.bankTableView reloadData];
    }
    

}
- (void)refreshData4
{//开始刷新
    _refreshControl4.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl4 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown4) userInfo:nil repeats:NO];
    
}
- (void)refreshDown4
{
    [_bankData removeAllObjects];
    _page1 = 1;
    [self bankAction];
    [_refreshControl4 endRefreshing];
}

- (void)closePop{
    
    [self.m_keHuPopView removeFromSuperview];
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
- (void)singleTapAction{
    [_backView removeFromSuperview];
    [_searchView removeFromSuperview];
    
}

- (void)souSuoButtonClickMethod
{
    [self searchView];
    
}
#pragma mark - 搜索方法
- (void)search
{
    [self searchData];
}


- (void)searchData
{
    /*
     http://182.92.96.58:8005/yrt/servlet/financinginfo
     action:"queryCashIO"
     page:"1"
     rows:"20"
     params:"{"isvalidEQ":"1","firstbillnoLIKE":"1111111111","ioflagEQ":"","statusEQ":"0","timeGE":"2015-05-11","timeLE":"2015-05-14","spstatusEQ":"0"}"
     */
    
    if (_currentBtn.tag == 0) {
        NSString *strAdress = @"/financinginfo";
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"action=queryCashIO&rows=20&page=%zi&params={\"isvalidEQ\":\"\",\"firstbillnoLIKE\":\"%@\",\"ioflagEQ\":\"\",\"statusEQ\":\"\",\"timeGE\":\"%@\",\"timeLE\":\"%@\",\"spstatusEQ\":\"\"}",_page4,_order.text,_startButton.titleLabel.text,_endButton.titleLabel.text];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"搜索上传的字符串%@",str);
            NSLog(@"搜索列表数据:%@",dic);
            NSArray *array = dic[@"rows"];
            [_dataArray1 removeAllObjects];
            for (NSDictionary *dic in array) {
                XianJinZhangModel *model = [[XianJinZhangModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
            [_HUD hide:YES];
            [self.xianJinTableView reloadData];
            [_searchView removeFromSuperview];
            [_backView removeFromSuperview];
        }
        
    }else if(_currentBtn.tag == 1){
        /* http://182.92.96.58:8005/yrt/servlet/financinginfo
         action:"queryBankIO"
         page:"1"
         rows:"20"
         params:"{"isvalidEQ":"1","bankidEQ":"4","opennameLIKE":"","ioflagEQ":"","statusEQ":"0","spstatusEQ":"0","timeGE":"2015-05-10","timeLE":"2015-05-15"}"
         */
        
        NSString *strAdress = @"/financinginfo";
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"action=queryBankIO&rows=20&page=%zi&params={\"isvalidEQ\":\"\",\"bankidEQ\":\"%@\",\"opennameLIKE\":\"\",\"ioflagEQ\":\"\",\"statusEQ\":\"\",\"spstatusEQ\":\"\",\"timeGE\":\"%@\",\"timeLE\":\"%@\"}",_page5,_bankID,_startButton.titleLabel.text,_endButton.titleLabel.text];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"搜索上传的字符串%@",str);
            NSLog(@"搜索列表数据:%@",array);
            
            [_dataArray2 removeAllObjects];
            for (NSDictionary *dic in array) {
                YinHangZhangModel *model = [[YinHangZhangModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
            [_HUD hide:YES];
            [self.yinHangTableView reloadData];
            [_searchView removeFromSuperview];
            [_backView removeFromSuperview];
            
        }
        
        
        
    }else if(_currentBtn.tag == 2){
        /*
         action:"bankBalance"
         page:"1"
         rows:"20"
         params:"{"banknameLIKE":"中国银行","opennameLIKE":"","cardnoLIKE":"6222003200210120125"}"
         */
        
        NSString *strAdress = @"/financinginfo";
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"action=bankBalance&rows=20&page=%zi&params={\"banknameLIKE\":\"%@\",\"opennameLIKE\":\"\",\"cardnoLIKE\":\"%@\"}",_page6,_bankButton.titleLabel.text,_cardNo.text];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"搜索上传的字符串%@",str);
            NSLog(@"搜索列表数据:%@",array);
            
            [_dataArray3 removeAllObjects];
            for (NSDictionary *dic in array) {
                YuEModel *model = [[YuEModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray3 addObject:model];
            }
            [_HUD hide:YES];
            [self.yuETableView reloadData];
            [_searchView removeFromSuperview];
            [_backView removeFromSuperview];
            
            
        }
        
        [_searchView removeFromSuperview];
        [_backView removeFromSuperview];
        
    }
}

- (void)chongZhi
{
    _order.text = @" ";
    _cardNo.text = @" ";
    [_bankButton setTitle:@" " forState:UIControlStateNormal];
    [_startButton setTitle:@" "forState:UIControlStateNormal];
    [_endButton setTitle:@" "forState:UIControlStateNormal];
}
#pragma mark - 页面设置
- (void)initView
{   //
    //标题下方的3个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 79)];
    buttonView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, KscreenWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttonView];
    [self.view addSubview:line];
    
    //显示现金余额的label
    self.xianJinYuE = [[UILabel alloc] initWithFrame:CGRectMake(87, 5,KscreenWidth - 90 , 20)];
    self.xianJinYuE.textColor = [UIColor whiteColor];
    self.xianJinYuE.font = [UIFont systemFontOfSize:16.0];
    [buttonView addSubview:self.xianJinYuE];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 85, 20)];
    label.font = [UIFont systemFontOfSize:17.0];
    label.text = @"现金余额:";
    label.textColor = [UIColor whiteColor];
    [buttonView addSubview:label];
    
    //搜索按钮的设置
    self.souSuoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.souSuoButton.frame = CGRectMake(5, 35, 40, 40);
    [self.souSuoButton setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [self.souSuoButton setBackgroundImage:[UIImage imageNamed:@"menu_return"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.souSuoButton];
    [self.souSuoButton addTarget:self action:@selector(souSuoButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //3个按钮的设置
    _xianJinButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 30,(KscreenWidth - 50)/3, 49)];
    [_xianJinButton setTitle:@"现金帐" forState:UIControlStateNormal];
    _xianJinButton.tag = 0;
    [_xianJinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_xianJinButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _xianJinButton.backgroundColor = [UIColor whiteColor];
    
    _currentBtn = _xianJinButton;
    _currentBtn.selected = YES;
    
    [_xianJinButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _xianJinButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_xianJinButton];
    [_btnArray addObject:_xianJinButton];
    
    _yinHangButton = [[UIButton alloc]initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/3, 30, (KscreenWidth - 50)/3, 49)];
    [_yinHangButton setTitle:@"银行帐" forState:UIControlStateNormal];
    _yinHangButton.tag = 1;
    [_yinHangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinHangButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _yinHangButton.backgroundColor = [UIColor lightGrayColor];
    
    [_yinHangButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _yinHangButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_yinHangButton];
    [_btnArray addObject:_yinHangButton];
    
    _yuEButton = [[UIButton alloc]initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/3*2, 30, (KscreenWidth - 50)/3, 49)];
    [_yuEButton setTitle:@"余额" forState:UIControlStateNormal];
    _yuEButton.tag = 2;
    [_yuEButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yuEButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _yuEButton.backgroundColor = [UIColor lightGrayColor];

    [_yuEButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _yuEButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_yuEButton];
    [_btnArray addObject:_yuEButton];
    
    //标题下方View的设置;
    //UIScrollerView
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80,KscreenWidth, KscreenHeight - 114)];
    self.mainScrollView.contentSize = CGSizeMake(KscreenWidth *3, KscreenHeight-114);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    //scrollView上面的三个tableview实例化 并且添加到scrollView上去
    
    _xianJinTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-144) style:UITableViewStylePlain];
    _xianJinTableView.delegate = self;
    _xianJinTableView.dataSource = self;
    _xianJinTableView.tag = 100;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_xianJinTableView addSubview:_refreshControl];
    [self.mainScrollView addSubview:_xianJinTableView];
    //     下拉刷新
    _xianJinTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_xianJinTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _xianJinTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _xianJinTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [_xianJinTableView.mj_footer endRefreshing];
    }];
    
   _yinHangTableView =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-144) style:UITableViewStylePlain];
    _yinHangTableView.delegate = self;
    _yinHangTableView.dataSource = self;
    _yinHangTableView.tag = 200;
//    _refreshControl2 = [[UIRefreshControl alloc] init];
//    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
//    [_yinHangTableView addSubview:_refreshControl2];
    [self.mainScrollView addSubview:_yinHangTableView];
    //     下拉刷新
    _yinHangTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown2];
        // 结束刷新
        [_yinHangTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _yinHangTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _yinHangTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh2];
        [_yinHangTableView.mj_footer endRefreshing];
    }];
   
    _yuETableView =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth * 2, 0, KscreenWidth, KscreenHeight-144) style:UITableViewStylePlain];
    _yuETableView.delegate=self;
    _yuETableView.dataSource=self;
    _yuETableView.tag = 300;
//    _refreshControl3 = [[UIRefreshControl alloc] init];
//    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl3 addTarget:self action:@selector(refreshData3) forControlEvents:UIControlEventValueChanged];
//    [_yuETableView addSubview:_refreshControl3];
    [self.mainScrollView addSubview:_yuETableView];
    //     下拉刷新
    _yuETableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown3];
        // 结束刷新
        [_yuETableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _yuETableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _yuETableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh3];
        [_yuETableView.mj_footer endRefreshing];
    }];
}

- (void)selectBtn:(UIButton *)btn
{
    if (btn != _currentBtn)
    {
        _currentBtn.selected = NO;
        _currentBtn.backgroundColor = [UIColor lightGrayColor];
        _currentBtn = btn;
    }
    _currentBtn.selected = YES;
    _currentBtn.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView setContentOffset:CGPointMake(btn.tag * KscreenWidth, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else {
        int i = scrollView.contentOffset.x/KscreenWidth;
        for (int j = 0; j < _btnArray.count; j++) {
            if (j == i) {
                if (_btnArray[i] != _currentBtn) {
                    _currentBtn.selected = NO;
                    _currentBtn.backgroundColor = [UIColor lightGrayColor];
                    _currentBtn = _btnArray[i];
                }
                _currentBtn.selected = YES;
                _currentBtn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)refreshData
{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown) userInfo:nil repeats:NO];
}

- (void)refreshDown
{
    [_dataArray1 removeAllObjects];
    _page1 = 1;
    [self DataRequest];
    [_refreshControl endRefreshing];
}

- (void)refreshData2
{
    //开始刷新
    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl2 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown2) userInfo:nil repeats:NO];
}

- (void)refreshDown2
{
    [_dataArray2 removeAllObjects];
    _page2 = 1;
    [self DataRequest1];
    [_refreshControl2 endRefreshing];
}

- (void)refreshData3
{
    //开始刷新
    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl3 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown3) userInfo:nil repeats:NO];
}

- (void)refreshDown3
{
    [_dataArray3 removeAllObjects];
    _page3 = 1;
    [self DataRequest2];
    
    [_refreshControl3 endRefreshing];
}

- (void)upRefresh1
{
    [_HUD show:YES];
    _page1++;
    [self DataRequest];
}

- (void)upRefresh2
{
    [_HUD show:YES];
    
    _page2++;
    [self DataRequest1];
}

- (void)upRefresh3
{
    [_HUD show:YES];
    _page3++;
    
    [self DataRequest2];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.tag == 100) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh1];
        }
    } else if (scrollView.tag == 200){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh2];
        }
    } else if (scrollView.tag == 300){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh3];
        }
    }
}
#pragma mark - 浏览数据
- (void)DataRequest{
    /*现金帐列表的接口：
     http://192.168.1.203:8080/lx/servlet/financinginfo
     rows	10
     mobile	true
     page	1
     action	queryCashIO
     */
    NSString *strAdress = @"/financinginfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"10",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page1],@"action":@"queryCashIO",@"isvalidEQ":@"1"};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        NSLog(@"现金帐%@",array);
        for (NSDictionary *dic in array) {
            XianJinZhangModel *model = [[XianJinZhangModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
        }
        [_xianJinTableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        
    }];
}

- (void)DataRequest1{
    /*银行帐列表的接口：
     http://192.168.1.203:8080/lx/servlet/financinginfo
     rows	10
     mobile	true
     page	1
     action	bankBalance
     */
    NSString *strAdress = @"/financinginfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"10",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page2],@"action":@"queryBankIO",@"isvalidEQ":@"1"};
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        NSLog(@"银行帐%@",array);
        for (NSDictionary *dic in array) {
            YinHangZhangModel *model = [[YinHangZhangModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray2 addObject:model];
        }
        [_yinHangTableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];

        
    }];
}

- (void)DataRequest2
{
  /*余额列表的接口：
  http://192.168.1.203:8080/lx/servlet/financinginfo
  rows	10
  mobile	true
  page	1
  action	bankBalance
  */
    NSString *strAdress = @"/financinginfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"10",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page3],@"action":@"bankBalance"};
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            YuEModel *model = [[YuEModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray3 addObject:model];
        }
        NSLog(@"余额:%@",array);
        [_yuETableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];

        
    }];
}

- (void)DataRequest3
{/*
  现金余额的接口：
  http://192.168.1.203:8080/lx/servlet/financinginfo
  mobile	true
  action	cashBalance
  */
    NSString *strAdress = @"/financinginfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"mobile":@"true",@"action":@"cashBalance"};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"现金余额:%@",responseObject);
        NSArray *array = (NSArray *)responseObject;
        if (array.count > 0) {
            NSDictionary *dic = array[0];
            self.xianJinYuE.text = [NSString stringWithFormat:@"%@",dic[@"balance"]];
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];

       
    }];
}

#pragma mark UITableViewDelegataAndDataSource协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100){
        return _dataArray1.count;
    } else if(tableView.tag == 200){
        
        return _dataArray2.count;
        
    } else if (tableView.tag == 300){
        
        return _dataArray3.count;
    } else if (tableView.tag == 400){
        return _bankData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    XianJinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell =(XianJinCell *) [[[NSBundle mainBundle] loadNibNamed:@"XianJinCell" owner:self options:nil]firstObject];
    }
    yinHangCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(yinHangCell*)[[[NSBundle mainBundle] loadNibNamed:@"yinHangCell" owner:self options:nil]firstObject];
    }
    ChaiWuCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 =(ChaiWuCell*)[[[NSBundle mainBundle]loadNibNamed:@"ChaiWuCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell3 == nil) {
        cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell3.backgroundColor = [UIColor grayColor];
        cell3.textLabel.textColor = [UIColor whiteColor];
    }
    if (tableView.tag == 100) {
            if (_dataArray1.count != 0) {
                XianJinZhangModel *model = [_dataArray1 objectAtIndex:indexPath.row];
                int ioflag = [model.ioflag intValue];
                if (ioflag == 1) {
                    cell.nameLabel.text = @"入账金额：";
                    cell.inOrOut.text = @"入账";
                    cell.inMoney.text = [NSString stringWithFormat:@"%@",model.inmoney];
                } else {
                    cell.nameLabel.text = @"出帐金额：";
                    cell.inOrOut.text = @"出账";
                    cell.inMoney.text = [NSString stringWithFormat:@"%@",model.outmoney];
                }
                cell.creator.text = model.creator;
                cell.createTime.text = model.createtime;
            }
        
         return cell;
    } else if (tableView.tag == 200){
        
        if (_dataArray2.count != 0) {
            YinHangZhangModel *model = [_dataArray2 objectAtIndex:indexPath.row];
            cell1.inMoney.text = [NSString stringWithFormat:@"%@",model.inmoney];
            cell1.bankName.text = model.bankname;
            cell1.createTime.text = model.createtime;
            int ioflag = [model.ioflag intValue];
            if (ioflag == 1) {
                cell1.inOrOut.text = @"入账";
            }else{
                cell1.inOrOut.text = @"出账";
            }
            return cell1;
        }
    } else if (tableView.tag == 300){
        //余额
        if (_dataArray3.count != 0) {
            YuEModel *model = [_dataArray3 objectAtIndex:indexPath.row];
            
            cell2.yinHangName.text = model.bankname;
            cell2.yinHangKaHao.text = [NSString stringWithFormat:@"%@",model.cardno];
            cell2.yinHangYuE.text = [NSString stringWithFormat:@"%@",model.balance];
            return cell2;
        }
    } else if (tableView.tag == 400){
        BankMessageModel *model = _bankData[indexPath.row];
        cell3.textLabel.text = model.name;
        return cell3;
    }
    return cell;
}
//点击事件 点击进入caiwu详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        
        XianJinDetailView *xianjin = [[XianJinDetailView alloc] init];
        XianJinZhangModel *model = [_dataArray1 objectAtIndex:indexPath.row];
        xianjin.model = model;
        [self.navigationController pushViewController:xianjin animated:YES];
        
    } else if (tableView.tag == 200) {
        
        YinHangZhangDetailView *yinhang = [[YinHangZhangDetailView alloc] init];
        YinHangZhangModel *model = [_dataArray2 objectAtIndex:indexPath.row];
        yinhang.model = model;
        [self.navigationController pushViewController:yinhang animated:YES];
        
    } else if (tableView.tag == 300) {
        
        YuEDetailViewViewController *yue = [[YuEDetailViewViewController alloc] init];
        YuEModel *model = [_dataArray3 objectAtIndex:indexPath.row];
        yue.model = model;
        [self.navigationController pushViewController:yue animated:YES];
        
    } else if(tableView.tag == 400){
        
        BankMessageModel *model = _bankData[indexPath.row];
        [_bankButton setTitle:model.name forState:UIControlStateNormal];
        _bankID = model.Id;
        _bankButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.xianJinTableView || tableView == self.yinHangTableView || tableView == self.yuETableView) {
        return 90;
    } else {
        return  45;
    }
}

@end
