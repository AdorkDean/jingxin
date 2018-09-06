//
//  VideoListVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/12.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "VideoListVC.h"
#import "VideoListCell.h"
#import "VideoModel.h"
#import "DataPost.h"
#import "PlayerViewController.h"
@interface VideoListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VideoListVC
{
    UIRefreshControl *_refreshControl;
    NSArray *_imageArr;
    UIView * _bottomView;
    NSInteger _page;
    NSMutableArray *_dataArray1;
    NSString * _currentDateStr;
    NSString * _pastDateStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"视频浏览";
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
//    [rightBarItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    _page = 1;
    _dataArray1 = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
    [self getDateStr];
    [self DataRequest1];
}
//-(void)souSuoButtonClickMethod{
//
//}
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
    //统计列表的接口  //192.168.1.199:8080/jingxin/servlet/video?action=searchVideoInfo&callback=?&1=1
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/video"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"searchVideoInfo",@"params":[NSString stringWithFormat:@"{\"titleEQ\":\"%@\",\"stateEQ\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",@"",@"published",@"",@""]};
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
            NSLog(@"视频列表的返回:%@",dic);
            for (NSDictionary *dic in array) {
                VideoModel *model = [[VideoModel alloc] init];
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
    static NSString *cellID = @"VideoListCell";
    VideoListCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(VideoListCell*)[[[NSBundle mainBundle] loadNibNamed:@"VideoListCell" owner:self options:nil]firstObject];
    }
    VideoModel * model;
    if (_dataArray1.count != 0) {
        model = _dataArray1[indexPath.row];
        cell1.model = model;
    }
    return cell1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray1.count != 0) {
        VideoModel * model = _dataArray1[indexPath.row];
        PlayerViewController * playerViewController = [[PlayerViewController alloc] init];
        playerViewController.sptitleid = model.vid;
        NSLog(@"%@",self.navigationController);
        [self.navigationController pushViewController:playerViewController animated:YES];
    }
}

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
@end
