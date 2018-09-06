//
//  ZhangKuanSearchVC.m
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ZhangKuanSearchVC.h"
#import "MainViewController.h"

#import "KeHuHKCell.h"
#import "YingShouKuanCell.h"
#import "FuKuanDetailView.h"
#import "DataPost.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "KHfukuanModel.h"
#import "YingShouKuanModel.h"
#import "KHnameModel.h"
#import "UIViewExt.h"
#import "CustModel.h"
#import "CustCell.h"
@interface ZhangKuanSearchVC ()
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@property(nonatomic,retain)UITableView *custSalerTableView;
@end

@implementation ZhangKuanSearchVC
{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    UIRefreshControl *_refreshControl4;
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    
    UITextField *_searchContent;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;
    NSMutableArray *_salerArray;
    NSMutableArray *_custSalerArray;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page;
    NSInteger _page4;
    NSInteger _page6;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSInteger _searchPage1;
    NSMutableArray* _searchDateArray1;
    
    
    UIButton *_keHuYSKbutton;
    UIButton *_yeWuYuanHuYSKbutton;
    
    UIButton *_currentBtn;
    NSMutableArray *_btnArray;
    NSMutableArray *_dataArray;
    UIButton *_custButton;
    UIButton *_salerButton;
    
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
    
    UILabel *_label11;
    UILabel *_label21;
    UILabel *_label31;
    UILabel *_label41;
    
    
    UITextField *_custField;
    NSString *_custId;
    UITextField *_salerField;
    NSString *_salerId;
    UIButton *_custSalerButton;
    NSString *_custSalerId;
    UITextField *_custSalerField;
    
    UIButton *_startButton;
    UIButton *_endButton;
    UIView *_timeView;
    
    
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
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
    //    _dataArray = [[NSMutableArray alloc]init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _dataArray3 = [[NSMutableArray alloc] init];
    _dataArray = [NSMutableArray array];
    _btnArray = [[NSMutableArray alloc] init];
    _custSalerArray = [[NSMutableArray alloc]init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchDateArray1 = [[NSMutableArray alloc]init];
    _searchPage1 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page = 1;
    _page4 = 1;
    _page6 = 1;
    _custpage = 1;
    _salerpage = 1;
    self.navigationItem.rightBarButtonItem  = nil;
    [self getDateStr];
    [self searchView];
}
//下拉刷新
- (void)refreshData4
{
    //开始刷新
    _refreshControl4.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl4 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown4) userInfo:nil repeats:NO];
}

- (void)refreshDown4
{
    [_dataArray removeAllObjects];
    _page = 1;
    [self nameRequest];
    [_refreshControl4 endRefreshing];
}
//上拉加载更多
- (void)upRefresh4
{
    _page++;
    [self nameRequest];
}
- (void)nameRequest
{
    //客户名称 的浏览接口
    NSLog(@"页数%zi",_page);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户数据%@",dic);
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.custTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户名称加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
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
#pragma mark -搜索页面方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
}
#pragma mark- 搜索页面
- (void)searchView{

    
    if ([self.flag isEqualToString:@"0"]) {
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
        Label1.text = @"客户名称";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        
        _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth*2/3, 40);
        [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
        [_custButton setTintColor:UIColorFromRGB(0x999999)];
        [_custButton setTitle:@"请选择客户" forState:UIControlStateNormal];
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*MYWIDTH, KscreenWidth, 1)];
        nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
        [self.view addSubview:Label1];
        [self.view addSubview:_custButton];
        [self.view addSubview:_salerButton];
        [self.view addSubview:nameView];
        //
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
        Label4.text = @"业务员";
        Label4.backgroundColor = COLOR(231, 231, 231, 1);
        Label4.font = [UIFont systemFontOfSize:15.0];
        Label4.textAlignment = NSTextAlignmentCenter;
        
        _custSalerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custSalerButton.frame = CGRectMake(KscreenWidth/3, Label1.bottom + 1, KscreenWidth/3*2, 40);
        [_custSalerButton addTarget:self action:@selector(custSalerAction) forControlEvents:UIControlEventTouchUpInside];
        [_custSalerButton setTintColor:UIColorFromRGB(0x999999)];
        [_custSalerButton setTitle:@"请选择业务员" forState:UIControlStateNormal];
        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , KscreenWidth, 1)];
        view4.backgroundColor = UIColorFromRGB(0xdcdcdc);
        [self.view addSubview:Label4];
        [self.view addSubview:_custSalerButton];
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
        
    }else if ([self.flag isEqualToString:@"1"]){
        //
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
        Label4.text = @"业务员";
        Label4.backgroundColor = COLOR(231, 231, 231, 1);
        Label4.font = [UIFont systemFontOfSize:15.0];
        Label4.textAlignment = NSTextAlignmentCenter;
        
        _custSalerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custSalerButton.frame = CGRectMake(KscreenWidth/3, 1, KscreenWidth/3*2, 40);
        [_custSalerButton addTarget:self action:@selector(custSalerAction) forControlEvents:UIControlEventTouchUpInside];
        [_custSalerButton setTintColor:UIColorFromRGB(0x999999)];
        [_custSalerButton setTitle:@"请选择业务员" forState:UIControlStateNormal];
        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , KscreenWidth, 1)];
        view4.backgroundColor = UIColorFromRGB(0xdcdcdc);
        [self.view addSubview:Label4];
        [self.view addSubview:_custSalerButton];
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

    
}
-(void)custSalerAction{
    
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //
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
    //    _custSalerField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _custSalerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custSalerField.backgroundColor = [UIColor whiteColor];
    _custSalerField.delegate = self;
    _custSalerField.tag =  102;
    _custSalerField.placeholder = @"名称关键字";
    //    _custSalerField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custSalerField.height-1,_custSalerField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_custSalerField addSubview:line2];
    _custSalerField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_custSalerField];
    [bgView addSubview:_custSalerField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custSalerField.right, _custSalerField.top, 60, _custSalerField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchsaler) forControlEvents:UIControlEventTouchUpInside];//getCustSaler
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.custSalerTableView == nil) {
        //        self.custSalerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-154) style:UITableViewStylePlain];
        self.custSalerTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, _custSalerField.bottom+5,bgView.width-40, bgView.height - _custSalerField.bottom - 5) style:UITableViewStylePlain];
        self.custSalerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custSalerTableView.dataSource = self;
    self.custSalerTableView.delegate = self;
    self.custSalerTableView.rowHeight = 45;
    [bgView addSubview:self.custSalerTableView];
    //    [self.m_keHuPopView addSubview:self.custSalerTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //    [self custSalerRequest];
    //     下拉刷新
    self.custSalerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _salerpage = 1;
        [self searchsaler];
        // 结束刷新
        [self.custSalerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.custSalerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.custSalerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _salerpage ++ ;
        [self searchsaler];
        [self.custSalerTableView.mj_footer endRefreshing];
        
    }];
    //    [self salerRequest];
    _salerpage = 1;
    [self searchsaler];
    
}
- (void)searchsaler{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *saler = _custSalerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_salerpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    if (_salerpage == 1) {
        [_custSalerArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                NSLog(@"业务员点击后返回:%@",array);
                for (NSDictionary *dic in array) {
                    CustModel *model = [[CustModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_custSalerArray addObject:model];
                }
                [self.custSalerTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
    
    
}
- (void)custAction
{
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
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.placeholder = @"名称关键字";
    //    _proField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_custField addSubview:line2];
    _custField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_proField];
    [bgView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, _custField.top, 60, _custField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchcust) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.custTableView == nil) {
        //        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 10;
    self.custTableView.rowHeight = 45;
    _refreshControl4 = [[UIRefreshControl alloc] init];
    [_refreshControl4 addTarget:self action:@selector(refreshData4) forControlEvents:UIControlEventValueChanged];
    [self.custTableView addSubview:_refreshControl4];
    [bgView addSubview:self.custTableView];
    //    [self.m_keHuPopView addSubview:self.custTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //    [self nameRequest];
    
    //     下拉刷新
    self.custTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _custpage = 1;
        [self searchcust];
        // 结束刷新
        [self.custTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.custTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.custTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _custpage ++ ;
        [self searchcust];
        [self.custTableView.mj_footer endRefreshing];
        
    }];
    _custpage = 1;
    [self searchcust];
}
- (void)searchcust{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"table":@"khxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_custpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    if (_custpage == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                NSLog(@"客户名称数据:%@",array);
                for (NSDictionary *dic in array) {
                    KHnameModel *model = [[KHnameModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.custTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
        NSLog(@"业务员加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
}
#pragma mark -  saler
- (void)salerAction{
    
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _salerField.backgroundColor = [UIColor whiteColor];
    _salerField.delegate = self;
    _salerField.tag =  102;
    _salerField.placeholder = @"名称关键字";
    _salerField.borderStyle = UITextBorderStyleRoundedRect;
    _salerField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_salerField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_salerField.right, 40, 60, 40);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(getSalerName) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-154) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.rowHeight = 45;
    [self.m_keHuPopView addSubview:self.salerTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self salerRequest];
}
- (void)salerRequest{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员数据%@",array);
        _salerArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_salerArray addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
    
}
-(void)search{
    NSString *_saler = _salerButton.titleLabel.text;
    if ([_saler isEqualToString:@"请选择销售员"]) {
        _saler = @"";
    }
    NSString *_area = _custButton.titleLabel.text;
    if ([_area isEqualToString:@"请选择客户"]) {
        _area = @"";
    }
    if (_block) {
        self.block(_custId, _custSalerId, _startButton.titleLabel.text, _endButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)chongZhi
{
    [_custButton setTitle:@" " forState:UIControlStateNormal];
    [_custSalerButton setTitle:@" " forState:UIControlStateNormal];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
}
- (void)closePop
{
    if ([self keyboardDid]) {
        [_searchContent resignFirstResponder];
        [_custField resignFirstResponder];
        [_salerField resignFirstResponder];
        [_custSalerField resignFirstResponder];
    }else{
        _custButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        [self.custTableView removeFromSuperview];
    }
    
}
#pragma mark - time
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
    [_startButton setTitle:_currentDateStr forState:UIControlStateNormal];
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
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
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

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.custTableView){
        return _dataArray.count;
    }else if (tableView == self.salerTableView){
        return _salerArray.count;
    }else{
        return _custSalerArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"QLKeHuYSCell";
    CustCell *cell2  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustCell" owner:self options:nil]firstObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    
    UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell3 == nil) {
        cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell3.backgroundColor = [UIColor whiteColor];
        
    }
    if(tableView == self.custTableView){
        
        cell2.model = _dataArray[indexPath.row];
        return cell2;
    }else if (tableView == self.salerTableView){
        CustModel *model = _salerArray[indexPath.row];
        cell3.textLabel.text = model.name;
        return cell3;
    }else{
        if (_custSalerArray.count!=0) {
            CustModel *model = _custSalerArray[indexPath.row];
            cell3.textLabel.text = model.name;
        }
        return cell3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.custTableView){
        CustModel *model = _dataArray[indexPath.row];
        [_custButton setTitle:model.name forState:UIControlStateNormal];
        _custId = model.Id;
        _custButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    } else if (tableView == self.salerTableView){
        [self.m_keHuPopView removeFromSuperview];
        CustModel *model = _salerArray[indexPath.row];
        [_custButton setTitle:model.name forState:UIControlStateNormal];
        _custButton.userInteractionEnabled = YES;
        _salerId = model.Id;
    }else if (tableView == self.custSalerTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_custSalerArray.count!=0) {
            CustModel *model = _custSalerArray[indexPath.row];
            [_custSalerButton setTitle:model.name forState:UIControlStateNormal];
            _custSalerId = model.Id;
            _custSalerButton.userInteractionEnabled = YES;
        }
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView==self.proTableView) {
//        return 75;
//    }
//    return  45;
//
//}
@end
