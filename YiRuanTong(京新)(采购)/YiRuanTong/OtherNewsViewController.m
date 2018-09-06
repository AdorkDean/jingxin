//
//  OtherNewsViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/14.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "OtherNewsViewController.h"
#import "OtherViewCell.h"
#import "QitaInfoModel.h"
#import "MBProgressHUD.h"
#import "DataPost.h"

@interface OtherNewsViewController (){

    UITableView *_otherTableView;
    NSMutableArray *_dataArray;
    NSInteger _page;
    UIRefreshControl *_refreshControl;
    MBProgressHUD *_HUD;
    
}

@end

@implementation OtherNewsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"其他信息";
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    
    [self DataRequest];
}

- (void)initTableView{
    
    _otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    _otherTableView.delegate = self;
    _otherTableView.dataSource = self;
    _otherTableView.rowHeight = 75;
    [self.view addSubview:_otherTableView];
    
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_otherTableView addSubview:_refreshControl];
    //     下拉刷新
    _otherTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_otherTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _otherTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _otherTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_otherTableView.mj_footer endRefreshing];
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
    [_dataArray removeAllObjects];
    _page = 1;
    [self DataRequest];
    [_refreshControl endRefreshing];
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

#pragma mark -TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell_other";
    OtherViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        
        cell = (OtherViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"OtherViewCell"owner:self options:nil]lastObject];
    }
    if (_dataArray.count != 0) {
        
        cell.model = _dataArray[indexPath.row];
        return cell;
    }
    return cell;
}

- (void)DataRequest{
    /*
     params.put("action", "getSchedule");
     params.put("table", "dbtz");
     params.put(Config.KEY_MOBILE, Config.KEY_IS_MOBILE);
     params.put(Config.KEY_PAGE, page + "");
     params.put(Config.KEY_ROWS, Config.ROWS_DEF);
     } catch (Exception e) {
     e.printStackTrace();
     }
     new BaseNet(context).post(Config.getrootpath() + "schedule", params,
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/schedule"];
    NSDictionary *params = @{@"action":@"getSchedule",@"table":@"dbtz",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        
        for (NSDictionary *dic in array) {
            QitaInfoModel *model = [[QitaInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [_HUD hide:YES];
        
        [_otherTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录测试11");
            [self selfLogin];
        }else{
            
            [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
//    NSURL *url =[NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str =[NSString stringWithFormat:@"action=getSchedule&table=dbtz&rows=20&page=%zi",_page];
//    
//    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
//    NSArray *array = dic[@"rows"];
//    
//    for (NSDictionary *dic in array) {
//        QitaInfoModel *model = [[QitaInfoModel alloc] init];
//        [model setValuesForKeysWithDictionary:dic];
//        [_dataArray addObject:model];
//    }
//    [_HUD hide:YES];
//    
//    [_otherTableView reloadData];
    
}

@end
