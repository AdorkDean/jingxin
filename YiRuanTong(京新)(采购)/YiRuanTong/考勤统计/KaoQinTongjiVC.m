//
//  KaoQinTongjiVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/14.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "KaoQinTongjiVC.h"
#import "DataPost.h"
#import "RZshangbaoModel.h"
#import "KaoQinHistoryModel.h"
#import "KaoQinHistoryCell.h"
#import "TongjiModel.h"
#import "TongjiSelectVC.h"
#import "TongjiSearchVC.h"
#import "KaoQinSelectVC.h"
@interface KaoQinTongjiVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KaoQinTongjiVC
{
    UIRefreshControl *_refreshControl;
    NSArray *_imageArr;
    UIView * _bottomView;
    NSInteger _page;
    NSMutableArray *_dataArray1;
    NSString * _currentDateStr;
    NSString * _pastDateStr;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"考勤统计";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    _page = 1;
    _dataArray1 = [[NSMutableArray alloc]init];
    [self getDateStr];
    [self.view addSubview:self.tableView];
    [self DataRequest1];
}
-(void)souSuoButtonClickMethod{
    KaoQinSelectVC * vc = [[KaoQinSelectVC alloc]init];
    [vc setBlock:^(NSString *proid,NSString *proname, NSString *start, NSString *end) {
        [self searchDataWithProid:proid StartTime:start EndTime:end ProName:proname];
        
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchDataWithProid:(NSString *)proid StartTime:(NSString *)start EndTime:(NSString *)end ProName:(NSString *)proname{
    //统计列表的接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/workSign"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"signStatistics",@"params":[NSString stringWithFormat:@"{\"empidEQ\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",proid,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        [_dataArray1 removeAllObjects];
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"统计列表的返回:%@",dic);
            for (NSDictionary *dic in array) {
                KaoQinHistoryModel *model = [[KaoQinHistoryModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
            [_tableView reloadData];
        };
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
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
    [_dataArray1 removeAllObjects];
    _page = 1;
    [self DataRequest1];
    [_refreshControl endRefreshing];
}
//上拉加载更多
- (void)upRefresh
{
    _page++;
    [self DataRequest1];
}
- (void)DataRequest1
{
    //考勤统计列表的接口 workSign?action=signStatistics
    
    //{"empidEQ":"","dateGE":"","dateLE":""}
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/workSign"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"signStatistics",@"params":[NSString stringWithFormat:@"{\"empidEQ\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",@"",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"统计列表的返回:%@",dic);
            for (NSDictionary *dic in array) {
                KaoQinHistoryModel *model = [[KaoQinHistoryModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
            [_tableView reloadData];
        };
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"KaoQinHistoryCell";
    KaoQinHistoryCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(KaoQinHistoryCell*)[[[NSBundle mainBundle] loadNibNamed:@"KaoQinHistoryCell" owner:self options:nil]firstObject];
    }
    KaoQinHistoryModel * model;
    if (_dataArray1.count != 0) {
        model = _dataArray1[indexPath.row];
        cell1.model = model;
    }
    return cell1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_dataArray1.count != 0) {
//        TongjiModel * model = _dataArray1[indexPath.row];
//        TongjiSelectVC * vc = [[TongjiSelectVC alloc]init];
//        vc.idString = [NSString stringWithFormat:@"%@",model.Id];
//        vc.name = [NSString stringWithFormat:@"%@",model.name];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
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
    }
    
    return _tableView;
}

@end
