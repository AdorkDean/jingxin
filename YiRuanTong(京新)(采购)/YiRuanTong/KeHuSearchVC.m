//
//  KeHuSearchVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "KeHuSearchVC.h"
#import "KeHuViewController.h"
#import "MainViewController.h"
#import "KeHuGuanLiCell.h"
#import "KeHuManagerCell.h"
#import "AddKeHuVC.h"
#import "KeHuXinXiVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "BaiFangShangBaoVC.h"
#import "MBProgressHUD.h"
//#import "BMapKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "ZhaoPianShangChuanVC.h"
#import "KHmanageModel.h"
#import "KHnameModel.h"
#import "YeWuYuanModel.h"
#import "ProvinceModel.h"
#import "Reachability.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CommonModel.h"
@interface KeHuSearchVC ()<BMKLocationServiceDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl3;
    MBProgressHUD *_HUD;
    BMKLocationService *_locService;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSInteger _page;
    NSInteger _page1;
    NSInteger _page2;
    NSString *_KHid;
    MBProgressHUD *_hud;
    UIView *_searchView;
    UIView *_backView;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    
    UIButton *_custButton;
    UIButton *_salerButton;
    UIButton *_areaButton;
    UIButton *_typeButton;
    UIButton *_classButton;
    UIButton *_tracelevelButton;
    UIButton *_province;//省
    UIButton *_city;//市
    UIButton *_county;//县
    NSString *_provinceId;
    NSString *_cityId;
    NSString *_countyId;
    
    UITextField *_custField;
    UITextField *_salerField;
    NSMutableArray *_areaArray;
    NSMutableArray *_statusArray;
    NSString *_custId;
    NSString *_accountId;
    NSString *_classId;
    NSString *_tracelevelId;
    
    
    NSIndexPath *_selectRow;
    UIButton* _barHideBtn;
    UIButton *_hide_keHuPopViewBut;
    NSInteger _custpage;
    NSInteger _salerpage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *areaTableView;
@property(nonatomic,retain)UITableView *typeTableView;
@property(nonatomic,retain)UITableView *classTableView;
@property(nonatomic,retain)UITableView *tracelevelTableView;
@property (strong, nonatomic) UITableView * provincetableView;
@property (strong, nonatomic) UITableView * citytableView;
@property (strong, nonatomic) UITableView * countytableView;
@property(nonatomic,retain)NSMutableArray *keHuFenLeiArr;

@property(nonatomic,retain)NSMutableArray *keHuXingZhiArr;
@end

@implementation KeHuSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    
    _page = 1;
    _page1 = 1;
    _page2 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _custpage = 1;
    _salerpage = 1;
    
    [self createUIview];
}
- (void)createUIview{
    //客户名称
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    Label1.text = @"客户名称";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    
    _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _custButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
    [_custButton setTintColor:UIColorFromRGB(0x999999)];
    [_custButton setTitle:@"请选择客户" forState:UIControlStateNormal];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*MYWIDTH, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label1];
    [self.view addSubview:_custButton];
    [self.view addSubview:nameView];
    //负责人
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label4.text = @"负责人";
    Label4.backgroundColor = COLOR(231, 231, 231, 1);
    Label4.font = [UIFont systemFontOfSize:15.0];
    Label4.textAlignment = NSTextAlignmentCenter;
    
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, Label1.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton addTarget:self action:@selector(fuzerenAction) forControlEvents:UIControlEventTouchUpInside];
    [_salerButton setTintColor:UIColorFromRGB(0x999999)];
    [_salerButton setTitle:@"请选择负责人" forState:UIControlStateNormal];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label4];
    [self.view addSubview:_salerButton];
    [self.view addSubview:view4];
    //
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label4.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label2.text = @"客服分类";
    Label2.backgroundColor = COLOR(231, 231, 231, 1);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _typeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _typeButton.frame = CGRectMake(KscreenWidth/3, Label4.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_typeButton addTarget:self action:@selector(feileiAction) forControlEvents:UIControlEventTouchUpInside];
    [_typeButton setTintColor:UIColorFromRGB(0x999999)];
    [_typeButton setTitle:@"请选择客户分类" forState:UIControlStateNormal];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, Label2.bottom , KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label2];
    [self.view addSubview:_typeButton];
    [self.view addSubview:typeView];
    //
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label2.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label3.text = @"客户状态";
    Label3.backgroundColor = COLOR(231, 231, 231, 1);
    Label3.font = [UIFont systemFontOfSize:15.0];
    Label3.textAlignment = NSTextAlignmentCenter;
    _tracelevelButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _tracelevelButton.frame = CGRectMake(KscreenWidth/3, Label2.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_tracelevelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_tracelevelButton setTitle:@"请选择客户状态" forState:UIControlStateNormal];
    [_tracelevelButton addTarget:self action:@selector(zhuangtaiAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *tracelevelView = [[UIView alloc] initWithFrame:CGRectMake(0, Label3.bottom, KscreenWidth, 1)];
    tracelevelView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label3];
    [self.view addSubview:_tracelevelButton];
    [self.view addSubview:tracelevelView];
    
    //省
    UILabel *Label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label3.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label5.text = @"省";
    Label5.backgroundColor = COLOR(231, 231, 231, 1);
    Label5.font = [UIFont systemFontOfSize:15.0];
    Label5.textAlignment = NSTextAlignmentCenter;
    _province = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _province.frame = CGRectMake(KscreenWidth/3, Label3.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_province setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_province setTitle:@"请选择省" forState:UIControlStateNormal];
    [_province addTarget:self action:@selector(provinceAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *provincelView = [[UIView alloc] initWithFrame:CGRectMake(0, Label5.bottom, KscreenWidth, 1)];
    provincelView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label5];
    [self.view addSubview:_province];
    [self.view addSubview:provincelView];
    
    //市
    UILabel *Label6 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label5.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label6.text = @"市";
    Label6.backgroundColor = COLOR(231, 231, 231, 1);
    Label6.font = [UIFont systemFontOfSize:15.0];
    Label6.textAlignment = NSTextAlignmentCenter;
    _city = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _city.frame = CGRectMake(KscreenWidth/3, Label5.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_city setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_city setTitle:@"请选择市" forState:UIControlStateNormal];
    [_city addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *citylView = [[UIView alloc] initWithFrame:CGRectMake(0, Label6.bottom, KscreenWidth, 1)];
    citylView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label6];
    [self.view addSubview:_city];
    [self.view addSubview:citylView];
    
    
    //县
    UILabel *Label7 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label6.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label7.text = @"县";
    Label7.backgroundColor = COLOR(231, 231, 231, 1);
    Label7.font = [UIFont systemFontOfSize:15.0];
    Label7.textAlignment = NSTextAlignmentCenter;
    _county = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _county.frame = CGRectMake(KscreenWidth/3, Label6.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_county setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_county setTitle:@"请选择县" forState:UIControlStateNormal];
    [_county addTarget:self action:@selector(countyAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *countylView = [[UIView alloc] initWithFrame:CGRectMake(0, Label7.bottom, KscreenWidth, 1)];
    countylView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label7];
    [self.view addSubview:_county];
    [self.view addSubview:countylView];
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, _county.bottom)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:fenGeXian];
    //
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, countylView.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, countylView.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)custAction{
    
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
    
    if (self.custTableView == nil) {
        //        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 30;
    self.custTableView.rowHeight = 45;
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
//下拉刷新
- (void)refreshData3
{
    //开始刷新
    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl3 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown3) userInfo:nil repeats:NO];
}
- (void)refreshDown3
{
    [_dataArray removeAllObjects];
    _page1 = 1;
    [self nameRequest];
    [_refreshControl3 endRefreshing];
}
//上拉加载更多
- (void)upRefresh3
{
    _page1++;
    [self nameRequest];
}

- (void)getName{
    
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray1 removeAllObjects];
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
        }
        [self.custTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
}


- (void)nameRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page1],@"action":@"getSelectName",@"table":@"khxx"};
    if (_page1 == 1) {
        [_dataArray1 removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户数据%@",dic);
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
        }
        [self.custTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户名称加载失败");
    }];
    
    
}

- (void)searchcust{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"table":@"khxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_custpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    if (_custpage == 1) {
        [_dataArray1 removeAllObjects];
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
                    [_dataArray1 addObject:model];
                }
                [self.custTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [hud hide:YES];
        NSLog(@"业务员加载失败");
        [hud removeFromSuperview];
    }];
}
#pragma mark -  saler
- (void)fuzerenAction{
    
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];//- 64
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
        //  NSLog(@"业务员数据%@",array);
        _dataArray2 = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray2 addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
    }];
    
    
}
- (void)salerRequest{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        //    NSLog(@"业务员数据%@",array);
        _dataArray2 = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray2 addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
    }];
    
    
}

- (void)searchsaler{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_salerpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    if (_salerpage == 1) {
        [_dataArray2 removeAllObjects];
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
                    YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray2 addObject:model];
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
- (void)feileiAction{
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
    [self typeRequest];
    [self.typeTableView reloadData];
}
- (void)typeRequest
{
    //sysbase?action=getTree&table=cate&catetype=customerclassify
    
    //NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/syscate"];
    //NSDictionary *params = @{@"action":@"getSelectForMobile",@"params":@"{\"type\":\"customerclassify\"}"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSDictionary *params = @{@"action":@"getTree",@"table":@"cate",@"catetype":@"customerclassify"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        _keHuFenLeiArr = [NSMutableArray array];
        
        NSLog(@">>>>%@",[array[0] objectForKey:@"children"]);
        for (NSDictionary *dic in [array[0] objectForKey:@"children"]) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_keHuFenLeiArr addObject:model];
        }
        [self.typeTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}
- (void)zhuangtaiAction{
    
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
        [self.tracelevelTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}
#pragma mark - 省、市、县数据的方法
- (void)provinceAction{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.provincetableView == nil) {
        self.provincetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.provincetableView.backgroundColor = [UIColor whiteColor];
    }
    self.provincetableView.dataSource = self;
    self.provincetableView.delegate = self;
    [bgView addSubview:self.provincetableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self suozaishengRequest];
    [self.provincetableView reloadData];
}
- (void)cityAction{
    //市
    if ([_provinceId isEqualToString:@""]) {
        _city.userInteractionEnabled = NO;
    }
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.citytableView == nil) {
        self.citytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.citytableView.backgroundColor = [UIColor whiteColor];
    }
    self.citytableView.dataSource = self;
    self.citytableView.delegate = self;
    [bgView addSubview:self.citytableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self suozaishiRequest];
    [self.citytableView reloadData];
}
- (void)countyAction{
    //县
    if ([_cityId isEqualToString:@""]) {
        _county.userInteractionEnabled = NO;
    }
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.countytableView == nil) {
        self.countytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.countytableView.backgroundColor = [UIColor whiteColor];
    }
    self.countytableView.dataSource = self;
    self.countytableView.delegate = self;
    [bgView addSubview:self.countytableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self suozaixianRequest];
    [self.countytableView reloadData];
}
- (void)suozaishengRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =@"action=getProvince&params={\"newinfo\":\"true\"}&table=xzqy";
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        self.shengArr = [NSMutableArray array];
        for (NSDictionary *dic  in array) {
            ProvinceModel *model = [[ProvinceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.shengArr addObject:model];
        }
        
    }
    
    
}

- (void)suozaishiRequest
{
    if (_provinceId != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
        NSURL *url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCity&params={\"newinfo\":\"true\"}&table=xzqy",_provinceId];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            self.shiArr = [NSMutableArray array];
            
            for (NSDictionary *dic  in array ) {
                ProvinceModel *model  =  [[ProvinceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.shiArr addObject:model];
            }
        }
    }
}
- (void)suozaixianRequest
{
    if (_cityId != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCounties&params={\"newinfo\":\"true\"}&table=xzqy",_cityId];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(data1 != nil){
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            
            self.xianArr = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                ProvinceModel *model = [[ProvinceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.xianArr addObject:model];
            }
        }
        
    }
    
    
}

- (void)chongZhi{
    
    [_custButton setTitle:@""forState:UIControlStateNormal];
    _custId = @"";
    [_salerButton setTitle:@""forState:UIControlStateNormal];
    _accountId = @"";
    [_areaButton setTitle:@""forState:UIControlStateNormal];
    [_typeButton setTitle:@""forState:UIControlStateNormal];
    
    [_classButton setTitle:@""forState:UIControlStateNormal];
    _classId = @"";
    [_tracelevelButton setTitle:@""forState:UIControlStateNormal];
    _tracelevelId = @"";
 
    [_province setTitle:@""forState:UIControlStateNormal];
    _provinceId = @"";
    [_city setTitle:@""forState:UIControlStateNormal];
    _cityId = @"";
    [_county setTitle:@""forState:UIControlStateNormal];
    _countyId = @"";
}

#pragma mark UITableViewDelegataAndDataSource协议方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.custTableView){
        return _dataArray1.count;
    }else if(tableView == self.salerTableView){
        return _dataArray2.count;
    }else if(tableView == self.areaTableView){
        return _areaArray.count;
    }else if(tableView == self.typeTableView){
        return _keHuFenLeiArr.count;
    }else if(tableView == self.classTableView){
        return _keHuXingZhiArr.count;
    }else if(tableView == self.tracelevelTableView){
        return _statusArray.count;
    }else if(tableView == self.provincetableView){
        return self.shengArr.count;
    }else if(tableView == self.citytableView){
        return self.shiArr.count;
    }else{
        return self.xianArr.count;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"cell_ident";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
    }
   if(tableView == self.custTableView){
        if (_dataArray1.count!=0) {
            KHnameModel *model = _dataArray1[indexPath.section];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }else if(tableView == self.salerTableView){
        if (_dataArray2.count!=0) {
            YeWuYuanModel *model = _dataArray2[indexPath.section];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }else if(tableView == self.areaTableView){
        CommonModel *model = _areaArray[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.typeTableView){
        CommonModel *model = _keHuFenLeiArr[indexPath.section];
        cell1.textLabel.text = model.text;
        return cell1;
    }else if(tableView == self.classTableView){
        NSString *class = _keHuXingZhiArr[indexPath.section];
        cell1.textLabel.text = class;
        return cell1;
    }else if(tableView == self.tracelevelTableView){
        CommonModel *model = _statusArray[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.provincetableView){
        ProvinceModel *model = self.shengArr[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.citytableView){
        ProvinceModel *model = self.shiArr[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else{
        ProvinceModel *model = self.xianArr[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }
    
//    return cell;
}
//点击事件 点击进入客户信息页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.custTableView){
        if (_dataArray1.count!=0) {
            KHnameModel *model = _dataArray1[indexPath.section];
            [_custButton setTitle:model.name forState:UIControlStateNormal];
            _custButton.userInteractionEnabled = YES;
            _custId = model.Id;
        }
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.salerTableView){
        if (_dataArray2.count!=0) {
            YeWuYuanModel *model = _dataArray2[indexPath.section];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerButton.userInteractionEnabled = YES;
            _accountId = model.Id;
        }
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.areaTableView){
        CommonModel *model = _areaArray[indexPath.section];
        [_areaButton setTitle:model.name forState:UIControlStateNormal];
        _areaButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.typeTableView){
        CommonModel *model = _keHuFenLeiArr[indexPath.section];
        [_typeButton setTitle:model.text forState:UIControlStateNormal];
        _typeButton.userInteractionEnabled = YES;
        _classId = model.Id;
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.classTableView){
        NSString *class = _keHuXingZhiArr[indexPath.section];
        [_classButton setTitle:class forState:UIControlStateNormal];
        _classButton.userInteractionEnabled = YES;
        
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.tracelevelTableView){
        CommonModel *model = _statusArray[indexPath.section];
        [_tracelevelButton setTitle:model.name forState:UIControlStateNormal];
        _tracelevelButton.userInteractionEnabled = YES;
        _tracelevelId = model.Id;
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.provincetableView){
        ProvinceModel *model = self.shengArr[indexPath.section];
        [_province setTitle:model.name forState:UIControlStateNormal];
        _provinceId = [NSString stringWithFormat:@"%@",model.placeid];
        _city.userInteractionEnabled = YES;
        
        [_city setTitle:@"" forState:UIControlStateNormal];
        _cityId = @"";
        
        [_county setTitle:@"" forState:UIControlStateNormal];
        _countyId =  @"";
        [self.m_keHuPopView removeFromSuperview];
        
    }else if(tableView == self.citytableView){
        ProvinceModel *model = self.shiArr[indexPath.section];
        [_city setTitle:model.name forState:UIControlStateNormal];
        _cityId = [NSString stringWithFormat:@"%@",model.placeid];
        _county.userInteractionEnabled = YES;
        
        [_county setTitle:@"" forState:UIControlStateNormal];
        _countyId =  @"";
        [self.m_keHuPopView removeFromSuperview];
        
    }else if(tableView == self.countytableView){
        ProvinceModel *model = self.xianArr[indexPath.section];
        [_county setTitle:model.name forState:UIControlStateNormal];
        _countyId =  [NSString stringWithFormat:@"%@",model.placeid];
        [self.m_keHuPopView removeFromSuperview];
        
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.keHuTableView){
        return 180;
        
    }else{
        return 45;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}
- (void)closePop
{
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
        [_salerField resignFirstResponder];
        
    }else{
        _custButton.userInteractionEnabled = YES;
        _salerButton.userInteractionEnabled = YES;
        _typeButton.userInteractionEnabled = YES;
        _classButton.userInteractionEnabled = YES;
        _tracelevelButton.userInteractionEnabled = YES;
        _areaButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        [self.custTableView removeFromSuperview];
        [self.salerTableView removeFromSuperview];
        [self.typeTableView removeFromSuperview];
        [self.classTableView removeFromSuperview];
        [self.tracelevelTableView removeFromSuperview];
    }
    
}
- (void)search{
    //_custId,_accountId,_classId,_tracelevelId,_provinceId,_cityId,_countyId
    if (_block) {
        self.block(_custId,_accountId,_classId,_tracelevelId,_provinceId,_cityId,_countyId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
