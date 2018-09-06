//
//  KQLiShiViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/16.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KQLiShiViewController.h"
#import "KaoQinViewController.h"
#import "LiShiCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "KQLishiModel.h"
#import "DataPost.h"
@interface KQLiShiViewController ()

{   UIRefreshControl *_refreshControl;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
}

@end

@implementation KQLiShiViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    self.title = @"考勤历史";
    self.navigationItem.rightBarButtonItem = nil;
    self.kaoQinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 14) style:UITableViewStylePlain];
    self.kaoQinTableView.delegate = self;
    self.kaoQinTableView.dataSource = self;
     [self.view addSubview:_kaoQinTableView];
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.kaoQinTableView addSubview:_refreshControl];
    //     下拉刷新
    _kaoQinTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_kaoQinTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _kaoQinTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _kaoQinTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_kaoQinTableView.mj_footer endRefreshing];
    }];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.labelText = @"网络不给力，正在加载中...";
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];
    [self DataRequest];
}

- (void)DataRequest
{
    //"http://182.92.96.58:8005/yrt/servlet"
    //考勤历史的接口

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/workSign"];
    NSDictionary *parameters = @{@"rows":@"10",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeans",@"table":@"gzkq"};
    [DataPost requestAFWithUrl:urlStr params:parameters finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"考勤历史:%@",dic);
        NSArray *array = dic[@"rows"];
        if (array.count==0) {
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"您暂无考勤历史...";
            _HUD.removeFromSuperViewOnHide = YES;
            [_HUD hide:YES afterDelay:1.0];
        }else{
            for (NSDictionary *dic in array) {
                KQLishiModel *model = [[KQLishiModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.kaoQinTableView reloadData];
            [_HUD hide:YES afterDelay:1.0];
            [_HUD removeFromSuperview];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        
        NSLog(@"请求失败");
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
//    NSDictionary *parameters = @{@"rows":@"10",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeans",@"table":@"gzkq"};
//    
//    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        NSLog(@"考勤历史:%@",dic);
//        NSArray *array = dic[@"rows"];
//        for (NSDictionary *dic in array) {
//            KQLishiModel *model = [[KQLishiModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:model];
//        }
//        [self.kaoQinTableView reloadData];
//        [_HUD hide:YES afterDelay:1.0];
//        [_HUD removeFromSuperview];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSInteger errorCode = error.code;
//        
//        
//        [_HUD hide:YES];
//        [_HUD removeFromSuperview];
//        
//        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
//        
//        NSLog(@"请求失败");
//    }];
}


- (void)refreshData{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown) userInfo:nil repeats:NO];
}
- (void)refreshDown{
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
//        [_HUD show:YES];
//        [self upRefresh];
    }
}

#pragma mark - UITabelViewDeleagateAndDataSource协议方法
//返回每个section上cell的数量

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    
    LiShiCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (LiShiCell *)[[[NSBundle mainBundle] loadNibNamed:@"LiShiCell" owner:self options:nil] firstObject];
    }
    
    KQLishiModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    NSString * riqiData = [model.date substringToIndex:10];
    
    cell.riQi.text = riqiData;
    NSString *week = model.week;
    NSString * Week = nil;
    switch ([week intValue]) {
        case 1:
            Week = @"星期一";
            break;
        case 0:
            Week = @"星期天";
            break;
        case 2:
            Week = @"星期二";
            break;
        case 3:
            Week = @"星期三";
            break;
        case 4:
            Week = @"星期四";
            break;
        case 5:
            Week = @"星期五";
            break;
        case 6:
            Week = @"星期六";
            break;
        default:
            break;
    }
    
    cell.xingQi.text = Week;
    
    if (model.signintime.length != 0) {
        NSString * signintimeText = [model.signintime substringFromIndex:10];
        cell.qianDao.text = signintimeText;
        cell.qiandao1.text = model.signinsite;
    }
    
    NSString *qiantui = [NSString stringWithFormat:@"%@",model.signouttime];
    
    if (qiantui.length != 0) {
        
        NSString * signouttimeText = [model.signouttime substringFromIndex:10];
        cell.qianTui.text = signouttimeText;
        cell.qianTui1.text = model.signoutsite;
        
    } else {
        
        cell.qianTui.text = @"未签退";
        cell.qianTui.textColor = [UIColor orangeColor];
        cell.qianTui1.text = model.signoutsite;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",model.islate];
    NSString *str2 = [NSString stringWithFormat:@"%@",model.isabsent];
    if ([str isEqualToString:@"1"]&&[str2 isEqualToString:@"1"]) {
        cell.late.text = @"旷工";
        cell.late.textColor = [UIColor orangeColor];
        cell.qianDao.textColor = [UIColor orangeColor];
    } else if([str isEqualToString:@"1"]&&[str2 isEqualToString:@"0"]){
        cell.late.text = @"迟到";
        cell.late.textColor = [UIColor orangeColor];
        cell.qianDao.textColor = [UIColor orangeColor];
    } else if([str isEqualToString:@"0"]){
        cell.late.text = @"";
    }
    
    NSString *str1 = [NSString stringWithFormat:@"%@",model.islate];
    if ([str1 isEqualToString:@"1"]) {
        cell.early.text = @"早退";
        cell.early.textColor = [UIColor orangeColor];
        cell.qianTui.textColor = [UIColor orangeColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
