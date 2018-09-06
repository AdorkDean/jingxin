//
//  CPLiulanViewController.m
//  YiRuanTong
//
//  Created by lx on 15/5/26.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "CPLiulanViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "CPLLmodel.h"
#import "CPINfoModel.h"
#import "CPLiulanCell.h"
#import "UIImageView+WebCache.h"
#import "TupianLiulanViewController.h"
#import "DataPost.h"
#import "CpDetailVC.h"
#import "UIViewExt.h"
#import "CPInfoCell.h"
#import "CPLiulanSearchVC.h"
@interface CPLiulanViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIRefreshControl *_refreshControl;
//    UIRefreshControl *_refreshControl1;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSString *_proid;
    NSMutableArray *_imageArray;
    NSMutableArray *_dataArray1;
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    UIButton *_proButton;
    NSInteger _page1;
    NSInteger _page2;
    UITextField *_proField;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSMutableArray* _searchImageArray;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _propage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@end

@implementation CPLiulanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"产品浏览";
    _dataArray = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc]init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchPage = 1;
    _searchFlag = 0;
    _page = 1;
    _page1 = 1;
    _page2 = 1;
    _propage = 1;
    self.navigationItem.rightBarButtonItem = nil;
    [self showBarWithName:@"搜索" addBarWithName:nil];
    [self initTableView];
    

//    [self searchView];
    NSString * roleid = [[NSUserDefaults standardUserDefaults]objectForKey:@"roleid"];
    if ([roleid integerValue] == 140) {
        [self requesDataForAichong];
    }else{
        [self DataRequest];
    }
    
    
}
////手势方法
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)swipeAction{
//    _searchView.hidden = NO;
//    _backView.hidden = NO;
//    
//}
#pragma mark - 页面设置
- (void)initTableView{
    
    self.kuCunTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    self.kuCunTableView.delegate = self;
    self.kuCunTableView.dataSource = self;
    self.kuCunTableView.rowHeight = 90;
    self.kuCunTableView.tag = 10;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.kuCunTableView addSubview:_refreshControl];
    [self.view addSubview:_kuCunTableView];
    //     下拉刷新
    _kuCunTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_kuCunTableView.mj_header endRefreshing];
        
    }];
    NSString * roleid = [[NSUserDefaults standardUserDefaults]objectForKey:@"roleid"];
    if ([roleid integerValue] == 140) {
        
    }else{
        // 上拉刷新
        _kuCunTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
            [self upRefresh];
            [_kuCunTableView.mj_footer endRefreshing];
        }];
    }
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _kuCunTableView.mj_header.automaticallyChangeAlpha = YES;
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
//    swipe.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.kuCunTableView addGestureRecognizer:swipe];
    
}
//#pragma mark - 搜索页面
//- (void)searchView{
//
//    [_proButton setTitle:@" " forState:UIControlStateNormal];
//    _barHideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _barHideBtn.frame = CGRectMake(0, 0, KscreenWidth, 64);
//    _barHideBtn.backgroundColor = [UIColor clearColor];
//    _barHideBtn.hidden = YES;
//    [_barHideBtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
//    [[UIApplication sharedApplication].keyWindow addSubview:_barHideBtn];
//    //右侧模糊视图
//    _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 0, KscreenWidth/3, KscreenHeight -64)];
//    _backView.backgroundColor = [UIColor lightGrayColor];
//    _backView.alpha = .6;
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
//    singleTap.numberOfTouchesRequired = 1;
//    [ _backView addGestureRecognizer:singleTap];
//    [self.view addSubview:_backView];
//    _backView.hidden = YES;
//    //信息视图
//    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3*2, KscreenHeight - 64)];
//    _searchView.backgroundColor = [UIColor whiteColor];
//    //
//    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
//    Label1.text = @"产品名称";
//    Label1.backgroundColor = COLOR(231, 231, 231, 1);
//    Label1.font = [UIFont systemFontOfSize:15.0];
//    Label1.textAlignment = NSTextAlignmentCenter;
//    _proButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _proButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
//    [_proButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_proButton addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
//    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
//    nameView.backgroundColor = [UIColor grayColor];
//    [_searchView addSubview:Label1];
//    [_searchView addSubview:_proButton];
//    [_searchView addSubview:nameView];
//    //
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    searchBtn.backgroundColor = [UIColor lightGrayColor];
//    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    searchBtn.frame = CGRectMake(20, 40 +30, 60, 30);
//    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
//    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
//    [chongZhi setBackgroundColor:[UIColor lightGrayColor]];
//    [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    chongZhi.frame = CGRectMake(120, 40 + 30, 60, 30);
//    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
//    UIView *fenGenXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 40)];
//    fenGenXian.backgroundColor = [UIColor grayColor];
//    [_searchView addSubview:fenGenXian];
//
//    [_searchView addSubview:searchBtn];
//    [_searchView addSubview:chongZhi];
//    [self.view  addSubview:_searchView];
//    _searchView.hidden = YES;
//
//}
//#pragma mark -搜索页面方法
//- (void)singleTapAction{
//    _backView.hidden = YES;
//    _searchView.hidden = YES;
//    _barHideBtn.hidden = YES;
//}
//- (void)proAction
//{
//        self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
////        self.m_keHuPopView.backgroundColor = [UIColor grayColor];
//    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    //
//    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
//    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
//    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
//    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
//    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
//    //
//    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
//    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.layer.masksToBounds = YES;
//    bgView.layer.cornerRadius = 5;
//    [self.m_keHuPopView addSubview:bgView];
//    //
////    _proField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40,KscreenWidth - 80 , 40)];
//    _proField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
//    _proField.backgroundColor = [UIColor whiteColor];
//    _proField.delegate = self;
//    _proField.placeholder = @"名称关键字";
////    _proField.borderStyle = UITextBorderStyleBezel;
//    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_proField.height-1,_proField.width, 1)];
//    line2.backgroundColor=[UIColor lightGrayColor];
//    [_proField addSubview:line2];
//    _proField.font = [UIFont systemFontOfSize:13];
////    [self.m_keHuPopView addSubview:_proField];
//    [bgView addSubview:_proField];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    btn.frame = CGRectMake(_proField.right, _proField.top, 60, _proField.height);
//    [btn.layer setBorderWidth:0.5]; //边框宽度
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 5;
//    [btn addTarget:self action:@selector(searchpro) forControlEvents:UIControlEventTouchUpInside];//getPro
////    [self.m_keHuPopView addSubview:btn];
//    [bgView addSubview:btn];

//    if (self.proTableView == nil) {
////        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,KscreenWidth-20, KscreenHeight-174) style:UITableViewStylePlain];
//        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _proField.bottom+5,bgView.width-40, bgView.height - _proField.bottom - 5) style:UITableViewStylePlain];
//        self.proTableView.backgroundColor = [UIColor whiteColor];
//    }
//    self.proTableView.dataSource = self;
//    self.proTableView.delegate = self;
//    self.proTableView.tag = 50;
//    self.proTableView.rowHeight = 80;
//    [bgView addSubview:self.proTableView];
////    [self.m_keHuPopView addSubview:self.proTableView];
////        [self.view addSubview:self.m_keHuPopView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
////        if (_dataArray1.count == 0) {
////            [self getCPInfo];
////        }
//    //     下拉刷新
//    self.proTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _propage = 1;
//        [self searchpro];
//        // 结束刷新
//        [self.proTableView.mj_header endRefreshing];
//
//    }];
//
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.proTableView.mj_header.automaticallyChangeAlpha = YES;
//    // 上拉刷新
//    self.proTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        _propage ++ ;
//        [self searchpro];
//        [self.proTableView.mj_footer endRefreshing];
//
//    }];
//    _propage = 1;
//    [self searchpro];

//
//}
////产品名称搜索方法
//- (void)getPro{
//
//    /*
//     /product
//     action=fuzzyQuery
//
//     params= {"pronameLIKE":"sdfsdfs","custid":"111"}
//
//     */
//
//
//        NSString *proName = _proField.text;
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
//        NSDictionary *params = @{@"action":@"fuzzyQuery",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\",\"custid\":\"\"}",proName]};
//        NSLog(@"上传数组%@",params);
//        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//
//            NSLog(@"产品信息搜索返回:%@",dic);
//            [_dataArray1 removeAllObjects];
//            for (NSDictionary *dic1 in dic) {
//                CPINfoModel *model = [[CPINfoModel alloc] init];
//                [model setValuesForKeysWithDictionary:dic1];
//                [_dataArray1 addObject:model];
//            }
//            [self.proTableView reloadData];
//
//
//        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//            NSInteger errorCode = error.code;
//            NSLog(@"错误信息%@",error);
//            if (errorCode == 3840 ) {
//                NSLog(@"自动登录");
//                [self selfLogin];
//            }else{
//
//                //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
//            }
//
//        }];
//
//
//
//
//}
//
//- (void)getCPInfo
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
//    NSDictionary *params = @{@"action":@"fuzzyQuery",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page2],@"rows":@"20",@"table":@"cpxx",@"params":@"{\"proname\":\"\",\"custid\":\"\"}"};
//    if (_page2 == 1) {
//        [_dataArray1 removeAllObjects];
//    }
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSArray *array = dic[@"rows"];
//        NSLog(@"产品信息返回:%@",array);
//        for (NSDictionary *dic in array) {
//            CPINfoModel *model = [[CPINfoModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray1 addObject:model];
//        }
//        [self.proTableView reloadData];
//
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSInteger errorCode = error.code;
//        NSLog(@"错误信息%@",error);
//        if (errorCode == 3840 ) {
//            NSLog(@"自动登录");
//            [self selfLogin];
//        }else{
//
//                //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
//        }
//
//    }];
//}
//- (void)searchpro{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
//    NSString *proName = _proField.text;
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
//    NSDictionary *params = @{@"action":@"fuzzyQuery",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"table":@"cpxx",@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\"}",proName]};
//    if (_propage == 1) {
//        [_dataArray1 removeAllObjects];
//    }
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        if([[dic allKeys] containsObject:@"rows"])
//
//        {
//            NSArray *array = dic[@"rows"];
//            NSLog(@"新的产品接口%@",array);
//            if (array.count!=0) {
//                for (NSDictionary *dic in array) {
//                    CPINfoModel *model = [[CPINfoModel alloc] init];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [_dataArray1 addObject:model];
//                }
//                [self.proTableView reloadData];
//            }
//
//        }
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"加载失败");
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    }];
//
//}

//- (void)closePop{
//    if ([self keyboardDid]) {
//        [_proField resignFirstResponder];
//
//    }else{
//        [self.proTableView removeFromSuperview];
//        [self.m_keHuPopView removeFromSuperview];
//    }
//
//}
#pragma mark - 搜索产品名称方法
//- (void)CPInfoRequest
//{   /*
//        salepolicy
//        action:"getProComBox"
//     params:""
//     */
//    //产品名称－－的接口
//    NSString *strAdress = @"/salepolicy";
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
//    NSURL *url =[NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str =[NSString stringWithFormat:@"action=getProComBox&page=%zi&rows=20",_page2];
//    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
//        NSArray *array = dic[@"rows"];
//        NSLog(@"产品信息返回:%@",array);
//        for (NSDictionary *dic in array) {
//            CPINfoModel *model = [[CPINfoModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray1 addObject:model];
//        }
//        
//    }else{
//        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [tan show];
//    }
//    
//}
//- (void)refreshData1
//{
//    //开始刷新
//    _refreshControl1.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
//    [_refreshControl1 beginRefreshing];
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown1) userInfo:nil repeats:NO];
//}
//
//- (void)refreshDown1
//{
//    [_dataArray1 removeAllObjects];
//
//    _page2 = 1;
//    [self CPInfoRequest];
//    [_refreshControl1 endRefreshing];
//}

//- (void)upRefresh1
//{
//    [_HUD show:YES];
//    _page2++;
//    [self getCPInfo];
//}

//搜索方法
//- (void)search
//{
//    [self searchData];
//}
- (void)search
{
    
}

- (void)searchDataWithProid:(NSString *)proid StartTime:(NSString *)start EndTime:(NSString *)end ProName:(NSString *)proname
{
    NSString *pro = proname;
    pro = [self convertNull:proname];
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
        [_searchImageArray removeAllObjects];
    }
    if ([pro isEqualToString:@""]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/product"];
//    NSDictionary *params = @{@"action":@"getBeans",@"view":@"cpstview",@"page":[NSString stringWithFormat:@"%ld",(long)_searchPage],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"table\":\"cpxx\",\"pronameLIKE\":\"%@\",\"pronoEQ\":\"\",\"helpnoLIKE\":\"\",\"mainunitEQ\":\"\",\"protypeidEQ\":\"\",\"secondunitEQ\":\"\",\"maintozeroEQ\":\"\",\"fractionunitEQ\":\"\",\"recommendEQ\":\"\",\"isvalidEQ\":\"1\"}",pro]};
    NSDictionary *params = @{@"action":@"getImagesList",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"params":[NSString stringWithFormat:@"{\"pronameLIKE\":\"%@\"}",pro]};
    //    NSDictionary *params = @{@"action":@"getImagesList",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"params":[NSString stringWithFormat:@"\"pronameLIKE\":\"%@\"",proName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"rows"];
            for (NSDictionary *dic in array) {
                CPLLmodel *model = [[CPLLmodel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_searchDateArray addObject:model];
                [_imageArray addObject:dic];
            }
            [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        
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

-(void)requesDataForAichong{
    //HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText =  @"网络不给力,正在加载中...";
    [_HUD show:YES];
    //数据接口拼接
    /*
     product
     action:"getImagesList"
     
     page:"1"
     rows:"10"
     
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/product?action=getImagesList"];
    
    NSDictionary *params = @{@"action":@"getImagesList"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
//            NSArray *array = dic[@"rows"];
            NSLog(@"产品浏览列表:%@",array);
            for (NSDictionary *dic in array) {
                NSString * proname = [NSString stringWithFormat:@"%@",dic[@"proname"]];
                if ([[proname substringToIndex:1] isEqualToString:@"H"]) {
                    CPLLmodel *model = [[CPLLmodel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                    [_imageArray addObject:dic];
                }
            }
            [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
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
#pragma mark - 浏览数据
- (void)DataRequest
{
    
    //HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText =  @"网络不给力,正在加载中...";
    [_HUD show:YES];
    //数据接口拼接
    /*
     product
     action:"getImagesList"
    
     page:"1"
     rows:"10"
     
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/product?action=getImagesList"];
    NSDictionary *params = @{@"action":@"getImagesList",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"params":[NSString stringWithFormat:@"{\"pronameLIKE\":\"%@\"}",@""]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        
        NSLog(@"产品浏览列表:%@",array);
        for (NSDictionary *dic in array) {
            CPLLmodel *model = [[CPLLmodel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
            [_imageArray addObject:dic];
            
        }
        [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
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
        [_searchImageArray removeAllObjects];
        _searchPage = 1;
        [_refreshControl endRefreshing];

    }else{
        [_dataArray removeAllObjects];
        [_imageArray removeAllObjects];
        _page = 1;
        NSString * roleid = [[NSUserDefaults standardUserDefaults]objectForKey:@"roleid"];
        if ([roleid integerValue] == 140) {
            [self requesDataForAichong];
        }else{
            [self DataRequest];
        }
        [_refreshControl endRefreshing];
    }
}

- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//            [self upRefresh];
        }
    }else if(scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//            [self upRefresh1];
        }
    }
   
}

#pragma mark UITableViewDelegateAndDataSource

//返回每个section上cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.kuCunTableView){
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray.count;
        }
    }else if(tableView == self.proTableView){
        return _dataArray1.count;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell_1";
    CPLiulanCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (CPLiulanCell *)[[[NSBundle mainBundle]loadNibNamed:@"CPLiulanCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CPInfoCell *cell2 =  [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell2 == nil) {
        cell2 = (CPInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"CPInfoCell" owner:self options:nil]firstObject];
        cell2.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    
    if (tableView == self.kuCunTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                CPLLmodel *model = [_searchDateArray objectAtIndex:indexPath.row];
                cell.name.text = model.proname;
                cell.guige.text = model.specification;
                cell.danjia.text = [NSString stringWithFormat:@"%@",model.saleprice];
                NSString *str  = model.pathlist;
                if (str.length!=0) {
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *imageDic = arr[0];
                    NSString *str1 = [imageDic objectForKey:@"imgpath"];
                    NSString *imageStr = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,str1];
                    NSURL *url = [NSURL URLWithString:imageStr];
                    
                    [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zwtp.png"]];
                    cell.imgView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    cell.imgView.tag = indexPath.row;
                    [cell.imgView addGestureRecognizer:tap];
                }
                return cell;
            }
        }else{
            if (_dataArray.count != 0) {
                CPLLmodel *model = [_dataArray objectAtIndex:indexPath.row];
                cell.name.text = model.proname;
                cell.guige.text = model.specification;
                cell.danjia.text = [NSString stringWithFormat:@"%@",model.saleprice];
                NSDictionary *dic = _imageArray[indexPath.row];
                NSString *str  = (NSString *)[dic objectForKey:@"pathlist"];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *imageDic = arr[0];
                NSString *str1 = [imageDic objectForKey:@"imgpath"];
                NSString *imageStr = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,str1];
                NSURL *url = [NSURL URLWithString:imageStr];
                
                [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zwtp.png"]];
                cell.imgView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                cell.imgView.tag = indexPath.row;
                [cell.imgView addGestureRecognizer:tap];
                return cell;
            }
        }
    }else if(tableView == self.proTableView){
        if (_dataArray1.count != 0) {
            cell2.model = _dataArray1[indexPath.row];
        }
        
        return cell2;
    }
    return cell;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_searchFlag == 1) {

    }else{
        TupianLiulanViewController *photo = [[TupianLiulanViewController alloc] init];
        photo.dataDic = _imageArray[tap.view.tag];
        [self.navigationController pushViewController:photo animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.kuCunTableView ){
        if (_searchFlag == 1) {
            CPLLmodel *model= _searchDateArray[indexPath.row];
            CpDetailVC *detail = [[CpDetailVC alloc] init];
            //NSDictionary *dic = _imageArray[indexPath.row];
            //tp.dataDic = dic;
            detail.ProId = model.proname;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            CPLLmodel *model= _dataArray[indexPath.row];
            CpDetailVC *detail = [[CpDetailVC alloc] init];
            //NSDictionary *dic = _imageArray[indexPath.row];
            //tp.dataDic = dic;
            detail.ProId = model.proname;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else if(tableView == self.proTableView){
        if (_dataArray1.count!=0) {
            CPINfoModel *model = _dataArray1[indexPath.row];
            [_proButton setTitle:model.proname forState:UIControlStateNormal];
        }
        [self.m_keHuPopView removeFromSuperview];

    }
}


- (void)searchAction{
    NSLog(@"11");
    
}

- (void)addNext{
    [_searchDateArray removeAllObjects];
    CPLiulanSearchVC * vc = [[CPLiulanSearchVC alloc]init];
    [vc setBlock:^(NSString *proid,NSString *proname, NSString *start, NSString *end) {
        [self searchDataWithProid:proid StartTime:start EndTime:end ProName:proname];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
