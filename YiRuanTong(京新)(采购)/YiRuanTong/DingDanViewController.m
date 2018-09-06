//
//  DingDanViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "DingDanViewController.h"
#import "MainViewController.h"
#import "TianJiaDingDanVC.h"
#import "DDLiuLanCell.h"
#import "DDShenPiCell.h"
#import "DDLiuLanMessageVC.h"
#import "DDShenPiMessageVC.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "DDguanliModel.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "WuliuManageViewController.h"

#import "DDLiuLanDetailNewVC.h"
#import "DingDanSousuoViewController.h"

@interface DingDanViewController ()<UITextFieldDelegate>

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSInteger _page1;
    NSInteger _page2;
    MBProgressHUD *_HUD;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    
    UIButton *_currentBtn;
    UIButton *_liuLanButton;
    UIButton *_shenPiButton;
    NSMutableArray *_btnArray;
    
    UILabel *_xiahuaxian;
    NSString *_custId;
    NSString *_salerID;
    NSString *_orederNo;
    NSString *_start;
    NSString *_end;
}


@end

@implementation DingDanViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.liuLanTableView reloadData];

}
- (void)navigationSetRightButton{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(KscreenWidth - 90, 10, 40, 40);
    [searchButton setTitle:@"下单" forState:UIControlStateNormal];
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
    self.navigationItem.title = @"订单查看";
    
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _btnArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _page1 = 1;
    _page2 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    
    
    [self navigationSetRightButton];
    [self PageViewDidLoad1];
    
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    //数据加载
    [self DataRequest];
    [self DataRequest1];
    
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    NSString * string = [pushJudge objectForKey:@"push"];
//    if([string isEqualToString:@"push"]) {
//        [self searchNoticeData];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu_return"]style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRefresh) name:@"newOrder" object:nil];
   
}
//-(void)rebackToRootViewAction{
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    NSString * string = [pushJudge objectForKey:@"push"];
//    if([string isEqualToString:@"push"]) {
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        [pushJudge removeObjectForKey:@"push"];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
#pragma mark - 搜索方法
//-(void)searchNoticeData{
//    _custId = [self convertNull:_custId];
//    _start = [self convertNull:_start];
//    _end = [self convertNull:_end];
//    _salerID = [self convertNull:_salerID];
//    if ([_orederNo isEqualToString:@" "]&&[_start isEqualToString:@" "]&&[_end isEqualToString:@" "]&& [_custId isEqualToString:@" "]&&[_salerID isEqualToString:@" "]) {
//        _searchFlag = 0;
//    }else{
//        _searchFlag = 1;
//    }
//    if (_searchPage == 1) {
//        [_searchDateArray removeAllObjects];
//    }
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
//    NSDictionary *params = @{@"rows":@"10",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"action":@"getBeans",@"table":@"ddxx",@"params":[NSString stringWithFormat:@"{\"table\":\"ddxx\",\"isvalidEQ\":\"1\",\"custidEQ\":\"%@\",\"saleridEQ\":\"%@\",\"ordernoLIKE\":\"%@\",\"orderstatusEQ\":\"\",\"ordertimeGE\":\"%@\",\"ordertimeLE\":\"%@\"}",@"",@"",self.orderNo,@"",@""]};
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
//        NSArray *array = dic[@"rows"];
//        NSLog(@"搜索上传字符串%@",params);
//        NSLog(@"搜索列表:%@",array);
//        for (NSDictionary *dic in array) {
//            DDguanliModel *model = [[DDguanliModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            model.Id = dic[@"id"];
//            [_searchDateArray addObject:model];
//        }
//        [self.liuLanTableView reloadData];
//
//        [_HUD hide:YES];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        [_HUD hide:YES];
//        NSLog(@"搜索加载失败");
//        NSInteger errorCode = error.code;
//        NSLog(@"错误信息%@",error);
//        if (errorCode == 3840 ) {
//            NSLog(@"自动登录");
//            [self selfLogin];
//        }else{
//
//            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
//        }
//    }];
//}

- (void)searchData
{
    /*
     action:"getBeans"
     table:"ddxx"
     page:"1"
     rows:"20"
     params:"{"table":"ddxx","isvalidEQ":"1","custnameLIKE":"临清吉利养殖","saleridEQ":"124","ordernoLIKE":"DD1111111111","orderstatusEQ":"0","ordertimeGE":"2015-04-12","ordertimeLE":"2015-05-12"}"
     {"isvalidEQ":"1","custidEQ":"2283","saleridEQ":"","ordernoLIKE":"","proid":"","orderstatusEQ":"","ordertimeGE":"2015-11-02","ordertimeLE":"2015-12-02"}
     */
    
    _custId = [self convertNull:_custId];
    _orederNo = [self convertNull:_orederNo];
    _start = [self convertNull:_start];
    _end = [self convertNull:_end];
    _salerID = [self convertNull:_salerID];
    if ([_orederNo isEqualToString:@" "]&&[_start isEqualToString:@" "]&&[_end isEqualToString:@" "]&& [_custId isEqualToString:@" "]&&[_salerID isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
        NSDictionary *params = @{@"rows":@"10",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"action":@"getBeans",@"table":@"ddxx",@"params":[NSString stringWithFormat:@"{\"table\":\"ddxx\",\"isvalidEQ\":\"1\",\"custidEQ\":\"%@\",\"saleridEQ\":\"%@\",\"ordernoLIKE\":\"%@\",\"orderstatusEQ\":\"\",\"ordertimeGE\":\"%@\",\"ordertimeLE\":\"%@\"}",_custId,_salerID,_orederNo,_start,_end]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"搜索上传字符串%@",params);
            NSLog(@"搜索列表:%@",array);
            for (NSDictionary *dic in array) {
                DDguanliModel *model = [[DDguanliModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.Id = dic[@"id"];
                [_searchDateArray addObject:model];
            }
            [self.liuLanTableView reloadData];
            
            [_HUD hide:YES];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            [_HUD hide:YES];
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


#pragma mark - 浏览列表审批列表数据请求
- (void)DataRequest
{
    /*订单浏览列表
     order
     rows	10
     page	1
     action	getBeans
     table	ddxx
     */
    //订单浏览列表  的接口
    //拼接地址字符串
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"rows":@"10",@"page":[NSString stringWithFormat:@"%zi",_page1],@"action":@"getBeans",@"table":@"ddxx",@"params":@"{\"isvalidEQ\":\"1\"}"};
    NSLog(@">>>>%@",urlStr);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dic != nil) {
            NSArray *array = dic[@"rows"];
            NSLog(@"订单浏览列表:%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    DDguanliModel *model = [[DDguanliModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.Id = dic[@"id"];
                    [_dataArray1 addObject:model];
                }

            }
        [self.liuLanTableView reloadData];
        }
        }
        [_HUD hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
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
    /*订单审批列表
     http://182.92.96.58:8005/yrt/servlet/order
     rows	10
     page	1
     action	getBeansForAudit
     table	ddxx
     */
    //订单浏览列表  的接口
    //拼接地址字符串
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getBeansForAudit",@"flag":@"0",@"table":@"ddxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page2],@"params":@"{\"spstatusEQ\":\"0\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"订单审批列表:%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                DDguanliModel *model = [[DDguanliModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.Id = dic[@"id"];
                [_dataArray2 addObject:model];
            }
             
        }
            [self.shenPiTableView reloadData];
        }
        [_HUD hide:YES];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            [_HUD hide:YES];
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
    [_HUD show:YES];
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
        _searchPage++;
        [self searchData];
    }else{
        _page1++;
        [self DataRequest];
    }
}

- (void)upRefresh2
{
    _page2++;
    [self DataRequest1];
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
            return _searchDateArray.count;
        }else{
            return _dataArray1.count;
        }
    }
    else if(tableView == self.shenPiTableView){
        return _dataArray2.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    DDLiuLanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (DDLiuLanCell *) [[[NSBundle mainBundle] loadNibNamed:@"DDLiuLanCell" owner:self options:nil]firstObject];
    }
    DDShenPiCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = (DDShenPiCell*)[[[NSBundle mainBundle] loadNibNamed:@"DDShenPiCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == self.liuLanTableView)
    {
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                cell.model = _searchDateArray[indexPath.row];
                [cell setTransVaule:^(BOOL click) {
                    WuliuManageViewController* vc = [[WuliuManageViewController alloc]init];
                    DDguanliModel *vcmodel = _searchDateArray[indexPath.row];
                    vc.orderno = [NSString stringWithFormat:@"%@",vcmodel.orderno];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }else{
            if (_dataArray1.count != 0) {
                cell.model = _dataArray1[indexPath.row];
                [cell setTransVaule:^(BOOL click) {
                    WuliuManageViewController* vc = [[WuliuManageViewController alloc]init];
                    DDguanliModel *vcmodel = _dataArray1[indexPath.row];
                    vc.orderno = [NSString stringWithFormat:@"%@",vcmodel.orderno];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }
        return cell;
    }else if(tableView == self.shenPiTableView){
        if (_dataArray2.count != 0) {
          cell1.model = _dataArray2[indexPath.row];
          
        }
        return cell1;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.liuLanTableView)
    {
//        DDLiuLanMessageVC *liuLanMessage =[[DDLiuLanMessageVC alloc] init];
        DDLiuLanDetailNewVC *liuLanMessage =[[DDLiuLanDetailNewVC alloc] init];
        liuLanMessage.vcType = @"0";
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                DDguanliModel *model = [_searchDateArray objectAtIndex:indexPath.row];
                liuLanMessage.model = model;
                liuLanMessage.wuliuID = model.logisticsid;
                liuLanMessage.chanpinID = model.Id;
                liuLanMessage.orderNo = model.orderno;
            }
        }else{
            if (_dataArray1.count != 0) {
                DDguanliModel *model = [_dataArray1 objectAtIndex:indexPath.row];
                liuLanMessage.model = model;
                liuLanMessage.wuliuID = model.logisticsid;
                liuLanMessage.chanpinID = model.Id;
                liuLanMessage.orderNo = model.orderno;
            }
        }
        [self.navigationController pushViewController:liuLanMessage animated:YES];
        
    }else if(tableView == self.shenPiTableView)
    {
//        DDShenPiMessageVC *shenPiMessage = [[DDShenPiMessageVC alloc] init];
        DDLiuLanDetailNewVC *shenPiMessage =[[DDLiuLanDetailNewVC alloc] init];
        shenPiMessage.vcType = @"1";
        if (_dataArray2.count != 0) {
            DDguanliModel *model = [_dataArray2 objectAtIndex:indexPath.row];
            shenPiMessage.model = model;
            shenPiMessage.spStatus = [model.spstatus integerValue];
            shenPiMessage.wuliuID = model.logisticsid;
            shenPiMessage.chanpinID = model.Id;
            shenPiMessage.orderNo = model.orderno;
        }
        [self.navigationController pushViewController:shenPiMessage animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView) {
        return  200;
    }else if(tableView == self.shenPiTableView){
        return  162;
    }
    return 1;
}

- (void)addNext{
    
    DingDanSousuoViewController *sousuoVC = [[DingDanSousuoViewController alloc] init];
    void(^aBlock)(NSString *custId,NSString *salerID,NSString *orederNo,NSString *start,NSString *end) = ^(NSString *custId,NSString *salerID,NSString *orederNo,NSString *start,NSString *end){
        _custId = custId;
        _salerID = salerID;
        _orederNo = orederNo;
        _start = start;
        _end = end;
        [self searchData];
    };
    sousuoVC.block = aBlock;
    [self.navigationController  pushViewController:sousuoVC animated:YES];
    
}

- (void)searchAction{
    TianJiaDingDanVC *tianjiaVC = [[TianJiaDingDanVC alloc] init];
    [self.navigationController  pushViewController:tianjiaVC animated:YES];
}
@end
