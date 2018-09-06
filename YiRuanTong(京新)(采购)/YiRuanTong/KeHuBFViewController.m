//
//  KeHuBFViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KeHuBFViewController.h"
#import "MainViewController.h"
#import "BaiFangShangBaoVC.h"
#import "LiuLanCell.h"
#import "ShenPiCell.h"
#import "ShenPiBaiFangVC.h"
#import "LiuLanBaiFangVC.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "KHbaifangModel.h"
#import "UIViewExt.h"
#import "KHnameModel.h"
#import "DataPost.h"
#import "CommonModel.h"
#import "ZhouBianViewController.h"
@interface KeHuBFViewController ()<UITextFieldDelegate>
{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    UIRefreshControl *_refreshControl4;
    
    UIButton *_liuLanButton;
    UIButton *_shenPiButton;
    UIButton *_currentBtn;
 
    
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    UIView *_timeView;
    UIButton *_nameButton;
    
    UIButton *_salerButton;
    UIButton *_typeButton;
    UIButton *_classButton;
    UIButton *_tracelevelButton;
    UIButton *_startButton;
    UIButton *_endButton;
    
    NSString *_custId;
    NSString *_accountId;
    NSString *_classId;
    NSString *_tracelevelId;
    
    
    
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page;
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSInteger _searchPage1;
    NSMutableArray* _searchDateArray1;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _custpage;
    NSInteger _salerpage;
    
    
    
    UITextField *_custField;
    UITextField *_salerField;
    NSMutableArray *_salerArray;
    NSMutableArray *_areaArray;
    NSMutableArray *_statusArray;
    NSMutableArray *_nameArray;
    
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,assign)NSInteger *ISCLICKWHERE;
@property(nonatomic,retain)UITableView *nameTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *typeTableView;
@property(nonatomic,retain)UITableView *classTableView;
@property(nonatomic,retain)UITableView *tracelevelTableView;
@property(nonatomic,retain) UIDatePicker * datePicker;


@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,retain)NSMutableArray *keHuFenLeiArr;
@property(nonatomic,retain)NSMutableArray *keHuFenLeiIdArr;
@property(nonatomic,retain)NSMutableArray *keHuXingZhiArr;
@property(nonatomic,retain)NSMutableArray *keHuXingZhiIDArr;

@property(nonatomic,retain)NSMutableArray *btnArray;

@end

@implementation KeHuBFViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户拜访";
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc]init];
    _nameArray = [NSMutableArray array];
    _btnArray = [[NSMutableArray alloc]init];
    _salerArray = [[NSMutableArray alloc]init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchDateArray1 = [[NSMutableArray alloc]init];
    _page1 = 1;
    _page2 = 1;
    _page = 1;
    _searchPage = 1;
    _searchPage1 = 1;
    _searchFlag = 0;
    _custpage = 1;
    _salerpage = 1;
//    [self showBarWithName:@"拜访" addBarWithName:nil];
    [self showBarWithName:@"拜访" addBarWithName:@"周边"];
    [self getDateStr];
    [self PageViewDidLoad1];
    [self searchView];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    [self DataRequest];
    [self DataRequest1];
    
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRefresh) name:@"newVisit" object:nil];

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
#pragma mark -搜索页面设置
-(void)searchView{
    _barHideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _barHideBtn.frame = CGRectMake(0, 0, KscreenWidth, 64+50);
    _barHideBtn.backgroundColor = [UIColor clearColor];
    _barHideBtn.hidden = YES;
    [_barHideBtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_barHideBtn];
    //右侧模糊视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 50, KscreenWidth/3, KscreenHeight -64 - 50)];
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = .6;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTouchesRequired = 1;
    [ _backView addGestureRecognizer:singleTap];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    //信息视图
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth/3*2, KscreenHeight - 64 -50)];
    _searchView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
    nameLabel.text = @"客户名称";
    nameLabel.backgroundColor = COLOR(231, 231, 231, 1);
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame =  CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
    _nameButton.backgroundColor = [UIColor whiteColor];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
    nameView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:nameLabel];
    [_searchView addSubview:_nameButton];
    [_searchView addSubview:nameView];
    //
    UILabel *salerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
    salerLabel.text = @"负责人";
    salerLabel.backgroundColor = COLOR(231, 231, 231, 1);
    salerLabel.font = [UIFont systemFontOfSize:15.0];
    salerLabel.textAlignment = NSTextAlignmentCenter;
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
    [_salerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
    salerView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:salerLabel];
    [_searchView addSubview:_salerButton];
    [_searchView addSubview:salerView];
    //
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
    typeLabel.text = @"客户分类";
    typeLabel.backgroundColor = COLOR(231, 231, 231, 1);
    typeLabel.font = [UIFont systemFontOfSize:15.0];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _typeButton.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
    [_typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(typeAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
    typeView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:typeLabel];
    [_searchView addSubview:_typeButton];
    [_searchView addSubview:typeView];
    //
//    UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
//    classLabel.text = @"客户类型";
//    classLabel.backgroundColor = COLOR(231, 231, 231, 1);
//    classLabel.font = [UIFont systemFontOfSize:15.0];
//    classLabel.textAlignment = NSTextAlignmentCenter;
//    _classButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
//    _classButton.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
//    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_classButton addTarget:self action:@selector(classAction) forControlEvents:UIControlEventTouchUpInside];
//    UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
//    classView.backgroundColor = [UIColor grayColor];
//    [_searchView addSubview:classLabel];
//    [_searchView addSubview:_classButton];
//    [_searchView addSubview:classView];
    //
    UILabel *tracelevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, typeLabel.bottom + 1, _searchView.frame.size.width/3, 40)];
    tracelevelLabel.text = @"客户状态";
    tracelevelLabel.backgroundColor = COLOR(231, 231, 231, 1);
    tracelevelLabel.font = [UIFont systemFontOfSize:15.0];
    tracelevelLabel.textAlignment = NSTextAlignmentCenter;
    _tracelevelButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _tracelevelButton.frame = CGRectMake(_searchView.frame.size.width/3, typeLabel.bottom + 1, _searchView.frame.size.width/3*2, 40);
    [_tracelevelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tracelevelButton addTarget:self action:@selector(tracelevelAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *tracelevelView = [[UIView alloc] initWithFrame:CGRectMake(0, tracelevelLabel.bottom, _searchView.frame.size.width, 1)];
    tracelevelView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:tracelevelLabel];
    [_searchView addSubview:_tracelevelButton];
    [_searchView addSubview:tracelevelView];
    //
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tracelevelLabel.bottom + 1, _searchView.frame.size.width/3, 40)];
    startLabel.text = @"开始时间";
    startLabel.backgroundColor = COLOR(231, 231, 231, 1);
    startLabel.font = [UIFont systemFontOfSize:15.0];
    startLabel.textAlignment = NSTextAlignmentCenter;
    _startButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(_searchView.frame.size.width/3, tracelevelLabel.bottom + 1, _searchView.frame.size.width/3*2, 40);
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, startLabel.bottom, _searchView.frame.size.width, 1)];
    startView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:startLabel];
    [_searchView addSubview:_startButton];
    [_searchView addSubview:startView];
    //
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startLabel.bottom + 1, _searchView.frame.size.width/3, 40)];
    endLabel.text = @"结束时间";
    endLabel.backgroundColor = COLOR(231, 231, 231, 1);
    endLabel.font = [UIFont systemFontOfSize:15.0];
    endLabel.textAlignment = NSTextAlignmentCenter;
    _endButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(_searchView.frame.size.width/3, startLabel.bottom + 1, _searchView.frame.size.width/3*2, 40);
    [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, endLabel.bottom, _searchView.frame.size.width, 1)];
    endView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:endLabel];
    [_searchView addSubview:_endButton];
    [_searchView addSubview:endView];
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 246)];
    fenGeXian.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:fenGeXian];
    
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, endLabel.bottom + 25, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, endLabel.bottom + 25, 60, 30);
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
   
    [_searchView addSubview:searchBtn];
    [_searchView addSubview:chongZhi];
    [self.view  addSubview:_searchView];
    _searchView.hidden = YES;
}
- (void)singleTapAction{
    _backView.hidden = YES;
    _searchView.hidden = YES;
    _barHideBtn.hidden = YES;
}
- (void)nameAction{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
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
//    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
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
    
    if (self.nameTableView == nil) {
//        self.nameTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.nameTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.nameTableView.backgroundColor = [UIColor whiteColor];
    }
    self.nameTableView.dataSource = self;
    self.nameTableView.delegate = self;
    self.nameTableView.tag = 30;
    self.nameTableView.rowHeight = 45;
    [bgView addSubview:self.nameTableView];
//    [self.m_keHuPopView addSubview:self.nameTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    [self nameRequest];
    //     下拉刷新
    self.nameTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _custpage = 1;
        [self searchcust];
        // 结束刷新
        [self.nameTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.nameTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.nameTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _custpage ++ ;
        [self searchcust];
        [self.nameTableView.mj_footer endRefreshing];
        
    }];
    _custpage = 1;
    [self searchcust];
}
//下拉刷新
- (void)refreshData3
{//开始刷新
    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl3 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown3) userInfo:nil repeats:NO];
    
}
- (void)refreshDown3
{
    [_dataArray removeAllObjects];
    _page = 1;
    [self nameRequest];
    [_refreshControl3 endRefreshing];
}

- (void)getName{
    
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
       // NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.nameTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
}


- (void)nameRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        //NSLog(@"客户数据%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                KHnameModel *model = [[KHnameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
        }
        [self.nameTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户名称加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
    
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
                if (array.count != 0) {
                    for (NSDictionary *dic in array) {
                        KHnameModel *model = [[KHnameModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        [_dataArray addObject:model];
                    }
                }
                [self.nameTableView reloadData];
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


- (void)closePop
{
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
        [_salerField resignFirstResponder];
    
    }else{
        _nameButton.userInteractionEnabled = YES;
        _salerButton.userInteractionEnabled = YES;
        _typeButton.userInteractionEnabled = YES;
        _classButton.userInteractionEnabled = YES;
        _tracelevelButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        [self.nameTableView removeFromSuperview];
        [self.salerTableView removeFromSuperview];
        [self.typeTableView removeFromSuperview];
        [self.classTableView removeFromSuperview];
        [self.tracelevelTableView removeFromSuperview];
    }
}

- (void)salerAction{
    //业务员
    _salerButton.userInteractionEnabled = NO;
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
//    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _salerField.backgroundColor = [UIColor whiteColor];
    _salerField.delegate = self;
    _salerField.tag =  102;
    _salerField.placeholder = @"名称关键字";
//    _salerField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_salerField.height-1,_salerField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_salerField addSubview:line2];
    _salerField.font = [UIFont systemFontOfSize:13];
//    [self.m_keHuPopView addSubview:_salerField];
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
//    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-154) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _salerField.bottom+5,bgView.width-40, bgView.height - _salerField.bottom - 5) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.rowHeight = 45;
    [bgView addSubview:self.salerTableView];
//    [self.m_keHuPopView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    [self salerRequest];
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
    //    [self salerRequest];
    _salerpage = 1;
    [self searchsaler];

}
- (void)getSalerName{
    
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
       // NSLog(@"业务员数据%@",array);
        _salerArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
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
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
    
}
- (void)salerRequest{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
       // NSLog(@"业务员数据%@",array);
        _salerArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
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
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
    
}

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
                NSLog(@"业务员点击后返回:%@",array);
                for (NSDictionary *dic in array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_salerArray addObject:model];
                }
                [self.salerTableView reloadData];
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


- (void)typeAction{
    
    _typeButton.userInteractionEnabled = NO;
    
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
        self.typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.typeTableView.backgroundColor = [UIColor whiteColor];
    }
    self.typeTableView.dataSource = self;
    self.typeTableView.delegate = self;
    [bgView addSubview:self.typeTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self kehufenleiRequest];
    [self.typeTableView reloadData];
}
#pragma mark - 客户分类
- (void)kehufenleiRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/syscate"];
    NSDictionary *params = @{@"action":@"getSelectForMobile",@"params":@"{\"type\":\"customerclassify\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        _keHuFenLeiArr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_keHuFenLeiArr addObject:model];
        }
        [self.typeTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

       
    }];

    
}
//
//- (void)classAction{
//    
//    _classButton.userInteractionEnabled = NO;
//    
//    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth-120, KscreenHeight-144)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    btn.frame = CGRectMake(_m_keHuPopView.frame.size.width - 40, 0, 40, 20);
//    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
//    [self.m_keHuPopView addSubview:btn];
//    if (self.classTableView == nil) {
//        self.classTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
//        self.classTableView.backgroundColor = [UIColor grayColor];
//    }
//    self.classTableView.dataSource = self;
//    self.classTableView.delegate = self;
//    [self.m_keHuPopView addSubview:self.classTableView];
//    [self.view addSubview:self.m_keHuPopView];
//    [self kehuxingzhiRequest];
//    [self.classTableView reloadData];
//
//}
//- (void)kehuxingzhiRequest
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
//    NSURL *url =[NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = @"action=getSelectType&type=customertype";
//    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSArray * dict8 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        NSLog(@"客户性质点击返回:%@",dict8);
//        self.keHuXingZhiArr = [[NSMutableArray alloc] init];
//        self.keHuXingZhiIDArr = [[NSMutableArray alloc] init];
//        for (int i = 0; i < dict8.count; i++) {
//            NSString * str = dict8[i][@"name"];
//            NSString *xingzhiID = dict8[i][@"id"];
//            [self.keHuXingZhiArr addObject:str];
//            [self.keHuXingZhiIDArr addObject:xingzhiID];
//        }
//
//    }
//}
#pragma mark - 客户状态
- (void)tracelevelAction{
    _tracelevelButton.userInteractionEnabled = NO;
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
    if (self.tracelevelTableView == nil) {
        self.tracelevelTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tracelevelTableView.backgroundColor = [UIColor whiteColor];
    }
    self.tracelevelTableView.dataSource = self;
    self.tracelevelTableView.delegate = self;
    [bgView addSubview:self.tracelevelTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self tracelevelRequest];
    [self.tracelevelTableView reloadData];
}
- (void)tracelevelRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSDictionary *params = @{@"action":@"getSelectType",@"type":@"manageclass"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        _statusArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_statusArray addObject:model];
        }

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

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

- (void)souSuoButtonClickMethod
{
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
        _barHideBtn.hidden = NO;
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
    }
}
#pragma mark - 搜索
//搜索加载数据方法
- (void)search
{
    [self searchData];
    [self getSp];
}

- (void)searchData
{
    /*
     action:"queryVisit"
     table:"khbf"
     flag:"1"
     page:"1"
     rows:"20"
     {"table":"khbf","custidEQ":"2279","classidEQ":"","tracelevelidEQ":"","accountidEQ":"","reportdateGE":"","reportdateLE":"","linkerLIKE":""}
     
     */
    
    _custId = [self convertNull:_custId];
    _accountId = [self convertNull:_accountId];
    NSString *startDate = _startButton.titleLabel.text;
    startDate = [self convertNull:startDate];
    NSString *endDate = _endButton.titleLabel.text;
    endDate = [self convertNull:endDate];
    _classId = [self convertNull:_classId];
    _tracelevelId = [self convertNull:_tracelevelId];
    
    if ([_nameButton.titleLabel.text isEqualToString:@" "]&&[_salerButton.titleLabel.text isEqualToString:@" "]&&[_typeButton.titleLabel.text isEqualToString:@" "]&&[_tracelevelButton.titleLabel.text isEqualToString:@" "]&&[_startButton.titleLabel.text isEqualToString:@" "]&&[_endButton.titleLabel.text isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    [_searchDateArray removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"action":@"queryVisit",@"table":@"khbf",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"flag":@"1",@"params":[NSString stringWithFormat:@"{\"table\":\"khbf\",\"custidEQ\":\"%@\",\"classidEQ\":\"%@\",\"tracelevelidEQ\":\"%@\",\"accountidEQ\":\"%@\",\"reportdateGE\":\"%@\",\"reportdateLE\":\"%@\",\"linkerLIKE\":\"\"}",_custId,_classId,_tracelevelId,_accountId,startDate,endDate]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        // NSLog(@"搜索上传的字符串%@",params);
        NSLog(@"搜索列表数据:%@",dic);
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            KHbaifangModel *model = [[KHbaifangModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_searchDateArray addObject:model];
        }
        [_HUD hide:YES];
        [self.liuLanTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
}


- (void)getSp{
    NSString *name = _nameButton.titleLabel.text;
    name = [self convertNull:name];
    NSString *saler = _salerButton.titleLabel.text;
    saler = [self convertNull:saler];
    NSString *startDate = _startButton.titleLabel.text;
    startDate = [self convertNull:startDate];
    NSString *endDate = _endButton.titleLabel.text;
    endDate = [self convertNull:endDate];
    NSString *class = _classButton.titleLabel.text;
    class = [self convertNull:class];
    NSString *type = _typeButton.titleLabel.text;
    type = [self convertNull:type];
    NSString *tracelevel = _tracelevelButton.titleLabel.text;
    tracelevel = [self convertNull:tracelevel];
    [_searchDateArray1 removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"action":@"queryVisit",@"table":@"khbf",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage1],@"flag":@"1",@"params":[NSString stringWithFormat:@"{\"table\":\"khbf\",\"custnameLIKE\":\"%@\",\"account\":\"%@\",\"reportdateGE\":\"%@\",\"reportdateLE\":\"%@\",\"typename\":\"%@\",\"classname\":\"%@\",\"tracelevelLIKE\":\"%@\",\"spstatusEQ\":\"0\"}",name,saler,startDate,endDate,class,type,tracelevel]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"审批搜索列表数据:%@",dic);
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            KHbaifangModel *model = [[KHbaifangModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_searchDateArray1 addObject:model];
        }
        [_HUD hide:YES];
        [self.shenPiTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
}

-(NSString*)convertNull:(id)object{
    
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

- (void)chongZhi
{   
    [_nameButton setTitle:@" "forState:UIControlStateNormal];
    [_salerButton setTitle:@" "forState:UIControlStateNormal];
    [_typeButton setTitle:@" "forState:UIControlStateNormal];
    [_classButton setTitle:@" "forState:UIControlStateNormal];
    [_tracelevelButton setTitle:@" "forState:UIControlStateNormal];
    [_startButton setTitle:@" "forState:UIControlStateNormal];
    [_endButton setTitle:@" "forState:UIControlStateNormal];
    
}
#pragma mark - 客户拜访浏览审批数据加载
-(void)DataRequest
{
    //客户拜访列表的浏览接口
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page1],@"action":@"queryVisit",@"table":@"khbf"};
    
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户拜访浏览%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                KHbaifangModel *model = [[KHbaifangModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }

        }
       [self.liuLanTableView reloadData];
        }

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
}

- (void)DataRequest1
{
    //客户拜访列表审批的接口  
    /*
     custVisit
     action=queryVisit
     table=khbf
     flag=0
     order=desc
     biaoshi=true
     page=1
     rows=20*/
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page2],@"action":@"queryVisit",@"table":@"khbf",@"biaoshi":@"true",@"params":@"{\"spstatusEQ\":\"0\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户拜访浏览%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                KHbaifangModel *model = [[KHbaifangModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
            
        }
             [self.shenPiTableView reloadData];
        }
        [_HUD hide:YES afterDelay:1];
        [_HUD removeFromSuperview];
       
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD removeFromSuperview];
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];

        
    
    
}
#pragma mark - 页面设置
- (void)PageViewDidLoad1
{
    //标题下方的2个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 49)];
    //buttonView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, KscreenWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttonView];
    [self.view addSubview:line];
    //搜索按钮
    self.souSuoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.souSuoButton.frame = CGRectMake(5, 5, 40, 40);
    [self.souSuoButton setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [buttonView addSubview:self.souSuoButton];
    [self.souSuoButton addTarget:self action:@selector(souSuoButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //2个按钮的设置
    _liuLanButton =[[UIButton alloc]initWithFrame:CGRectMake(50, 0, (KscreenWidth - 50)/2, 49)];
    [_liuLanButton setTitle:@"浏览" forState:UIControlStateNormal];
    _liuLanButton.tag = 0;
    _liuLanButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_liuLanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_liuLanButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

//    [_liuLanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_liuLanButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _liuLanButton.backgroundColor = [UIColor whiteColor];
    
    [_liuLanButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _currentBtn = _liuLanButton;
    _currentBtn.selected = YES;
    [buttonView addSubview:_liuLanButton];
    [_btnArray addObject:_liuLanButton];
    
    _shenPiButton =[[UIButton alloc]initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/2,0 , (KscreenWidth - 50)/2,49)];
    [_shenPiButton setTitle:@"批复" forState:UIControlStateNormal];
    _shenPiButton.tag = 1;
//    [_shenPiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_shenPiButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_shenPiButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_shenPiButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    //[_shenPiButton setBackgroundColor:[UIColor lightGrayColor]];
    
    [_shenPiButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _shenPiButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [buttonView addSubview:_shenPiButton];
    [_btnArray addObject:_shenPiButton];
    
    //标题下方View的设置;
    //UIScrollerView
    self.mainScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,50, KscreenWidth, KscreenHeight-114)];
    self.mainScrollView.contentSize = CGSizeMake(KscreenWidth *2, KscreenHeight-114);
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    //scrollView上面的2个tableview实例化 并且添加到scrollView上去
    self.liuLanTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.liuLanTableView.delegate = self;
    self.liuLanTableView.dataSource = self;
    self.liuLanTableView.tag = 10;
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
    
    self.shenPiTableView =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.shenPiTableView.delegate = self;
    self.shenPiTableView.dataSource = self;
    self.shenPiTableView.tag = 20;
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
                    _currentBtn = _btnArray[i];
                    
                    
                }
                _currentBtn.selected = YES;
                _currentBtn.backgroundColor = [UIColor whiteColor];
                
            }
        }
    }
}


-(void)newRefresh{
    
    [self refreshData];
    [self refreshData2];
    
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
    if (_searchFlag == 1) {
        [_searchDateArray1 removeAllObjects];
        _searchPage1 = 1;
        [self getSp];
        [_refreshControl2 endRefreshing];
    }else{
        [_dataArray2 removeAllObjects];
        _page2 = 1;
        [self DataRequest1];
        [_refreshControl2 endRefreshing];
    }
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
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage1++;
        [self getSp];
    }else{
        [_HUD show:YES];
        _page2++;
        [self DataRequest1];
    }
}
- (void)upRefresh3
{
    _page++;
    [self nameRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh1];
        }
    } else if (scrollView.tag == 20)
    {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh2];
        }
    }else if(scrollView.tag == 30){
        if(scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30){
            [self upRefresh3];
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
    }
    else if(tableView == self.shenPiTableView){
        if (_searchFlag == 1) {
            return _searchDateArray1.count;
        }else{
            return _dataArray2.count;
        }
    }else if(tableView == self.nameTableView) {
        return _dataArray.count;
    }else if(tableView == self.salerTableView){
        return _salerArray.count;
    }else if(tableView == self.typeTableView){
        return _keHuFenLeiArr.count;
    }else if(tableView == self.classTableView){
        return _keHuXingZhiArr.count;
    }else {
        return _statusArray.count;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    LiuLanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell =(LiuLanCell *) [[[NSBundle mainBundle] loadNibNamed:@"LiuLanCell" owner:self options:nil]firstObject];
    }
    ShenPiCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(ShenPiCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShenPiCell" owner:self options:nil]firstObject];
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
                cell.call.userInteractionEnabled = YES;
            }
        }else{
            if(_dataArray1.count != 0){
                cell.model = _dataArray1[indexPath.row];
                cell.call.userInteractionEnabled = YES;
            }
        }
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        cell.call.tag = indexPath.row;
        [cell.call addGestureRecognizer:tap1];
        return cell;
    }
    else if (tableView == self.shenPiTableView)
    {
        if (_searchFlag == 1) {
            if (_searchDateArray1.count != 0) {
                cell1.model = _searchDateArray1[indexPath.row];
                cell1.call.userInteractionEnabled = YES;
            }
        }else{
            if (_dataArray2.count != 0) {
                cell1.model = _dataArray2[indexPath.row];
                cell1.call.userInteractionEnabled = YES;
            }
        }
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone2:)];
        cell1.call.tag = indexPath.row;
        [cell1.call addGestureRecognizer:tap2];
        return cell1;
    }else if(tableView == self.nameTableView){
        if (_dataArray.count!=0) {
            KHnameModel *model = [_dataArray objectAtIndex:indexPath.row];
            cell2.textLabel.text =  model.name;
        }
        return cell2;
    }else if(tableView == self.salerTableView){
        if (_salerArray.count!=0) {
            CommonModel *model = _salerArray[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }else if(tableView == self.typeTableView){
        if (_keHuFenLeiArr.count != 0) {
            CommonModel *model = _keHuFenLeiArr[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }else if(tableView == self.classTableView){
        cell2.textLabel.text = _keHuXingZhiArr[indexPath.row];
        return cell2;
    }else if(tableView == self.tracelevelTableView){
        if (_statusArray.count != 0) {
            CommonModel *model = _statusArray[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }
    return cell;
   
}

- (void)callPhone:(UITapGestureRecognizer *)tap
{
    KHbaifangModel *model = [_dataArray1 objectAtIndex:tap.view.tag];
    if (model.cellno.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"暂无电话号码！"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",model.cellno]]];
    }
    
    
}
- (void)callPhone2:(UITapGestureRecognizer *)tap
{
    KHbaifangModel *model = [_dataArray2 objectAtIndex:tap.view.tag];
    
    if (model.cellno.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"暂无电话号码！"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",model.cellno]]];
    }

}

//点击事件，进入拜访详情页面;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView)
    {
        LiuLanBaiFangVC *liuLanMessage = [[LiuLanBaiFangVC alloc]initWithNibName:nil bundle:nil];
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                KHbaifangModel *model = [_searchDateArray objectAtIndex:indexPath.row];
                liuLanMessage.model = model;
            }
        }else{
            if (_dataArray1.count != 0) {
                KHbaifangModel *model = [_dataArray1 objectAtIndex:indexPath.row];
                liuLanMessage.model = model;
            }
        }
        [self.navigationController pushViewController:liuLanMessage animated:YES];
        
        
        
    }
    else if(tableView == self.shenPiTableView){
        ShenPiBaiFangVC *baiFangMessage =[[ShenPiBaiFangVC alloc]initWithNibName:nil bundle:nil];
        if (_searchFlag == 1) {
            if (_searchDateArray1.count != 0) {
                KHbaifangModel *model = [_searchDateArray1 objectAtIndex:indexPath.row];
                baiFangMessage.model = model;
            }
        }else{
            if (_dataArray2.count != 0) {
                KHbaifangModel *model = [_dataArray2 objectAtIndex:indexPath.row];
                baiFangMessage.model = model;
            }
        }
        [self.navigationController pushViewController:baiFangMessage animated:YES];
    }else if(tableView == self.nameTableView){
        if (_dataArray.count!=0) {
            KHnameModel *model = _dataArray[indexPath.row];
            [_nameButton setTitle:model.name forState:UIControlStateNormal];
            _nameButton.userInteractionEnabled = YES;
            _custId = model.Id;
        }
    }else if(tableView == self.salerTableView){
        if (_salerArray.count!=0) {
            CommonModel *model = _salerArray[indexPath.row];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerButton.userInteractionEnabled = YES;
            _accountId = model.Id;
        }
    }else if(tableView == self.typeTableView){
        CommonModel *model = _keHuFenLeiArr[indexPath.row];
        [_typeButton setTitle:model.name forState:UIControlStateNormal];
        _typeButton.userInteractionEnabled = YES;
        _classId = model.Id;
    }
    else if(tableView == self.classTableView){
        NSString *class = _keHuXingZhiArr[indexPath.row];
        [_classButton setTitle:class forState:UIControlStateNormal];
        _classButton.userInteractionEnabled = YES;
        
    }
    else if(tableView == self.tracelevelTableView){
        CommonModel *model = _statusArray[indexPath.row];
        [_tracelevelButton setTitle:model.name forState:UIControlStateNormal];
        _tracelevelButton.userInteractionEnabled = YES;
        _tracelevelId = model.Id;
    }
    [self.m_keHuPopView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView||tableView == self.shenPiTableView) {
        return 65;
    }else {
    
        return 45;
    }
}
- (void)addNext{
    
    BaiFangShangBaoVC *baifangVC = [[BaiFangShangBaoVC alloc] init];
    [self.navigationController pushViewController:baifangVC animated:YES];
    
    
}
//
- (void)searchAction{
    
    ZhouBianViewController *zbVC = [[ZhouBianViewController alloc] init];
    [self.navigationController pushViewController:zbVC animated:YES];
}


@end
