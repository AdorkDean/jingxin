//
//  ProductStoreViewController.m
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProductStoreViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProStoreListModel.h"
#import "ProStoreListCell.h"
#import "DataPost.h"
#import "ProStoreDetailVC.h"
#import "UIViewExt.h"
#import "ProStoreSearchVC.h"

@interface ProductStoreViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    MBProgressHUD *_HUD;
//    NSMutableArray *_dataArray;
//    NSInteger _page;
//    NSInteger _searchPage;
    NSInteger _searchFlag;
//    NSMutableArray* _searchDateArray;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _searchPage1;
    NSInteger _searchPage2;
    NSMutableArray* _searchDateArray1;
    NSMutableArray* _searchDateArray2;
    NSMutableArray* _btnArray;
    UIButton* _currentBtn;
    UIButton *_liuLanButton;
    UIButton *_shenPiButton;
    UILabel* _xiahuaxian;
    
    NSString* _sono;
    NSString*_status;
    NSString* _proname;
    NSString* _bom;
    NSString* _plan;
    NSString* _creator;
}
//@property (strong, nonatomic)  UITableView *kuCunTableView;
@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UITableView * liuLanTableView;
@property(strong,nonatomic) UITableView * shenPiTableView;

@end

@implementation ProductStoreViewController



- (void)viewWillAppear:(BOOL)animated{
    [self.liuLanTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生产出库管理";
    
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
    
    [self showBarWithName:@"搜索" addBarWithName:nil];
    [self PageViewDidLoad1];
    //数据加载
    [self DataRequest];
    [self DataRequest1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRefresh) name:@"newOrder" object:nil];
    
}

- (void)searchData
{
    NSString *bomno;
    bomno = [self convertNull:_bom];
    if ([_bom isEqualToString:@""]&&[_plan isEqualToString:@""]&&[_status isEqualToString:@""]&&[_proname isEqualToString:@""]&&[_creator isEqualToString:@""]&&[_sono isEqualToString:@""]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    if (_searchPage1 == 1) {
        [_searchDateArray1 removeAllObjects];
    }
    if (_searchPage2 == 1) {
        [_searchDateArray2 removeAllObjects];
    }
    if (_liuLanButton.selected == YES) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/prdstockout?action=getBeans&table=scck"];
        NSString* datastr = [NSString stringWithFormat:@"{\"table\":\"scck\",\"sonoLIKE\":\"%@\",\"isstockoutEQ\":\"%@\",\"pronameLIKE\":\"%@\",\"bomnoEQ\":\"%@\",\"plannoEQ\":\"%@\",\"creatorLIKE\":\"%@\"}",_sono,_status,_proname,_bom,_plan,_creator];
        NSDictionary *params = @{@"action":@"getBeans",@"table":@"scck",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_searchPage1],@"params":datastr};
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
                    ProStoreListModel *model = [[ProStoreListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray1 addObject:model];
                }
                [self.liuLanTableView reloadData];
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
        
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/prdstockout?action=getSPBean&table=scck"];
        NSString* datastr = [NSString stringWithFormat:@"{\"table\":\"scck\",\"sonoLIKE\":\"%@\",\"isstockoutEQ\":\"%@\",\"pronameLIKE\":\"%@\",\"bomnoEQ\":\"%@\",\"plannoEQ\":\"%@\",\"creatorLIKE\":\"%@\",\"spstatusEQ\":\"0\"}",_sono,_status,_proname,_bom,_plan,_creator];
        NSDictionary *params = @{@"action":@"getBeans",@"table":@"scck",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_searchPage1],@"params":datastr};
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
                    ProStoreListModel *model = [[ProStoreListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray2 addObject:model];
                }
                [self.shenPiTableView reloadData];
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
    /*
     *params={"table":"scck","sonoLIKE":"","pronameLIKE":"","bomnoEQ":"","plannoEQ":"","creatorLIKE":"","isstockoutEQ":"0"}
     url=http://192.168.1.199:8080/jingxin/servlet/prdstockout?action=getBeans&table=scck
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/prdstockout?action=getBeans&table=scck"];
    NSDictionary *params = @{@"action":@"getBeans",@"table":@"scck",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_page1],@"params":@"{\"table\":\"scck\",\"sonoLIKE\":\"\",\"isstockoutEQ\":\"0\",\"pronameLIKE\":\"\",\"bomnoEQ\":\"\",\"plannoEQ\":\"\",\"creatorLIKE\":\"\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page1 == 1) {
            [_dataArray1 removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];

            NSLog(@"物料浏览列表:%@",array);
            for (NSDictionary *dic in array) {
                ProStoreListModel *model = [[ProStoreListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];

            }
            [self.liuLanTableView reloadData];
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
- (void)DataRequest1
{
    //进度HUD
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"网络不给力，正在加载中...";
    [hud show:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/prdstockout?action=getSPBean&table=scck"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page2],@"params":@"{\"table\":\"scck\",\"sonoLIKE\":\"\",\"isstockoutEQ\":\"0\",\"pronameLIKE\":\"\",\"bomnoEQ\":\"\",\"plannoEQ\":\"\",\"creatorLIKE\":\"\",\"spstatusEQ\":\"0\"}"};
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
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    ProStoreListModel *model = [[ProStoreListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
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


//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (scrollView.tag == 10) {
//        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh1];
//        }
//
//    } else if (scrollView.tag == 20){
//        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh2];
//        }
//    }
//}

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
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"ProStoreListCellID";
    ProStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (ProStoreListCell *)[[[NSBundle mainBundle]loadNibNamed:@"ProStoreListCell" owner:self options:nil]firstObject];
    }
    UITableViewCell* cellselect = [tableView dequeueReusableCellWithIdentifier:@"cellselect"];
    if (!cellselect) {
        cellselect = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }

    if (tableView == self.liuLanTableView)
    {
        cell.isoutBtn.hidden = NO;
        if (_searchFlag == 1) {
            if (_searchDateArray1.count != 0) {
                cell.model = _searchDateArray1[indexPath.row];
            }
        }else{
            if (_dataArray1.count != 0) {
                cell.model = _dataArray1[indexPath.row];
            }
        }
        __weak typeof (ProStoreListCell*) weakcell = cell;
        //点击了确认出库
        [cell setIsOutBtnBlock:^(UIButton *sender) {
            NSString* isout = [NSString stringWithFormat:@"%@",weakcell.model.isstockout];
            NSString* Idstr = [NSString stringWithFormat:@"%@",weakcell.model.Id];
            if ([isout isEqualToString:@"0"]) {
                [self sureStockOutRequest:Idstr];
            }else if ([isout isEqualToString:@"1"]){
                [self showAlert:@"已经出库不能重复出库"];
            }
            
        }];
        return cell;
    }else if(tableView == self.shenPiTableView){
        cell.isoutBtn.hidden = YES;
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
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.liuLanTableView)
    {
        ProStoreDetailVC *liuLanMessage = [[ProStoreDetailVC alloc] init];
        liuLanMessage.vcType = @"0";
        if (_searchFlag == 1) {
            if (_searchDateArray1.count != 0) {
            ProStoreListModel *model= _searchDateArray1[indexPath.row];
            liuLanMessage.model = model;
            liuLanMessage.chanpinID = [NSString stringWithFormat:@"%@",model.Id];
            }
        }else{
            if (_dataArray1.count != 0) {
            ProStoreListModel *model= _dataArray1[indexPath.row];
            liuLanMessage.model = model;
            liuLanMessage.chanpinID = [NSString stringWithFormat:@"%@",model.Id];
            }
        }
        [self.navigationController pushViewController:liuLanMessage animated:YES];
    }else if(tableView == self.shenPiTableView)
    {
        ProStoreDetailVC *shenPiMessage =[[ProStoreDetailVC alloc] init];
        shenPiMessage.vcType = @"1";
        if (_searchFlag == 1) {
            if (_searchDateArray2.count != 0) {
                ProStoreListModel *model= _searchDateArray2[indexPath.row];
                shenPiMessage.model = model;
                shenPiMessage.chanpinID = [NSString stringWithFormat:@"%@",model.Id];
            }
        }else{
            if (_dataArray2.count != 0) {
                ProStoreListModel *model= _dataArray2[indexPath.row];
                shenPiMessage.model = model;
                shenPiMessage.chanpinID = [NSString stringWithFormat:@"%@",model.Id];
            }
            
        }
        [self.navigationController pushViewController:shenPiMessage animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView) {
        return  260;
    }else if(tableView == self.shenPiTableView){
        return  260;
    }
    return 1;
}

- (void)addNext{
    ProStoreSearchVC * vc = [[ProStoreSearchVC alloc]init];
    [vc setBlock:^(NSString *bomno,NSString* sono,NSString *planno,NSString *status,NSString *proname,NSString* creator) {
        _bom = bomno;
        _sono = sono;
        _plan = planno;
        _status = status;
        _proname = proname;
        _creator = creator;
        [self searchData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sureStockOutRequest:(NSString*)idstr{
    /*
     确认出库url：/prdstockout?action=outConfirm&table=scck
     参数：id
     */
    //进度HUD
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"网络不给力，正在加载中...";
    [hud show:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/prdstockout?action=outConfirm&table=scck"];
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",idstr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            if ([realStr isEqualToString:@"true"]||[realStr isEqualToString:@"\"true\""]) {
                [self showAlert:@"确认出库成功"];
            }else if ([realStr isEqualToString:@"false"]||[realStr isEqualToString:@"\"false\""]){
                [self showAlert:@"确认出库失败"];
            }else{
                [self showAlert:realStr];
            }
            [self newRefresh];
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


@end
