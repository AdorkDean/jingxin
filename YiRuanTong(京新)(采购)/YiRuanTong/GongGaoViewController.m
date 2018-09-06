//
//  GongGaoViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "GongGaoViewController.h"
#import "MainViewController.h"
#import "GongGaoCell.h"
#import "GongGaoMessageVC.h"
#import "MBProgressHUD.h"
#import "GGliulanModel.h"
#import "DataPost.h"

@interface GongGaoViewController ()

{
    UIRefreshControl *_refreshControl;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSInteger _page1;
    UIView *_searchView;
    UIView *_backView;
    UITextField *_title;
}

@end

@implementation GongGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告浏览";
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    _page1 = 1;
    //删除添加按钮
    self.navigationItem.rightBarButtonItem = nil;
    [self initTableView];
    //
    [self searchView];

    
    [self DataRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"noticeRead" object:nil];
}
#pragma mark- 搜索页面
- (void)searchView{
    
    _title.text = @" ";
    //右侧模糊视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 0, KscreenWidth/3, KscreenHeight -64)];
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = .6;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTouchesRequired = 1;
    [ _backView addGestureRecognizer:singleTap];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    //信息视图
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3*2, KscreenHeight - 64)];
    _searchView.backgroundColor = [UIColor whiteColor];
    //
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
    Label1.text = @"公告标题";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    _title = [[UITextField alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40)];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
    nameView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label1];
    [_searchView addSubview:_title];
    [_searchView addSubview:nameView];
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor lightGrayColor];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, 40 +30, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:[UIColor lightGrayColor]];
    [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, 40 + 30, 60, 30);
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    UIView *fenGenXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 40)];
    fenGenXian.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:fenGenXian];
    
    [_searchView addSubview:searchBtn];
    [_searchView addSubview:chongZhi];
    [self.view  addSubview:_searchView];
    _searchView.hidden = YES;
    
}
#pragma mark -搜索页面方法
- (void)singleTapAction{
    _backView.hidden = YES;
    _searchView.hidden = YES;
    
}
- (void)search
{   /*
     action:"getBeans"
     table:"xwgg"
     page:"1"
     rows:"20"
     params:"{"table":"xwgg","categoryidEQ":"","typeidEQ":"","titleLIKE":"11111111","publishtimeGE":"","publishtimeLE":""}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/news"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getBeans&table=xwgg&rows=20&page=%zi&params={\"table\":\"xwgg\",\"categoryidEQ\":\"\",\"typeidEQ\":\"\",\"titleLIKE\":\"%@\",\"publishtimeGE\":\"\",\"publishtimeLE\":\"\"}",_page1,_title.text];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            GGliulanModel *model = [[GGliulanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.gongGaoTableView reloadData];
        [_HUD hide:YES];
        _searchView.hidden = YES;
        _backView.hidden = YES;
    }else{
        [self showAlert:@"加载失败"];

    }
    
}

- (void)chongZhi
{
    _title.text = @" ";
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
    [_dataArray removeAllObjects];
    _page = 1;
    [self DataRequest];
    [_refreshControl endRefreshing];
}

- (void)initTableView{
    
    _gongGaoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 14)];
    _gongGaoTableView.delegate = self;
    _gongGaoTableView.dataSource = self;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.gongGaoTableView addGestureRecognizer:swipe];
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.gongGaoTableView addSubview:_refreshControl];
    [self.view addSubview:_gongGaoTableView];
    //     下拉刷新
    _gongGaoTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_gongGaoTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _gongGaoTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _gongGaoTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_gongGaoTableView.mj_footer endRefreshing];
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

- (void)swipeAction{
    _searchView.hidden = NO;
    _backView.hidden = NO;

}

- (void)upRefresh
{
    [_HUD show:YES];
    _page++;
    [self DataRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//        [self upRefresh];
    }
}
#pragma mark - 数据加载
-(void)DataRequest
{
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    //公告浏览的 接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/news"];
    NSDictionary *params = @{@"action":@"getBeans",@"mobile":@"true",@"table":@"xwgg",@"page":[NSString stringWithFormat:@"%zi",_page],@"rows":@"20",@"params":@"{\"typeidEQ\":\"134\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"公告浏览列表:%@",str);
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
            for (NSDictionary *dic in array) {
                GGliulanModel *model = [[GGliulanModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.gongGaoTableView reloadData];
        
        [_HUD removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD removeFromSuperview];
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

#pragma mark - Table view data source

//返回的section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GongGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        cell = (GongGaoCell *) [[[NSBundle mainBundle]loadNibNamed:@"GongGaoCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count != 0) {
        
       cell.model = [_dataArray objectAtIndex:indexPath.row];
        
            }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*MYWIDTH;
}

//点击事件  进入公告详情页面；
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GongGaoCell *cell = (GongGaoCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.shiFouYueDu.text isEqualToString:@"未读"]) {
        cell.shiFouYueDu.text = @"已读";
        cell.shiFouYueDu.textColor = [UIColor blackColor];
    }
    
    GongGaoMessageVC * gongGaoMessage =[[GongGaoMessageVC alloc] init];
    GGliulanModel *model = [_dataArray objectAtIndex:indexPath.row];
    gongGaoMessage.model = model;
    
    [self.navigationController pushViewController:gongGaoMessage animated:YES];
}

@end
