//
//  ZhaoPianViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZhaoPianViewController.h"
#import "MainViewController.h"
#import "ZhaoPianShangChuanVC.h"
#import "ZhaoPianCell.h"
#import "HuoDongLeiBiaoVC.h"
#import "ZhaoPianUpLoadModel.h"

@interface ZhaoPianViewController ()
{
    UIRefreshControl *_refreshControl;
    NSMutableArray *_dataArray;
    NSInteger _page;
}

@end

@implementation ZhaoPianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    self.title = @"拍照上传";
    [self showBarWithName:@"拍照" addBarWithName:nil];
    //初始化
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DataRequest];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initTableView];
        });
    });
    

}
- (void)initTableView{
    
    self.ZhaoPianLeiXingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 14) style:UITableViewStylePlain];
    self.ZhaoPianLeiXingTableView.dataSource = self;
    self.ZhaoPianLeiXingTableView.delegate = self;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.ZhaoPianLeiXingTableView addSubview:_refreshControl];
    [self.view addSubview:self.ZhaoPianLeiXingTableView];
    //     下拉刷新
    self.ZhaoPianLeiXingTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.ZhaoPianLeiXingTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.ZhaoPianLeiXingTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.ZhaoPianLeiXingTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [self.ZhaoPianLeiXingTableView.mj_footer endRefreshing];
    }];
}
//数据加载
- (void)DataRequest
{
    NSString *strAdress = @"/picture";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];

    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"rows=10&mobile=true&page=%zi&action=getPicType",_page];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options: NSJSONReadingMutableContainers  error:nil];
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            ZhaoPianUpLoadModel *model = [[ZhaoPianUpLoadModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.ZhaoPianLeiXingTableView reloadData];
    }
    
}

#pragma mark UITableDelegate And DataSource 方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ZhaoPianCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell =(ZhaoPianCell*)[[[NSBundle mainBundle]loadNibNamed:@"ZhaoPianCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count != 0) {
        ZhaoPianUpLoadModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.leiXingLabel.text = model.pictype;
    }
    return cell;
}
//点击事件 点击进入活动列表页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuoDongLeiBiaoVC * huoDongView = [[HuoDongLeiBiaoVC alloc] init];
    ZhaoPianUpLoadModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    huoDongView.zhaoPianID = model.pictypeid;
    
    [self.navigationController pushViewController:huoDongView animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//        [self upRefresh];
    }
}

- (void)upRefresh
{
    _page++;
    [self DataRequest];
}

//照片添加
//上报提交
- (void)addNext{
    
    ZhaoPianShangChuanVC *shangchuangVC = [[ZhaoPianShangChuanVC alloc] init];
    [self.navigationController pushViewController:shangchuangVC animated:YES];
    
}
//
- (void)searchAction{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
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

@end
