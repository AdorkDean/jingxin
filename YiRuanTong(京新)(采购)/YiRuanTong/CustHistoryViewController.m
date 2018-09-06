//
//  CustHistoryViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/7.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "CustHistoryViewController.h"
#import "CustHistoryCell.h"
#import "ReplyViewCell.h"
#import "BaifangLishiModel.h"
#import "ZhaoPianShangChuanVC.h"

@interface CustHistoryViewController (){
    UITableView *_tableView;
    BOOL close[20];
    NSMutableArray *_dataArray;
    UIRefreshControl *_refreshControl;
    NSInteger _page;
    MBProgressHUD *_HUD;

}

@end

@implementation CustHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    self.title = @"拜访历史";
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self dataRequest];

    //页面设置
    //GCD
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self dataRequest];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self initView];
//            
//        });
//    });

}

- (void)initView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_tableView addSubview:_refreshControl];
    [self.view addSubview:_tableView];
    //     下拉刷新
    _tableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_tableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_tableView.mj_footer endRefreshing];
    }];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_HUD show:YES];

}

- (void)refreshData
{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown) userInfo:nil repeats:NO];
}

- (void)upRefresh
{
    _page++;
    [self dataRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//        [self upRefresh];
    }
}

- (void)refreshDown
{
    [_dataArray removeAllObjects];
    _page = 1;
    [self dataRequest];
    [_refreshControl endRefreshing];
}

#pragma mark - loadData
//加载数据
- (void)dataRequest{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getVisiteByYear&mobile=true&page=%zi&rows=4&params={\"accountid\":\"%@\",\"custid\":\"%@\"}",_page,self.visitorid,self.custid];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (data1 != nil) {
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"拜访历史输出:%@",array);
        if (array.count==0) {
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"您暂无拜访历史";
            _HUD.removeFromSuperViewOnHide = YES;
            [_HUD hide:YES afterDelay:1.0];
        }else{
            for (NSDictionary *dic in array) {
                BaifangLishiModel *model = [[BaifangLishiModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
        }

        [_tableView reloadData];
    }
    
}
//设置每一组cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell110";
    CustHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (CustHistoryCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustHistoryCell" owner:self options:nil]firstObject];
    }
    BaifangLishiModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.purposeLabel.text = model.purpose;
    cell.statesLabel.text = model.visitecontent;
    cell.nextPurposeLabel.text = model.nextvisitepurpose;
    cell.visiteDateLabel.text = model.visitedate;
    return cell;
}

@end
