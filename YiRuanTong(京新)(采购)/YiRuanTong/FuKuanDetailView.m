//
//  FuKuanDetailView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/7/3.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FuKuanDetailView.h"
#import "FKDetailModel.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "KHYingShouKuanCell.h"
#import "QLKeHuDetailCell.h"
@interface FuKuanDetailView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIRefreshControl *_refreshControl;
    UITableView *_detailTableView;
    NSMutableArray *_dataArray;
    MBProgressHUD *_hud;
    NSInteger _page;
}
@property(nonatomic,retain)UIScrollView *mainScrollView;
@end

@implementation FuKuanDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户付款详情";
    _dataArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = nil;
    _page = 1;
    [self initTableView];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"网络不给力，正在加载中...";
    //_hud.dimBackground = YES;
    [_hud show:YES];
    [self DataRequest];
    
}

- (void)initTableView{
    
    _detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)style:UITableViewStyleGrouped];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.rowHeight = 140;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_detailTableView addSubview:_refreshControl];
    [self.view addSubview:_detailTableView];
    //     下拉刷新
    _detailTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_detailTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _detailTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _detailTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_detailTableView.mj_footer endRefreshing];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"QLKeHuDetailCell";
    QLKeHuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (QLKeHuDetailCell *)[[[NSBundle mainBundle]loadNibNamed:@"QLKeHuDetailCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count != 0) {
        cell.model = _dataArray[indexPath.section];
    }
    
    return cell;
}


- (void)DataRequest{
    /*
     action:"searchShip"
     page:"1"
     rows:"20"
     params:"{"shipno":"FP201509180003"}"

     */
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing"];
    NSDictionary *params = @{@"action":@"kehuyingshoumingxiModel",@"page":[NSString stringWithFormat:@"%zi",_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"custidEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",_custId,self.createtimeGE,self.createtimeLE]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"应收款详情数据%@",dic);
        NSArray *array = dic[@"rows"];
        if (array.count != 0) {
            for (NSDictionary *dic  in array) {
                FKDetailModel *model = [[FKDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [_detailTableView reloadData];
        }
        [_hud hide:YES afterDelay:.5];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_hud hide:YES afterDelay:.5];
        NSLog(@"加载失败");
    }];
    
}
- (void)refreshData{

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


- (void)upRefresh
{
    
    _page++;
    [self DataRequest];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh];
        }

}
@end
