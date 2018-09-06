//
//  ShouHouFuWuViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ShouHouFuWuViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "JDXJCell.h"
#import "JDXJModel.h"
#import "YYZJModel.h"
#import "YYZJCell.h"
#import "SHHFCell.h"
#import "SHHFMOdel.h"
#import "WXGLCell.h"
#import "WXGLModel.h"
#import "JDXJDetailView.h"
#import "YYZJDetailView.h"
#import "SHHFDetailView.h"
#import "WXGLDetailView.h"
#import "JDXJAddView.h"
#import "YYZJAddView.h"
#import "SHHFAddView.h"
#import "WXGLAddView.h"
#import "YeWuYuanModel.h"
#import "KHnameModel.h"
@interface ShouHouFuWuViewController (){
    UIRefreshControl *_refreshControl1;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    UIRefreshControl *_refreshControl4;
    
    UIButton *_souSuoButton;
    UIButton *_Button1;
    UIButton *_Button2;
    UIButton *_Button3;
    UIButton *_Button4;
    UIButton *_currentBtn;
    NSMutableArray *_btnArray;
    MBProgressHUD *_HUD;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;
    NSMutableArray *_dataArray4;
    NSString *_currentDateStr;
    
}
@property(nonatomic,retain)UIScrollView *shScrollView;
@property(nonatomic,retain)UITableView *tableView1;
@property(nonatomic,retain)UITableView *tableView2;
@property(nonatomic,retain)UITableView *tableView3;
@property(nonatomic,retain)UITableView *tableView4;
@property(nonatomic,retain)UIDatePicker *datePicker;
@property(nonatomic,retain)UIView *listBackView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *custTableView;


@end

@implementation ShouHouFuWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"售后服务";
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    _btnArray = [NSMutableArray array];
    _dataArray1  = [NSMutableArray array];
    _dataArray2 = [NSMutableArray array];
    _dataArray3  = [NSMutableArray array];
    _dataArray4  = [NSMutableArray array];
    _salerArray = [NSMutableArray array];
    _custArray = [NSMutableArray array];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self DataRequest1];
        [self DataRequest2];
        [self DataRequest3];
        [self DataRequest4];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self initView];
            //进度HUD
            _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //设置模式为进度框形的
            _HUD.mode = MBProgressHUDModeIndeterminate;
            _HUD.labelText = @"网络不给力，正在加载中...";
            [_HUD show:YES];

        });
    });
   

    
}
- (void)initView{
    //搜索按钮的设置
    _souSuoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _souSuoButton.frame = CGRectMake(0, 0, 50, 50);
    _souSuoButton.backgroundColor = [UIColor lightGrayColor];
    [_souSuoButton setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    //[_souSuoButton setBackgroundImage:[UIImage imageNamed:@"menu_return"] forState:UIControlStateHighlighted];
    [self.view addSubview:_souSuoButton];
    [_souSuoButton addTarget:self action:@selector(souSuoButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //4个按钮的设置
    //
    _Button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 0,(KscreenWidth - 50)/4, 50)];
    [_Button1 setTitle:@"季度巡检" forState:UIControlStateNormal];
    _Button1.tag = 0;
    [_Button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _Button1.backgroundColor = [UIColor whiteColor];
    
    _currentBtn = _Button1;
    _currentBtn.selected = YES;
    
    [_Button1 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _Button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_Button1];
    [_btnArray addObject:_Button1];
    //
    _Button2 = [[UIButton alloc]initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/4, 0, (KscreenWidth - 50)/4, 50)];
    [_Button2 setTitle:@"预约装机" forState:UIControlStateNormal];
    _Button2.tag = 1;
    [_Button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _Button2.backgroundColor = [UIColor lightGrayColor];
    
    [_Button2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _Button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_Button2];
    [_btnArray addObject:_Button2];
    //
    _Button3 = [[UIButton alloc]initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/4*2, 0, (KscreenWidth - 50)/4, 50)];
    [_Button3 setTitle:@"售后回访" forState:UIControlStateNormal];
    _Button3.tag = 2;
    [_Button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _Button3.backgroundColor = [UIColor lightGrayColor];
    
    [_Button3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _Button3.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_Button3];
    [_btnArray addObject:_Button3];
    //
    _Button4 = [[UIButton alloc]initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/4*3, 0, (KscreenWidth - 50)/4, 50)];
    [_Button4 setTitle:@"维修管理" forState:UIControlStateNormal];
    _Button4.tag = 3;
    [_Button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button4 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _Button4.backgroundColor = [UIColor lightGrayColor];
    
    [_Button4 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _Button4.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_Button4];
    [_btnArray addObject:_Button4];
    
    //标题下方View的设置;
    //UIScrollerView
    self.shScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,KscreenWidth, KscreenHeight - 114)];
    self.shScrollView.contentSize = CGSizeMake(KscreenWidth *4, KscreenHeight-114);
    self.shScrollView.pagingEnabled = YES;
    self.shScrollView.bounces = NO;
    self.shScrollView.delegate = self;
    [self.view addSubview:self.shScrollView];
    //scrollView上面的三个tableview实例化 并且添加到scrollView上去
    //季度巡检
    _tableView1 =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.rowHeight = 65;
    _tableView1.tag = 151;
//    _refreshControl1 = [[UIRefreshControl alloc] init];
//    _refreshControl1.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl1 addTarget:self action:@selector(refreshData1) forControlEvents:UIControlEventValueChanged];
//    [_tableView1 addSubview:_refreshControl1];
    [self.shScrollView addSubview:_tableView1];
    //     下拉刷新
    _tableView1.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown1];
        // 结束刷新
        [_tableView1.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView1.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tableView1.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [_tableView1.mj_footer endRefreshing];
    }];

    //预约装机
    _tableView2 =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.rowHeight = 65;
    _tableView2.tag = 152;
//    _refreshControl2 = [[UIRefreshControl alloc] init];
//    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
//    [_tableView2 addSubview:_refreshControl2];
    [self.shScrollView addSubview:_tableView2];
    //     下拉刷新
    _tableView2.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown2];
        // 结束刷新
        [_tableView2.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView2.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tableView2.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh2];
        [_tableView2.mj_footer endRefreshing];
    }];
    //售后回访
    _tableView3 =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth * 2, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    _tableView3.delegate = self;
    _tableView3.dataSource = self;
    _tableView3.rowHeight = 65;
    _tableView3.tag = 153;
//    _refreshControl3 = [[UIRefreshControl alloc] init];
//    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl3 addTarget:self action:@selector(refreshData3) forControlEvents:UIControlEventValueChanged];
//    [_tableView3 addSubview:_refreshControl3];
    [self.shScrollView addSubview:_tableView3];
    //     下拉刷新
    _tableView3.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown3];
        // 结束刷新
        [_tableView3.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView3.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tableView3.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh3];
        [_tableView3.mj_footer endRefreshing];
    }];
    //维修管理
    _tableView4 =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth * 3, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    _tableView4.delegate=self;
    _tableView4.dataSource=self;
    _tableView4.rowHeight = 65;
    _tableView4.tag = 154;
//    _refreshControl4 = [[UIRefreshControl alloc] init];
//    _refreshControl4.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl4 addTarget:self action:@selector(refreshData4) forControlEvents:UIControlEventValueChanged];
//    [_tableView4 addSubview:_refreshControl4];
    [self.shScrollView addSubview:_tableView4];
    //     下拉刷新
    _tableView4.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown4];
        // 结束刷新
        [_tableView4.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView4.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tableView4.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh4];
        [_tableView4.mj_footer endRefreshing];
    }];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
}
#pragma mark - 搜索页面
- (void)initsearchView{
    
    
    //信息视图
    if (_currentBtn.tag == 0) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 51, KscreenWidth/3, KscreenHeight -64 - 51)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 51, KscreenWidth/3*2, KscreenHeight - 64 -51)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"巡检人员";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
        [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
        [_salerButton setTintColor:[UIColor blackColor]];
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        nameView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_salerButton];
        [_searchView addSubview:nameView];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"客户名称";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
        [_custButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_custButton];
        [_searchView addSubview:salerView];
        //
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
        Label3.text = @"巡检日期";
        Label3.backgroundColor = COLOR(231, 231, 231, 1);
        Label3.font = [UIFont systemFontOfSize:15.0];
        Label3.textAlignment = NSTextAlignmentCenter;
        _date1 = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date1.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
        [_date1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date1 addTarget:self action:@selector(date1) forControlEvents:UIControlEventTouchUpInside];
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
        typeView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label3];
        [_searchView addSubview:_date1];
        [_searchView addSubview:typeView];
        
        //
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
        Label4.text = @"至";
        Label4.backgroundColor = COLOR(231, 231, 231, 1);
        Label4.font = [UIFont systemFontOfSize:15.0];
        Label4.textAlignment = NSTextAlignmentCenter;
        _date2= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date2.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
        [_date2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date2 addTarget:self action:@selector(date2) forControlEvents:UIControlEventTouchUpInside];
        UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
        startView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label4];
        [_searchView addSubview:_date2];
        [_searchView addSubview:startView];
        UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 163)];
        //
        fenGeXian.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:fenGeXian];
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 180, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 180, 60, 30);
        [chongZhi addTarget:self action:@selector(reSet) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
    }else if(_currentBtn.tag == 1){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 51, KscreenWidth/3, KscreenHeight -64 - 51)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 51, KscreenWidth/3*2, KscreenHeight - 64 -51)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"装机人员";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
        [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
        [_salerButton setTintColor:[UIColor blackColor]];
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        nameView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_salerButton];
        [_searchView addSubview:nameView];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"客户名称";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
        [_custButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_custButton];
        [_searchView addSubview:salerView];
        //
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
        Label3.text = @"装机日期";
        Label3.backgroundColor = COLOR(231, 231, 231, 1);
        Label3.font = [UIFont systemFontOfSize:15.0];
        Label3.textAlignment = NSTextAlignmentCenter;
        _date1 = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date1.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
        [_date1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date1 addTarget:self action:@selector(date1) forControlEvents:UIControlEventTouchUpInside];
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
        typeView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label3];
        [_searchView addSubview:_date1];
        [_searchView addSubview:typeView];
        
        //
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
        Label4.text = @"至";
        Label4.backgroundColor = COLOR(231, 231, 231, 1);
        Label4.font = [UIFont systemFontOfSize:15.0];
        Label4.textAlignment = NSTextAlignmentCenter;
        _date2= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date2.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
        [_date2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date2 addTarget:self action:@selector(date2) forControlEvents:UIControlEventTouchUpInside];
        UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
        startView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label4];
        [_searchView addSubview:_date2];
        [_searchView addSubview:startView];
        UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 163)];
        //
        fenGeXian.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:fenGeXian];
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 180, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 180, 60, 30);
        [chongZhi addTarget:self action:@selector(reSet) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
        
    }else if(_currentBtn.tag == 2){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 51, KscreenWidth/3, KscreenHeight -64 - 51)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 51, KscreenWidth/3*2, KscreenHeight - 64 -51)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"回访人员";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
        [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
        [_salerButton setTintColor:[UIColor blackColor]];
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        nameView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_salerButton];
        [_searchView addSubview:nameView];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"客户名称";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
        [_custButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_custButton];
        [_searchView addSubview:salerView];
        //
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
        Label3.text = @"维护日期";
        Label3.backgroundColor = COLOR(231, 231, 231, 1);
        Label3.font = [UIFont systemFontOfSize:15.0];
        Label3.textAlignment = NSTextAlignmentCenter;
        _date1 = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date1.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
        [_date1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date1 addTarget:self action:@selector(date1) forControlEvents:UIControlEventTouchUpInside];
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
        typeView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label3];
        [_searchView addSubview:_date1];
        [_searchView addSubview:typeView];
        
        //
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
        Label4.text = @"至";
        Label4.backgroundColor = COLOR(231, 231, 231, 1);
        Label4.font = [UIFont systemFontOfSize:15.0];
        Label4.textAlignment = NSTextAlignmentCenter;
        _date2= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date2.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
        [_date2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date2 addTarget:self action:@selector(date2) forControlEvents:UIControlEventTouchUpInside];
        UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
        startView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label4];
        [_searchView addSubview:_date2];
        [_searchView addSubview:startView];
        UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 163)];
        //
        fenGeXian.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:fenGeXian];
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 180, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 180, 60, 30);
        [chongZhi addTarget:self action:@selector(reSet) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
        
    }else if(_currentBtn.tag == 3){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 51, KscreenWidth/3, KscreenHeight -64 - 51)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = .6;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backView addGestureRecognizer:singleTap];
        [self.view addSubview:_backView];
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 51, KscreenWidth/3*2, KscreenHeight - 64 -51)];
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
        Label1.text = @"维修人员";
        Label1.backgroundColor = COLOR(231, 231, 231, 1);
        Label1.font = [UIFont systemFontOfSize:15.0];
        Label1.textAlignment = NSTextAlignmentCenter;
        _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
        [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
        [_salerButton setTintColor:[UIColor blackColor]];
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
        nameView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label1];
        [_searchView addSubview:_salerButton];
        [_searchView addSubview:nameView];
        //
        UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
        Label2.text = @"客户名称";
        Label2.backgroundColor = COLOR(231, 231, 231, 1);
        Label2.font = [UIFont systemFontOfSize:15.0];
        Label2.textAlignment = NSTextAlignmentCenter;
        _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _custButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
        [_custButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
        salerView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label2];
        [_searchView addSubview:_custButton];
        [_searchView addSubview:salerView];
        //
        UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
        Label3.text = @"维修日期";
        Label3.backgroundColor = COLOR(231, 231, 231, 1);
        Label3.font = [UIFont systemFontOfSize:15.0];
        Label3.textAlignment = NSTextAlignmentCenter;
        _date1 = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date1.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
        [_date1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date1 addTarget:self action:@selector(date1) forControlEvents:UIControlEventTouchUpInside];
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
        typeView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label3];
        [_searchView addSubview:_date1];
        [_searchView addSubview:typeView];
        
        //
        UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
        Label4.text = @"至";
        Label4.backgroundColor = COLOR(231, 231, 231, 1);
        Label4.font = [UIFont systemFontOfSize:15.0];
        Label4.textAlignment = NSTextAlignmentCenter;
        _date2= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
        _date2.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
        [_date2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_date2 addTarget:self action:@selector(date2) forControlEvents:UIControlEventTouchUpInside];
        UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
        startView.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:Label4];
        [_searchView addSubview:_date2];
        [_searchView addSubview:startView];
        UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 163)];
        //
        fenGeXian.backgroundColor = [UIColor grayColor];
        [_searchView addSubview:fenGeXian];
        
        //
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor grayColor];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.frame = CGRectMake(20, 180, 60, 30);
        [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
        [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongZhi setBackgroundColor:[UIColor grayColor]];
        [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
        chongZhi.frame = CGRectMake(120, 180, 60, 30);
        [chongZhi addTarget:self action:@selector(reSet) forControlEvents:UIControlEventTouchUpInside];
        
        [_searchView addSubview:searchBtn];
        [_searchView addSubview:chongZhi];
        [self.view  addSubview:_searchView];
    }
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
    [_custButton setTitle:@" " forState:UIControlStateNormal];
    [_date1 setTitle:@" " forState:UIControlStateNormal];
    [_date2 setTitle:_currentDateStr forState:UIControlStateNormal];
    
}

- (void)singleTapAction{
    
    _backView.hidden = YES;
    _searchView.hidden = YES;
}

- (void)souSuoButtonClickMethod
{   [self initsearchView];
//    if ([_searchView isHidden]) {
//    _searchView.hidden = NO;
//    _backView.hidden = NO;
//}
//else if (![_searchView isHidden])
//{
//    _searchView.hidden = YES;
//    _backView.hidden = YES;
//}

    

}
#pragma mark - 业务员
- (void)salerAction{
    
    _salerButton.userInteractionEnabled = NO;
    
    self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth-120, KscreenHeight-144)];
    self.listBackView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listBackView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [self.listBackView addSubview:btn];
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor grayColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.tag = 10;
    _refreshControl5 = [[UIRefreshControl alloc] init];
    
    [_refreshControl5 addTarget:self action:@selector(refreshData5) forControlEvents:UIControlEventValueChanged];
    [self.salerTableView addSubview:_refreshControl1];
    [self.listBackView addSubview:self.salerTableView];
    [self.view addSubview:self.listBackView];
    [self salerRequest];
    [self.salerTableView reloadData];
}
- (void)refreshData5
{
    //开始刷新
    _refreshControl5.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl5 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown5) userInfo:nil repeats:NO];
}
- (void)refreshDown5
{
    [_salerArray removeAllObjects];
    _page5 = 1;
    [self salerRequest];
    [_refreshControl5 endRefreshing];
}
//上拉加载更多
- (void)upRefresh5
{
    _page5 ++;
    [self salerRequest];
}

- (void)closeback{
    [_listBackView removeFromSuperview];
    [_salerTableView removeFromSuperview];
    [_custButton removeFromSuperview];
    _salerButton.userInteractionEnabled = YES;
    _custButton.userInteractionEnabled = YES;
}
- (void)salerRequest{
    /*
     account
     action:"getPrincipals"
     table:"yhzh"
     cflag:"1"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getPrincipals&table=ddxx&page=%@&rows=20",[NSString stringWithFormat:@"%zi",_page5]];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // NSLog(@"业务员%@",array);
    if (data1 != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"业务员%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic  in array) {
                YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_salerArray addObject:model];
            }

        }
        
    }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }
}
#pragma mark - 客户
- (void)custAction{
    _custButton.userInteractionEnabled = NO;
    
    self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth-120, KscreenHeight-144)];
    self.listBackView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listBackView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [self.listBackView addSubview:btn];
    
    if (self.custTableView == nil) {
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor grayColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 20;
    _refreshControl6 = [[UIRefreshControl alloc] init];
    [_refreshControl6 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
    [self.custTableView addSubview:_refreshControl2];
    [self.listBackView addSubview:self.custTableView];
    [self.view addSubview:self.listBackView];
    [self nameRequest];
    [self.custTableView reloadData];
}
//下拉刷新
- (void)refreshData6
{
    //开始刷新
    _refreshControl6.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl6 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown6) userInfo:nil repeats:NO];
}
- (void)refreshDown6
{
    [_custArray removeAllObjects];
    _page6 = 1;
    [self nameRequest];
    [_refreshControl6 endRefreshing];
}
//上拉加载更多
- (void)upRefresh6
{
    _page6 ++;
    [self nameRequest];
}

- (void)nameRequest
{
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"rows=20&mobile=true&page=%zi&action=getSelectName&table=khxx",_page6];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"客户名字:%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                KHnameModel *model = [[KHnameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_custArray addObject:model];
            }
            [self.custTableView reloadData];
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
        
        
    }
}
#pragma amrk - 时间
- (void)date1{
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
- (void)dateChange:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_date1 setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}

- (void)date2{
    
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
- (void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_date2 setTitle:dateString forState:UIControlStateNormal];
}
#pragma mark - 搜索方法
- (void)search{
    
    if (_currentBtn.tag == 0) {
        /*custService
         action:"getBeans"
         table:"jdxj"
         page:"1"
         rows:"20"
         params:"{"table":"jdxj","routingnameLIKE":"管理员","custnameLIKE":"临清吉利养殖","nextroutingdateGE":"2015-06-07","nextroutingdateLE":"2015-06-10"}"
         */
        
         NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=jdxj"];
         NSURL *url = [NSURL URLWithString:urlStr];
         NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
         [request setHTTPMethod:@"POST"];
         NSString *str =[NSString stringWithFormat:@"rows=20&page=1&params={\"table\":\"jdxj\",\"routingnameLIKE\":\"%@\",\"custnameLIKE\":\"%@\",\"nextroutingdateGE\":\"%@\",\"nextroutingdateLE\":\"%@\"}",_salerButton.titleLabel.text,_custButton.titleLabel.text,_date1.titleLabel.text,_date2.titleLabel.text];
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
         
             JDXJModel *model = [[JDXJModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [_dataArray1 addObject:model];
         }
             [_HUD hide:YES];
             [self.tableView1 reloadData];
             [_searchView removeFromSuperview];
             [_backView removeFromSuperview];
         }

    }else if(_currentBtn.tag == 1){
        /*custService
         action:"getBeans"
        table:"yyzj"
         page:"1"
         rows:"20"
         params:"{"table":"yyzj","salernameLIKE":"贾玉萌","custnameLIKE":"临清吉利养殖","installdateGE":"2015-06-08","installdateLE":"2015-06-10"}"
         */
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=yyzj"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"rows=20&page=1&params={\"table\":\"yyzj\",\"salernameLIKE\":\"%@\",\"custnameLIKE\":\"%@\",\"installdateGE\":\"%@\",\"installdateLE\":\"%@\"}",_salerButton.titleLabel.text,_custButton.titleLabel.text,_date1.titleLabel.text,_date2.titleLabel.text];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"搜索上传的字符串%@",str);
            NSLog(@"搜索列表数据:%@",dic);
            NSArray *array = dic[@"rows"];
            [_dataArray2 removeAllObjects];
            for (NSDictionary *dic in array) {
                
                YYZJModel *model = [[YYZJModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
            [_HUD hide:YES];
            [self.tableView2 reloadData];
            [_searchView removeFromSuperview];
            [_backView removeFromSuperview];
        }

        
    }else if(_currentBtn.tag == 2){
        /*custService
         action:"getBeans"
         table:"shhf"
         page:"1"
         rows:"20"
         params:"{"table":"shhf","visitornameLIKE":"王彦卿","custnameLIKE":"郓城吉发兽药","repairdateGE":"2015-06-08","repairdateLE":"2015-06-10"}"
         */
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=shhf"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"rows=20&page=1&params={\"table\":\"shhf\",\"visitornameLIKE\":\"%@\",\"custnameLIKE\":\"%@\",\"repairdateGE\":\"%@\",\"repairdateLE\":\"%@\"}",_salerButton.titleLabel.text,_custButton.titleLabel.text,_date1.titleLabel.text,_date2.titleLabel.text];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"搜索上传的字符串%@",str);
            NSLog(@"搜索列表数据:%@",dic);
            NSArray *array = dic[@"rows"];
            [_dataArray3 removeAllObjects];
            for (NSDictionary *dic in array) {
                
                SHHFMOdel *model = [[SHHFMOdel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray3 addObject:model];
            }
            [_HUD hide:YES];
            [self.tableView3 reloadData];
            [_searchView removeFromSuperview];
            [_backView removeFromSuperview];
        }

       
        
    }else if(_currentBtn.tag == 3){
        /*custService
         action:"getBeans"
         table:"wxsb"
         page:"1"
         rows:"20"
         params:"{"table":"wxsb","repairnameLIKE":"张宝英","custnameLIKE":"淄川飞宇药业","repairdateGE":"2015-06-07","repairdateLE":"2015-06-10"}"
         */
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=wxsb"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"rows=20&page=1&params={\"table\":\"wxsb\",\"repairnameLIKE\":\"%@\",\"custnameLIKE\":\"%@\",\"repairdateGE\":\"%@\",\"repairdateLE\":\"%@\"}",_salerButton.titleLabel.text,_custButton.titleLabel.text,_date1.titleLabel.text,_date2.titleLabel.text];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"搜索上传的字符串%@",str);
            NSLog(@"搜索列表数据:%@",dic);
            NSArray *array = dic[@"rows"];
            [_dataArray4 removeAllObjects];
            for (NSDictionary *dic in array) {
                
                WXGLModel *model = [[WXGLModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray4 addObject:model];
            }
            [_HUD hide:YES];
            [self.tableView4 reloadData];
            [_searchView removeFromSuperview];
            [_backView removeFromSuperview];
        }

        
    }

    
    
    
}
- (void)reSet{
    //重置 设置属性为空
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
    [_custButton setTitle:@" " forState:UIControlStateNormal];
    [_date1 setTitle:@" " forState:UIControlStateNormal];
    [_date2 setTitle:@" " forState:UIControlStateNormal];

}


#pragma mark - 下拉刷新
- (void)refreshData1{
    //开始刷新
    _refreshControl1.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl1 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown1) userInfo:nil repeats:NO];
}
- (void)refreshDown1
{
    [_dataArray1 removeAllObjects];
    _page1 = 1;
    [self DataRequest1];
    [_refreshControl1 endRefreshing];
}

- (void)refreshData2{
    //开始刷新
    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl2 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown2) userInfo:nil repeats:NO];
}
- (void)refreshDown2
{
    [_dataArray2 removeAllObjects];
    _page2 = 1;
    [self DataRequest2];
    [_refreshControl2 endRefreshing];
}
- (void)refreshData3{
    //开始刷新
    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl3 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown3) userInfo:nil repeats:NO];
}
- (void)refreshDown3
{
    [_dataArray3 removeAllObjects];
    _page3 = 1;
    [self DataRequest3];
    [_refreshControl3 endRefreshing];
}
- (void)refreshData4{
    //开始刷新
    _refreshControl4.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl4 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown4) userInfo:nil repeats:NO];
}
- (void)refreshDown4
{
    [_dataArray4 removeAllObjects];
    _page4 = 1;
    [self DataRequest4];
    [_refreshControl4 endRefreshing];
}
#pragma mark - 上拉加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 151) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh1];
        }
        
    } else if (scrollView.tag == 152){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh2];
        }
    } else if (scrollView.tag == 153){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh3];
        }
    }else  if (scrollView.tag == 154){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh4];
        }
    }else if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
        }
    }else if(scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
        }
    }

}

- (void)upRefresh1
{
    [_HUD show:YES];
    _page1++;
    [self DataRequest1];
}

- (void)upRefresh2
{
    [_HUD show:YES];
    _page2++;
    [self DataRequest2];
    
}
- (void)upRefresh3
{
    [_HUD show:YES];
    _page3++;
    [self DataRequest3];
}
- (void)upRefresh4
{
    [_HUD show:YES];
    _page4++;
    [self DataRequest4];
}

//标题按钮
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
    [self.shScrollView setContentOffset:CGPointMake(btn.tag * KscreenWidth, 0) animated:YES];
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

#pragma mark - 浏览数据加载
- (void)DataRequest1{
    /*季度巡检接口：
     custService
     action:"getBeans"
     table:"jdxj"
     page:"1"
     rows:"20"
     params:"{"table":"jdxj","routingnameLIKE":"","custnameLIKE":"","nextroutingdateGE":"","nextroutingdateLE":""}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=jdxj"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page1],@"params":@{@"table":@"jdxj",@"routingnameLIKE":@"",@"custnameLIKE":@"",@"nextroutingdateGE":@"",@"nextroutingdateLE":@""}};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                JDXJModel *model = [[JDXJModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
        }
        NSLog(@"季度巡检数据%@",array);
        [self.tableView1 reloadData];
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
- (void)DataRequest2{
    /*预约装机接口：
     custService
     action:"getBeans"
     table:"yyzj"
     page:"1"
     rows:"20"
     params:"{"table":"yyzj","salernameLIKE":"","custnameLIKE":"","installdateGE":"","installdateLE":""}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=yyzj"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page2],@"params":@{@"table":@"yyzj",@"salernameLIKE":@"",@"custnameLIKE":@"",@"installdateGE":@"",@"installdateLE":@""}};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                YYZJModel *model = [[YYZJModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
        }
        NSLog(@"预约装机数据%@",array);
        [self.tableView2 reloadData];
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
- (void)DataRequest3{
    /*售后回访接口：
     custService
     action:"getBeans"
     table:"shhf"
     page:"1"
     rows:"20"
params:"{"table":"shhf","visitornameLIKE":"","custnameLIKE":"","repairdateGE":"","repairdateLE":"",,"undefined":]}"     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=shhf"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page3],@"params":@{@"table":@"shhf",@"visitornameLIKE":@"",@"custnameLIKE":@"",@"repairdateGE":@"",@"repairdateLE":@""}};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        NSLog(@"售后回访数据%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                SHHFMOdel *model = [[SHHFMOdel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray3 addObject:model];
            }
        }
        
        [self.tableView3 reloadData];
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
- (void)DataRequest4{
    /*维修管理接口：
     custService
     action:"getBeans"
     table:"wxsb"
     page:"1"
     rows:"20"
     params:"{"table":"wxsb","repairnameLIKE":"","custnameLIKE":"","repairdateGE":"","repairdateLE":""}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=getBeans&table=wxsb"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page4],@"params":@{@"table":@"wxsb",@"repairnameLIKE":@"",@"custnameLIKE":@"",@"repairdateGE":@"",@"repairdateLE":@""}};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        NSLog(@"维修管理数据%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                WXGLModel *model = [[WXGLModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray4 addObject:model];
            }
        }
        [self.tableView4 reloadData];
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




#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView1){
        return _dataArray1.count;
    }else if(tableView == self.tableView2){
        return _dataArray2.count;
    }else if(tableView == self.tableView3){
        return _dataArray3.count;
    }else if(tableView == self.tableView4){
        return _dataArray4.count;
    }else if (tableView == self.salerTableView){
        return _salerArray.count;
    }else if(tableView == self.custTableView){
        return _custArray.count;
    }
        
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_1";
    JDXJCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"JDXJCell" owner:self options:nil]lastObject];
        cell1.backgroundColor = [UIColor clearColor];
    }
    YYZJCell *cell2 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell2 == nil) {
        cell2 = [[[NSBundle mainBundle] loadNibNamed:@"YYZJCell" owner:self options:nil]lastObject];
        cell2.backgroundColor = [UIColor clearColor];
    }
    SHHFCell *cell3 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell3 == nil) {
        cell3 = [[[NSBundle mainBundle] loadNibNamed:@"SHHFCell" owner:self options:nil]lastObject];
        cell3.backgroundColor = [UIColor clearColor];
    }
    WXGLCell *cell4 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell4 == nil) {
        cell4 = [[[NSBundle mainBundle] loadNibNamed:@"WXGLCell" owner:self options:nil]lastObject];
        cell4.backgroundColor = [UIColor clearColor];
    }
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (tableView == self.tableView1) {
        if (_dataArray1.count != 0) {
            cell1.model = _dataArray1[indexPath.row];
            return cell1;

            }
    }else if(tableView == self.tableView2){
        if (_dataArray2.count != 0) {
            cell2.model = _dataArray2[indexPath.row];
            return cell2;
        }
        
    }else if(tableView == self.tableView3){
        if (_dataArray3.count != 0) {
            cell3.model = _dataArray3[indexPath.row];
            return cell3;
        }
        
    }else if(tableView == self.tableView4){
        if (_dataArray4.count != 0) {
            cell4.model = _dataArray4[indexPath.row];
            return cell4;
        }
        
    }else if (tableView == self.salerTableView){
        YeWuYuanModel *model = _salerArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if (tableView == self.custTableView){
        KHnameModel * model = _custArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    
    return cell1;
}
//点击单元格的跳转方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        JDXJDetailView *JDXJVC = [[JDXJDetailView alloc] init];
        if (_dataArray1.count != 0) {
            JDXJModel *model = _dataArray1[indexPath.row];
            JDXJVC.model = model;
        }
       
        [self.navigationController pushViewController:JDXJVC animated:YES];
    }else if(tableView == self.tableView2){
        YYZJDetailView *YYZJVC = [[YYZJDetailView alloc] init];
        if (_dataArray2.count != 0) {
            YYZJModel *model = _dataArray2[indexPath.row];
            YYZJVC.model = model;
        }
        
        [self.navigationController pushViewController:YYZJVC animated:YES];
    }else if(tableView == self.tableView3){
        SHHFDetailView *SHHFVC = [[SHHFDetailView alloc] init];
        if (_dataArray3.count != 0) {
            SHHFMOdel *model = _dataArray3[indexPath.row];
            SHHFVC.model = model;
        }
       
        [self .navigationController pushViewController:SHHFVC animated:YES];
    }else if(tableView == self.tableView4){
        WXGLDetailView *WXGLVC = [[WXGLDetailView alloc] init];
        if (_dataArray4.count != 0) {
            WXGLModel *model = _dataArray4[indexPath.row];
            WXGLVC.model = model;
        }
        
        [self.navigationController pushViewController:WXGLVC animated:YES];
    }else if (tableView == self.salerTableView){
        YeWuYuanModel *model = _salerArray[indexPath.row];
        [_salerButton setTitle:model.name forState:UIControlStateNormal];
        _salerButton.userInteractionEnabled = YES;
        [_listBackView removeFromSuperview];
    }else if (tableView == self.custTableView){
        KHnameModel * model = _custArray[indexPath.row];
        [_custButton setTitle:model.name forState:UIControlStateNormal];
        _custButton.userInteractionEnabled = YES;
        [_listBackView removeFromSuperview];
    }
    
    
    

}
- (void)AddAction:(UIButton *)button{
    if (_currentBtn.tag == 0) {
        JDXJAddView *JDXJAdd = [[JDXJAddView alloc] init];
        [self.navigationController pushViewController:JDXJAdd animated:YES];
    }else if(_currentBtn.tag == 1){
        YYZJAddView *YYZJAdd = [[YYZJAddView alloc] init];
        [self.navigationController pushViewController:YYZJAdd animated:YES];

    }else if(_currentBtn.tag == 2){
        SHHFAddView *SHHFAdd = [[SHHFAddView alloc] init];
        [self.navigationController pushViewController:SHHFAdd animated:YES];

    }else if(_currentBtn.tag == 3){
        WXGLAddView *WXGLAdd = [[WXGLAddView alloc] init];
        [self.navigationController pushViewController:WXGLAdd animated:YES];

    }

}
@end
