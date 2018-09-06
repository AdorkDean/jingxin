//
//  ZiDingYiSPViewController.m
//  YiRuanTong
//
//  Created by lx on 15/5/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZiDingYiSPViewController.h"
#import "MainViewController.h"
#import "ZiDingYiLLdetailVC.h"
#import "SPLLCell.h"
#import "SPCell.h"
#import "UIViewExt.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "YeWuYuanModel.h"
#import "ShangBaoVC.h"
#import "ZiDingYiSPModel.h"
#import "ZiDingYiSPdetailVC.h"
#import "ZDYSPShangBaoVC.h"
#import "DataPost.h"

@interface ZiDingYiSPViewController ()

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    UIView *_timeView;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    
    NSMutableArray *_dataArray; //上报人数组
    NSMutableArray *_typeArray;
    NSMutableArray *_typeIdArray;
    NSArray *_spArray;
    
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    
    UIButton *_startButton;
    UIButton *_endButton;
    UIButton *_currentBtn;
    UIButton *_liuLanButton;
    UIButton *_shenPiButton;
    UIButton *_salerButton;
    UIButton *_typeButton;
    UIButton *_spButton;
    NSString *_typeId;
    NSString *_spId;

    NSMutableArray *_btnArray;
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
}

@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *typeTableView;
@property(nonatomic,retain)UITableView *spTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation ZiDingYiSPViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    _page1 = 1;
    _page2 = 1;
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(request) object:nil];
    [thread start];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _btnArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _typeIdArray = [[NSMutableArray alloc] init];
    _typeArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _page1 = 1;
    _page2 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    
    self.title = @"审批";
    [self PageViewDidLoad];
    [self PageViewDidLoad1];
     [self getDateStr];
    //搜索视图
    [self searchView];
    
    
    //当前时间戳
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    _currentDateStr = [dateFormatter stringFromDate:currentDate];
   

    _typeId = @" ";
    _spId = @" ";
//    _startButton.titleLabel.text = @" ";
    
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
- (void)request
{
    [self DataRequest];
    [self DataRequest1];
}

- (void)searchView
{
    _barHideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _barHideBtn.frame = CGRectMake(0, 0, KscreenWidth, 64+50);
    _barHideBtn.backgroundColor = [UIColor clearColor];
    _barHideBtn.hidden = YES;
    [_barHideBtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_barHideBtn];
    //右侧模糊视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/2, 50, KscreenWidth/2, KscreenHeight -64 - 50)];
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = 0.6;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTouchesRequired = 1;
    [ _backView addGestureRecognizer:singleTap];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    
    //信息视图
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth/2, KscreenHeight - 64 -50)];
    _searchView.backgroundColor = [UIColor whiteColor];
    
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
    Label1.text = @"上报人";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    [_salerButton setTintColor:[UIColor blackColor]];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_searchView addSubview:Label1];
    [_searchView addSubview:_salerButton];
    [_searchView addSubview:nameView];
    
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
    Label2.text = @"类型";
    Label2.backgroundColor = COLOR(231, 231, 231, 1);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _typeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _typeButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
    [_typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(typeAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
    salerView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_searchView addSubview:Label2];
    [_searchView addSubview:_typeButton];
    [_searchView addSubview:salerView];
    
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
    Label3.text = @"审批状态";
    Label3.backgroundColor = COLOR(231, 231, 231, 1);
    Label3.font = [UIFont systemFontOfSize:15.0];
    Label3.textAlignment = NSTextAlignmentCenter;
    _spButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _spButton.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
    [_spButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_spButton addTarget:self action:@selector(spStatus) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_searchView addSubview:Label3];
    [_searchView addSubview:_spButton];
    [_searchView addSubview:typeView];
    
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
    Label4.text = @"上报日期";
    Label4.backgroundColor = COLOR(231, 231, 231, 1);
    Label4.font = [UIFont systemFontOfSize:15.0];
    Label4.textAlignment = NSTextAlignmentCenter;
    _startButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
    startView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_searchView addSubview:Label4];
    [_searchView addSubview:_startButton];
    [_searchView addSubview:startView];
    
    UILabel *Label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 164, _searchView.frame.size.width/3, 40)];
    Label5.text = @"至";
    Label5.backgroundColor = COLOR(231, 231, 231, 1);
    Label5.font = [UIFont systemFontOfSize:15.0];
    Label5.textAlignment = NSTextAlignmentCenter;
    _endButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(_searchView.frame.size.width/3, 164, _searchView.frame.size.width/3*2, 40);
    [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, 204, _searchView.frame.size.width, 1)];
    endView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_searchView addSubview:Label5];
    [_searchView addSubview:_endButton];
    [_searchView addSubview:endView];
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 204)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_searchView addSubview:fenGeXian];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, 230, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, 230, 60, 30);
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    [_searchView addSubview:searchBtn];
    [_searchView addSubview:chongZhi];
    [self.view  addSubview:_searchView];
    _searchView.hidden = YES;
}

#pragma mark - 搜索页面方法
- (void)singleTapAction
{
    _backView.hidden = YES;
    _searchView.hidden = YES;
    _barHideBtn.hidden = YES;
}

- (void)salerAction
{
    //上报人
    _salerButton.userInteractionEnabled = NO;
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getPrincipals&table=yhzh";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"业务员点击后返回:%@",array);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic  in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
    }
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor lightGrayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    [bgView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.salerTableView reloadData];
}

- (void)closePop
{
    _salerButton.userInteractionEnabled = YES;
    _typeButton.userInteractionEnabled = YES;
    [self.m_keHuPopView removeFromSuperview];
}

- (void)typeAction
{
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = @"table=shenpibt";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        NSLog(@"审批类型数组:%@",array);
//        for (NSDictionary *dic in array) {
//            NSString *str = [dic objectForKey:@"name"];
//            NSString *str1 = [dic objectForKey:@"id"];
//            [_typeArray addObject:str];
//            [_typeIdArray addObject:str1];
//        }
//
//    }
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
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.typeTableView == nil) {
        self.typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174)style:UITableViewStylePlain];
        self.typeTableView.backgroundColor = [UIColor whiteColor];
    }
    self.typeTableView.dataSource = self;
    self.typeTableView.delegate = self;
    [bgView addSubview:self.typeTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //审批类型接口
    _typeButton.userInteractionEnabled = NO;
    NSString *strAdress = @"/spdefine?action=getSpDefineComBox";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSDictionary* parmas = @{@"table":@"shenpibt"};
    [_typeIdArray removeAllObjects];
    [_typeArray removeAllObjects];
    [DataPost requestAFWithUrl:urlStr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"审批类型数组:%@",array);
        for (NSDictionary *dic in array) {
            NSString *str = [dic objectForKey:@"name"];
            NSString *str1 = [dic objectForKey:@"id"];
            [_typeArray addObject:str];
            [_typeIdArray addObject:str1];
        }
        [self.typeTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}

- (void)spStatus
{
    _spArray = @[@"全部",@"未审批",@"审批中",@"审批通过",@"审批拒绝"];
    self.m_keHuPopView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor =[UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.spTableView == nil) {
        self.spTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174)style:UITableViewStylePlain];
        self.spTableView.backgroundColor = [UIColor whiteColor];
    }
    self.spTableView.dataSource = self;
    self.spTableView.delegate = self;
    [bgView addSubview:self.spTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
}

- (void)startAction
{
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

- (void)endAction
{
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

- (void)souSuoButtonClickMethod
{
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
        _barHideBtn.hidden = NO;
    } else if (![_searchView isHidden]){
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
    }
}
#pragma mark - 搜索方法

- (void)search
{
    [self searchData];
}

- (void)searchData
{
    /*
     action:"getBeansSelf"
     sort:"createtime"
     order:"desc"
     allflag:"1"
     page:"1"
     rows:"20"
     params:"{"reporttypeidEQ":"78","isreplyEQ":"1","createtimeGE":"2015-04-11","createtimeLE":"2015-05-13"}"
     */
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([_salerButton.titleLabel.text isEqualToString:@" "]&&[_typeId isEqualToString:@" "]&&[_spId isEqualToString:@" "]&&[_startButton.titleLabel.text isEqualToString:@" "]&&[_endButton.titleLabel.text isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString * stringCreator = [self convertNull:_salerButton.titleLabel.text];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine?action=getSelfDefine"];
    NSDictionary* parmas = @{@"table":@"shenpizdy",@"rows":@"20",@"page":[NSString stringWithFormat:@"%ld",(long)_searchPage],@"params":[NSString stringWithFormat:@"{\"creatorLIKE\":\"%@\",\"sptypeidEQ\":\"%@\",\"spstatusEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",stringCreator,_typeId,_spId,_startButton.titleLabel.text,_endButton.titleLabel.text]};
    [DataPost requestAFWithUrl:urlStr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"搜索返回%@",array);
        for (NSDictionary *dic in array) {
            
            ZiDingYiSPModel *model = [[ZiDingYiSPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_searchDateArray addObject:model];
        }
        [_HUD hide:YES];
        [self.liuLanTableView reloadData];
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
    }];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = [NSString stringWithFormat:@"table=shenpizdy&rows=20&page=%zi&params=",_searchPage,];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//           }
}

- (void)chongZhi
{
    [_salerButton setTitle:@"" forState:UIControlStateNormal];
    [_typeButton setTitle:@"" forState:UIControlStateNormal];
    [_startButton setTitle:@"" forState:UIControlStateNormal];
    [_spButton setTitle:@"" forState:UIControlStateNormal];
    [_endButton setTitle:@"" forState:UIControlStateNormal];
    _typeId = @"";
    _spId = @"";
}

#pragma mark - 日志浏览审批数据
- (void)DataRequest
{
    if (_page1 == 1) {
        [_dataArray1 removeAllObjects];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *logincode = [userDefaults objectForKey:@"logincode"];
    //自定义审批列表的浏览接口
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine?action=getSelfDefine"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = [NSString stringWithFormat:@"rows=20&page=%zi&params=\"\"&logincode=%@",_page1,logincode];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSLog(@"上传字符串:%@",str);
//    [request setHTTPBody:data];
//    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
//        NSArray *array = dic[@"rows"];
//        for (NSDictionary *dic in array) {
//            ZiDingYiSPModel *model = [[ZiDingYiSPModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray1 addObject:model];
//        }
//        [_HUD hide:YES];
//        NSLog(@"自定义审批列表的返回数据:%@",array);
//        [self.liuLanTableView reloadData];
//
//    }else{
//        [self showAlert:@"加载失败"];
//    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine?action=getSelfDefine"];
    NSDictionary* parmas = @{@"table":@"shenpizdy",@"rows":@"20",@"logincode":logincode,@"page":[NSString stringWithFormat:@"%ld",(long)_page1],@"params":[NSString stringWithFormat:@"{\"creatorLIKE\":\"%@\",\"sptypeidEQ\":\"%@\",\"spstatusEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",@"",@"",@"",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"搜索返回%@",array);
        for (NSDictionary *dic in array) {
            ZiDingYiSPModel *model = [[ZiDingYiSPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
        }
        [_HUD hide:YES];
        [self.liuLanTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
        [self showAlert:@"加载失败"];
    }];
    
    
    
}

- (void)DataRequest1
{
    /*批复列表
     http://182.92.96.58:8005/yrt/servlet/dailyreport
     rows	10
     mobile	true
     page	1
     action	getBeansDepart
     params	{"isreplyEQ":0}
     table	rzsb
     */
    //自定义审批列表审批的接口
    if (_page2 == 1) {
        [_dataArray2 removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine?action=getSpSelfDefine"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=shenpizdy&rows=20&page=%zi&params={\"sptypeidEQ\":\"\",\"isspEQ\":\"0\",\"createtimeGE\":\"\",\"createtimeLE\":\"\"}",_page2];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            ZiDingYiSPModel *model = [[ZiDingYiSPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray2 addObject:model];
        }
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        NSLog(@"自定义批复列表的返回:%@",array);
        [self.shenPiTableView reloadData];
    }else{
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        [self showAlert:@"加载失败"];

    }
    
}

- (void)PageViewDidLoad
{
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setImage:[UIImage imageNamed:@"menu_add"] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(AddAction:) forControlEvents:UIControlEventTouchUpInside];
    [AddButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *searchBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(KscreenWidth - 70, 10, 20, 40);
//    [searchBtn setImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, 5);
    [searchBtn addTarget:self action:@selector(souSuoButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    //将按钮数组放在navbar 上
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:right,right1, nil]];
    
}

- (void)AddAction:(UIButton *)button{
    ZDYSPShangBaoVC *shangbaoVC = [[ZDYSPShangBaoVC alloc] init];
    [self.navigationController pushViewController:shangbaoVC animated:YES];
}

- (void)PageViewDidLoad1
{
    //标题下方的2个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 49)];
    buttonView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, KscreenWidth, 1)];
    line.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:buttonView];
    [self.view addSubview:line];
   
    //2个按钮的设置
    _liuLanButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (KscreenWidth)/2, 49)];
    [_liuLanButton setTitle:@"浏览" forState:UIControlStateNormal];
    _liuLanButton.tag = 0;
    _liuLanButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_liuLanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_liuLanButton setTitleColor:UIColorFromRGB(0x3cbaff) forState:UIControlStateSelected];
    _liuLanButton.backgroundColor = [UIColor whiteColor];
    [_liuLanButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _currentBtn = _liuLanButton;
    _currentBtn.selected = YES;
    [buttonView addSubview:_liuLanButton];
    [_btnArray addObject:_liuLanButton];
//    UILabel *cline = [[UILabel alloc] initWithFrame:CGRectMake(_liuLanButton.right+1, 0, 1, KscreenWidth/2)];
//    cline.backgroundColor = [UIColor lightGrayColor];
//    [buttonView addSubview:cline];
    _shenPiButton = [[UIButton alloc] initWithFrame:CGRectMake((KscreenWidth)/2,0 , (KscreenWidth)/2,49)];
    [_shenPiButton setTitle:@"审批" forState:UIControlStateNormal];
    _shenPiButton.tag = 1;
    [_shenPiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shenPiButton setTitleColor:UIColorFromRGB(0x3cbaff) forState:UIControlStateSelected];
    [_shenPiButton setBackgroundColor:[UIColor whiteColor]];
    [_shenPiButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _shenPiButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [buttonView addSubview:_shenPiButton];
    [_btnArray addObject:_shenPiButton];
    
    //标题下方View的设置;
    //UIScrollerView
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114)];
    self.mainScrollView.contentSize = CGSizeMake(KscreenWidth*2, KscreenHeight-114);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    //scrollView上面的2个tableview实例化 并且添加到scrollView上去
    self.liuLanTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.liuLanTableView.delegate = self;
    self.liuLanTableView.dataSource = self;
    self.liuLanTableView.tag = 10;
    self.liuLanTableView.tableFooterView = [[UIView alloc]init];
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.liuLanTableView addSubview:_refreshControl];
    [self.mainScrollView addSubview:self.liuLanTableView];
    //     下拉刷新
    self.liuLanTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.liuLanTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.liuLanTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.liuLanTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [self.liuLanTableView.mj_footer endRefreshing];
    }];
    
    self.shenPiTableView = [[UITableView alloc] initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.shenPiTableView.delegate = self;
    self.shenPiTableView.dataSource = self;
    self.shenPiTableView.tag = 20;
    self.shenPiTableView.tableFooterView = [[UIView alloc]init];
//    _refreshControl2 = [[UIRefreshControl alloc] init];
//    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
//    [self.shenPiTableView addSubview:_refreshControl2];
    [self.mainScrollView addSubview:self.shenPiTableView];
    //     下拉刷新
    self.shenPiTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown2];
        // 结束刷新
        [self.shenPiTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.shenPiTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.shenPiTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh2];
        [self.shenPiTableView.mj_footer endRefreshing];
    }];
}

- (void)selectBtn:(UIButton *)btn
{
    if (btn != _currentBtn)
    {
        _currentBtn.selected = NO;
        _currentBtn.backgroundColor = [UIColor whiteColor];
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
                    _currentBtn.backgroundColor = [UIColor whiteColor];
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
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        [self searchData];
        [_refreshControl endRefreshing];
    }else{
        [_dataArray1 removeAllObjects];
        _page1 = 1;
        [self DataRequest];
        [_refreshControl endRefreshing];
    }
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

- (void)upRefresh1
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
        [self searchData];
    }else{
        [_HUD show:YES];
        _page1++;
        [self DataRequest];
    }
}

- (void)upRefresh2
{
    [_HUD show:YES];
    _page2++;
    [self DataRequest1];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh1];
        }
    } else if (scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh2];
        }
    }
}

#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.liuLanTableView) {
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray1.count;
        }
    } else if(tableView == self.shenPiTableView) {
        return _dataArray2.count;
    } else if(tableView == self.salerTableView) {
        return _dataArray.count;
    } else if(tableView == self.typeTableView) {
        return _typeArray.count;
    } else {
        return _spArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    SPLLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell =(SPLLCell *) [[[NSBundle mainBundle] loadNibNamed:@"SPLLCell" owner:self options:nil]firstObject];
    }
    SPCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(SPCell*)[[[NSBundle mainBundle] loadNibNamed:@"SPCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView == self.liuLanTableView)
    {
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                cell.model = _searchDateArray[indexPath.row];
            }
        }else{
            if (_dataArray1.count != 0) {
                cell.model = _dataArray1[indexPath.row];
            }
        }
        return cell;
    } else if(tableView == self.shenPiTableView) {
        
        if (_dataArray2.count != 0) {
            cell1.model = _dataArray2[indexPath.row];
            return cell1;
        }
    } else if (tableView == self.salerTableView){
        
        YeWuYuanModel *model = _dataArray[indexPath.row];
        cell2.textLabel.text = model.name;
        return cell2;
        
    } else if (tableView == self.typeTableView){
        
        NSString *type = _typeArray[indexPath.row];
        cell2.textLabel.text = type;
        return cell2;
        
    } else if (tableView == self.spTableView){
        
        NSString *sp = _spArray[indexPath.row];
        cell2.textLabel.text = sp;
        return cell2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView){
        
        ZiDingYiLLdetailVC *liulan = [[ZiDingYiLLdetailVC alloc] init];
        if (_searchFlag == 1) {
            ZiDingYiSPModel *model = [_searchDateArray objectAtIndex:indexPath.row];
            liulan.Id = model.Id;
            liulan.model = model;
        }else{
            ZiDingYiSPModel *model = [_dataArray1 objectAtIndex:indexPath.row];
            liulan.Id = model.Id;
            liulan.model = model;
        }
        [self.navigationController pushViewController:liulan animated:YES];
        
    } else if (tableView == self.shenPiTableView){
        
        ZiDingYiSPdetailVC *shenPi = [[ZiDingYiSPdetailVC alloc] init];
        ZiDingYiSPModel *model = [_dataArray2 objectAtIndex:indexPath.row];
        shenPi.model = model;
        shenPi.Id = model.Id;
        [self.navigationController pushViewController:shenPi animated:YES];
        
    } else if (tableView == self.salerTableView){
        
        YeWuYuanModel *model = _dataArray[indexPath.row];
        [_salerButton setTitle:model.name forState:UIControlStateNormal];
        _salerButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        
    } else if (tableView == self.typeTableView){
        
        NSString *type = _typeArray[indexPath.row];
        NSString *ID  = _typeIdArray[indexPath.row];
        [_typeButton setTitle:type forState:UIControlStateNormal];
        _typeId = ID;
        _typeButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        
    } else if (tableView == self.spTableView){
        
        NSString *sp = _spArray[indexPath.row];
        [_spButton setTitle:sp forState:UIControlStateNormal];
        if ([sp isEqualToString:@"审批中"]) {
            _spId = @"10";
        } else if ([sp isEqualToString:@"未审批"]){
            _spId = @"0";
        }else if ([sp isEqualToString:@"审批通过"]){
            _spId = @"1";
        }else if ([sp isEqualToString:@"审批拒绝"]){
            _spId = @"-1";
        }else {
            _spId = @"";
        }
        _spButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView || tableView == self.shenPiTableView) {
        return 65;
    } else {
        return 45;
    }
}
- (NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}
@end
