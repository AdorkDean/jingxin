//
//  FYBaoXiaoListVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "FYBaoXiaoListVC.h"
#import "MBProgressHUD.h"
#import "FYModel.h"
#import "FYBaoXiaoLiuLanCell.h"
#import "AFNetworking.h"
#import "FYShenPiView.h"
#import "FYLiuLanView.h"
#import "FYBaoXiaoSearchVC.h"
#import "DataPost.h"
#import "CommonModel.h"
#import "UIViewExt.h"
#import "FYBXShangbaoVC.h"
#import "FYBaoXiaoDetailVC.h"
@interface FYBaoXiaoListVC ()<UITextFieldDelegate>

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _searchPage1;
    NSInteger _searchPage2;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray1;
    NSMutableArray* _searchDateArray2;
    
    UIButton *_currentBtn;
    UIButton *_liuLanButton;
    UIButton *_shenPiButton;
    NSMutableArray *_btnArray;
    NSArray *_classArray;
    UIButton* _hide_keHuPopViewBut;
    
    UILabel *_xiahuaxian;
    NSString *_custId;
    NSString *_salerID;
    NSString *_orederNo;
    NSString *_start;
    NSString *_end;
    NSString *_currentDateStr;
    NSString *_pastDateStr;
}
@property(nonatomic,retain)UITableView *classTableView;
@property (nonatomic,strong) UIView *m_keHuPopView;


@end

@implementation FYBaoXiaoListVC

- (void)viewWillAppear:(BOOL)animated{
    [self.liuLanTableView reloadData];
    
}
- (void)navigationSetRightButton{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(KscreenWidth - 90, 10, 40, 40);
    [searchButton setTitle:@"添加" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [button setTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(KscreenWidth - 50, 10, 40, 40);
    [button setImage:[UIImage imageNamed:@"rightBut"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    //将按钮数组放在navbar 上
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:right1,right, nil]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"费用报销";
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _btnArray = [[NSMutableArray alloc] init];
    _searchDateArray1 = [[NSMutableArray alloc]init];
    _searchDateArray2 = [[NSMutableArray alloc]init];
    _page1 = 1;
    _page2 = 1;
    _searchPage1 = 1;
    _searchPage2 = 1;
    _searchFlag = 0;
    
    
    [self navigationSetRightButton];
    [self PageViewDidLoad1];
    [self getDateStr];
    //数据加载
    [self DataRequest];
    [self DataRequest1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRefresh) name:@"newCostapply" object:nil];
    
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
- (void)searchData
{
    /*生产浏览列表接口
     http://192.168.1.199:8080/jingxin/servlet/production?action=getPlanBeans
     参数：{"table":"scjh","plannoLIKE":"","proidEQ":"","creatoridEQ":"","isvalidEQ":"1","plantimeGE":"","plantimeLE":""}
     */
    //进度HUD
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"网络不给力，正在加载中...";
    [hud show:YES];
    _orederNo = [self convertNull:_orederNo];
    _start = [self convertNull:_start];
    _end = [self convertNull:_end];
    _searchFlag = 1;
    if (_searchPage1 == 1) {
        [_searchDateArray1 removeAllObjects];
    }
    if (_searchPage2 == 1) {
        [_searchDateArray2 removeAllObjects];
    }
    NSString *urlStr;
    NSDictionary *params;
    if (_liuLanButton.selected == YES) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getReimBeans"];
        NSDictionary *params = @{@"action":@"getReimBeans",@"table":@"fybx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage1],@"params":[NSString stringWithFormat:@"{\"table\":\"fybx\",\"applyeridEQ\":\"%@\",\"applytimeGE\":\"%@\",\"applytimeLE\":\"%@\"}",_orederNo,_start,_end]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"搜索上传字符串%@",params);
            NSLog(@"搜索列表:%@",array);
            for (NSDictionary *dic in array) {
                FYModel *model = [[FYModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.Id = dic[@"id"];
                [_searchDateArray1 addObject:model];
            }
            [self.liuLanTableView reloadData];
            
            [hud hide:YES];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            [hud hide:YES];
            NSLog(@"搜索加载失败");
            NSInteger errorCode = error.code;
            NSLog(@"错误信息%@",error);
            if (errorCode == 3840 ) {
                NSLog(@"自动登录");
                [self selfLogin];
            }else{
                
                //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
            }
        }];
    }else{
        /*生产审批列表
         http://192.168.1.199:8080/jingxin/servlet/production?action=getSPBeans
         生产审批查询参数：{"table":"scjh","plannoLIKE":"","creatoridEQ":"","isspEQ":"0","plantimeGE":"","plantimeLE":""}
         */
        urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getReimSPBeans"];
        params = @{@"rows":@"10",@"page":[NSString stringWithFormat:@"%zi",_searchPage2],@"action":@"getReimSPBeans",@"table":@"fybx",@"params":[NSString stringWithFormat:@"{\"table\":\"fybx\",\"applyeridEQ\":\"%@\",\"isspEQ\":\"0\",\"applytimeGE\":\"%@\",\"applytimeLE\":\"%@\"}",_orederNo,_start,_end]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"搜索上传字符串%@",params);
            NSLog(@"搜索列表:%@",array);
            for (NSDictionary *dic in array) {
                FYModel *model = [[FYModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.Id = dic[@"id"];
                [_searchDateArray2 addObject:model];
            }
            [self.shenPiTableView reloadData];
            
            [hud hide:YES];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            [hud hide:YES];
            NSLog(@"搜索加载失败");
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
}


#pragma mark - 浏览列表审批列表数据请求
- (void)DataRequest
{
    /*
     */
    //进度HUD
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"网络不给力，正在加载中...";
    [hud show:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getReimBeans"];
    NSDictionary *params = @{@"rows":@"10",@"page":[NSString stringWithFormat:@"%zi",_page1],@"table":@"fybx",@"params":[NSString stringWithFormat:@"{\"table\":\"fybx\",\"applyeridEQ\":\"\",\"applytimeGE\":\"\",\"applytimeLE\":\"\"}"]};
    NSLog(@">>>>%@",urlStr);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page1 == 1) {
            [_dataArray1 removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (dic != nil) {
                NSArray *array = dic[@"rows"];
                NSLog(@"生产浏览列表:%@",dic);
                if (array.count != 0) {
                    for (NSDictionary *dic in array) {
                        FYModel *model = [[FYModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        model.Id = dic[@"id"];
                        [_dataArray1 addObject:model];
                    }
                    
                }
                [self.liuLanTableView reloadData];
            }
        }
        [hud hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [hud hide:YES];
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
    //进度HUD
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"网络不给力，正在加载中...";
    [hud show:YES];
    //自定义审批列表审批的接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getReimSPBeans"];
    NSDictionary *params = @{@"action":@"getReimSPBeans",@"table":@"fybx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page2],@"params":@"{\"table\":\"fybx\",\"applyeridEQ\":\"\",\"applytimeGE\":\"\",\"applytimeLE\":\"\",\"isspEQ\":\"0\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page2 == 1) {
            [_dataArray2 removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"生产审批列表:%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    FYModel *model = [[FYModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.Id = dic[@"id"];
                    [_dataArray2 addObject:model];
                }
                
            }
            [self.shenPiTableView reloadData];
        }
        [hud hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [hud hide:YES];
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

- (void)PageViewDidLoad1
{
    //标题下方的2个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 49)];
    //buttonView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, KscreenWidth, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:buttonView];
    [self.view addSubview:line];
    
    _xiahuaxian = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, KscreenWidth/2, 1)];
    _xiahuaxian.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.view addSubview:_xiahuaxian];
    
    //2个按钮的设置
    _liuLanButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth/2, 49)];
    [_liuLanButton setTitle:@"浏览" forState:UIControlStateNormal];
    _liuLanButton.tag = 0;
    _liuLanButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_liuLanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_liuLanButton setTitleColor:UIColorFromRGB(0x3cbaff) forState:UIControlStateSelected];
    _liuLanButton.backgroundColor = [UIColor whiteColor];
    
    [_liuLanButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _currentBtn = _liuLanButton;
    _currentBtn.selected = YES;
    [buttonView addSubview:_liuLanButton];
    [_btnArray addObject:_liuLanButton];
    
    _shenPiButton =[[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth/2,0 ,KscreenWidth/2,49)];
    [_shenPiButton setTitle:@"审批" forState:UIControlStateNormal];
    _shenPiButton.tag = 1;
    [_shenPiButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_shenPiButton setTitleColor:UIColorFromRGB(0x3cbaff) forState:UIControlStateSelected];
    
    [_shenPiButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _shenPiButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [buttonView addSubview:_shenPiButton];
    [_btnArray addObject:_shenPiButton];    //标题下方View的设置;
    //UIScrollerView
    self.mainScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114)];
    self.mainScrollView.contentSize =CGSizeMake(KscreenWidth *2, KscreenHeight-114);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    //scrollView上面的2个tableview实例化 并且添加到scrollView上去
    self.liuLanTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.liuLanTableView.delegate =self;
    self.liuLanTableView.dataSource =self;
    self.liuLanTableView.tag = 10;
    self.liuLanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScrollView addSubview:self.liuLanTableView];
    //     下拉刷新
    //    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    //    NSString * string = [pushJudge objectForKey:@"push"];
    //    if (![string isEqualToString:@"push"]) {
    self.liuLanTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.liuLanTableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.liuLanTableView.mj_header.automaticallyChangeAlpha = YES;
    self.liuLanTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [self.liuLanTableView.mj_footer endRefreshing];
    }];
    //    }else{
    //        self.liuLanTableView.scrollEnabled = NO;
    //    }
    self.shenPiTableView =[[UITableView alloc]initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.shenPiTableView.delegate = self;
    self.shenPiTableView.dataSource =self;
    self.shenPiTableView.tag = 20;
    self.shenPiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScrollView addSubview:self.shenPiTableView];
    //     下拉刷新
    //    if (![string isEqualToString:@"push"]) {
    self.liuLanTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.liuLanTableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.liuLanTableView.mj_header.automaticallyChangeAlpha = YES;
    self.liuLanTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [self.liuLanTableView.mj_footer endRefreshing];
    }];
    
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
    //    }else{
    //        self.liuLanTableView.scrollEnabled = NO;
    //    }
    
}

- (void)selectBtn:(UIButton *)btn
{
    
    if (btn != _currentBtn)
    {
        _currentBtn.selected = NO;
        _currentBtn = btn;
        [UIView animateWithDuration:0.3
                         animations:^{
                             //执行的动画
                             _xiahuaxian.frame = CGRectMake(_currentBtn.left, 49, KscreenWidth/2, 1);
                             
                         }];
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
                    [UIView animateWithDuration:0.3
                                     animations:^{
                                         //执行的动画
                                         _xiahuaxian.frame = CGRectMake(_currentBtn.left, 49, KscreenWidth/2, 1);
                                         
                                     }];
                }
                _currentBtn.selected = YES;
                _currentBtn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)newRefresh{
    
    [self refreshData];
    [self refreshData2];
    
}

- (void)refreshData
{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown) userInfo:nil repeats:NO];
    //    [_HUD show:YES];
}

- (void)refreshDown
{
    if (_searchFlag == 1) {
        [_searchDateArray1 removeAllObjects];
        _searchPage1 = 1;
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
        [_searchDateArray2 removeAllObjects];
        _searchPage2 = 1;
        [self searchData];
        [_refreshControl endRefreshing];
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
        _searchPage1++;
        [self searchData];
    }else{
        _page1++;
        [self DataRequest];
    }
}

- (void)upRefresh2
{
    if (_searchFlag == 1) {
        _searchPage2++;
        [self searchData];
    }else{
        _page2++;
        [self DataRequest1];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh1];
        }
        
    } else if (scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh2];
        }
    }
    
    
}

#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.liuLanTableView) {
        if (_searchFlag == 1) {
            return _searchDateArray1.count;
        }else{
            return _dataArray1.count;
        }
    }
    else if(tableView == self.shenPiTableView){
        if (_searchFlag == 1) {
            return _searchDateArray2.count;
        }else{
            return _dataArray2.count;
        }
    }else if(tableView == self.classTableView){
        return _classArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    FYBaoXiaoLiuLanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FYBaoXiaoLiuLanCellID"];
    if (cell == nil) {
        cell = (FYBaoXiaoLiuLanCell *) [[[NSBundle mainBundle] loadNibNamed:@"FYBaoXiaoLiuLanCell" owner:self options:nil]firstObject];
    }
    UITableViewCell* cellselect = [tableView dequeueReusableCellWithIdentifier:@"cellselect"];
    if (!cellselect) {
        cellselect = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView == self.liuLanTableView)
    {
        if (_searchFlag == 1) {
            if (_searchDateArray1.count != 0) {
                cell.model = _searchDateArray1[indexPath.row];
            }
        }else{
            if (_dataArray1.count != 0) {
                cell.model = _dataArray1[indexPath.row];
            }
        }
        return cell;
    }else if(tableView == self.shenPiTableView){
        if (_searchFlag == 1) {
            if (_searchDateArray2.count != 0) {
                cell.model = _searchDateArray2[indexPath.row];
                
            }
        }else{
            if (_dataArray2.count != 0) {
                cell.model = _dataArray2[indexPath.row];
                
            }
        }
        return cell;
    }else if(tableView == self.classTableView){
        
        
        cellselect.textLabel.text = _classArray[indexPath.row];
        
        return cellselect;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.liuLanTableView)
    {
        FYBaoXiaoDetailVC *liuLanMessage =[[FYBaoXiaoDetailVC alloc] init];
        liuLanMessage.vcType = @"0";
        if (_searchFlag == 1) {
            if (_searchDateArray1.count != 0) {
                FYModel *model = [_searchDateArray1 objectAtIndex:indexPath.row];
                liuLanMessage.model = model;
            }
        }else{
            if (_dataArray1.count != 0) {
                FYModel *model = [_dataArray1 objectAtIndex:indexPath.row];
                liuLanMessage.model = model;
            }
        }
        [self.navigationController pushViewController:liuLanMessage animated:YES];
        
    }else if(tableView == self.shenPiTableView)
    {
        FYBaoXiaoDetailVC *shenPiMessage =[[FYBaoXiaoDetailVC alloc] init];
        shenPiMessage.vcType = @"1";
        if (_searchFlag == 1) {
            if (_searchDateArray2.count != 0) {
                FYModel *model = [_searchDateArray2 objectAtIndex:indexPath.row];
                shenPiMessage.model = model;
            }
        }else{
            if (_dataArray2.count != 0) {
                FYModel *model = [_dataArray2 objectAtIndex:indexPath.row];
                shenPiMessage.model = model;
            }
            
        }
        [self.navigationController pushViewController:shenPiMessage animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView) {
        return  210;
    }else if(tableView == self.shenPiTableView){
        return  210;
    }
    else if(tableView == self.classTableView){
        return  44;
    }
    return 1;
}

- (void)addNext{
    FYBaoXiaoSearchVC* vc = [[FYBaoXiaoSearchVC alloc]init];
    [vc setBlock:^(NSString *orederNo, NSString *start, NSString *end) {
        _orederNo = orederNo;
        _start = start;
        _end = end;
        [self searchData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)searchAction{
    
    FYBXShangbaoVC *FYshangBao = [[FYBXShangbaoVC alloc] init];
    [self.navigationController pushViewController:FYshangBao animated:YES];
}






@end
