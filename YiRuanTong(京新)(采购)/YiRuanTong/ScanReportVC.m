//
//  ScanReportVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/6.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ScanReportVC.h"
#import "LXRizhiManagerVC.h"
#import "TongjiVC.h"
#import "TNCustomSegment.h"
#import "DataPost.h"
#import "RZshangbaoModel.h"
#import "RZLiuLanCell.h"
#import "RZShenPiCell.h"
#import "LiuLanMessageVC.h"
#import "ShenPiMessageVC.h"
#import "ScanReportSearchVC.h"
@interface ScanReportVC ()<UITableViewDelegate,UITableViewDataSource,TNCustomSegmentDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ScanReportVC
{
    UIRefreshControl *_refreshControl;
    UIView * _bottomView;
    NSInteger _page;
    NSArray *_dataArr;
    NSArray *_imageArr;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSString * _currentDateStr;
    NSString * _pastDateStr;
    NSInteger _flag;

    NSString * _tproname;
    NSString * _tareaid;
    NSString * _tstart;
    NSString * _tend;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"看日志";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    NSArray *items = @[@"浏览",@"批复"];
    _dataArr = @[@"写日志",@"看日志",@"统计"];
    _imageArr = @[@"xiehui",@"lanzhi",@"tongji"];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _page = 1;
    [self createBottomView];
    TNCustomSegment *segment = [[TNCustomSegment alloc] initWithItems:items withFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 20, 40) withSelectedColor:nil withNormolColor:nil withFont:nil];
    segment.delegate = self;
    segment.selectedIndex = 0;
    [self.view addSubview:segment];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reFresh) name:@"newDailyreport" object:nil];
//    [self DataRequest];
//    [self DataRequest1];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self DataRequest];
    [self DataRequest1];
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
    if (self.selectIndex == 0) {
        [_dataArray1 removeAllObjects];
        _page = 1;
        [self DataRequest];
        [_refreshControl endRefreshing];
    }else{
        [_dataArray2 removeAllObjects];
        _page = 1;
        [self DataRequest1];
        [_refreshControl endRefreshing];
    }
    
}
//上拉加载更多
- (void)upRefresh
{
    if (self.selectIndex == 0) {
        if (_flag == 1) {
            _page++;
            [self searchLiulanWithproname:_tproname areaname:@"" areaid:_tareaid start:_tstart end:_tend];
        }else{
            
            _page++;
            [self DataRequest];
        }
    }else{
        if (_flag == 1) {
            _page++;
            [self searchShenpiWithproname:_tproname areaname:@"" areaid:_tareaid start:_tstart end:_tend];
        }else{
            
            _page++;
            [self DataRequest1];
        }
    }
    
}
-(void)souSuoButtonClickMethod{
    
    ScanReportSearchVC * vc = [[ScanReportSearchVC alloc]init];
    vc.index = self.selectIndex;
    [vc setBlock:^(NSString *proname,NSString *areaname,NSString *areaid,NSString *start,NSString *end) {
        _flag = 1;
        _page = 1;
        if (self.selectIndex == 0) {
            [self searchLiulanWithproname:proname areaname:areaname areaid:areaid start:start end:end];
            
        }else{
            [self searchShenpiWithproname:proname areaname:areaname areaid:areaid start:start end:end];

        }
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchLiulanWithproname:(NSString *)proname areaname:(NSString *)areaname areaid:(NSString *)areaid start:(NSString *)start end:(NSString *)end
{
    _tproname = proname;
    _tareaid = areaid;
    _tstart = start;
    _tend = end;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeansSelf",@"params":[NSString stringWithFormat:@"{\"creatorLIKE\":\"%@\",\"reporttypeidEQ\":\"%@\",\"isreplyEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",proname,areaid,@"",start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page == 1) {
            [_dataArray1 removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *array = dic[@"rows"];
            NSLog(@"日志浏览%@",dic);
            for (NSDictionary *dic in array) {
                RZshangbaoModel *model = [[RZshangbaoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
            [_tableView reloadData];
        }
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
- (void)searchShenpiWithproname:(NSString *)proname areaname:(NSString *)areaname areaid:(NSString *)areaid start:(NSString *)start end:(NSString *)end
{
    _tproname = proname;
    _tareaid = areaid;
    _tstart = start;
    _tend = end;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeansDepart",@"sort":@"createtime",@"order":@"desc",@"allflag":@"1",@"params":[NSString stringWithFormat:@"{\"creatorLIKE\":\"%@\",\"reporttypeidEQ\":\"%@\",\"isreplyEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",proname,areaid,@"0",start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page == 1) {
            [_dataArray2 removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *array = dic[@"rows"];
            NSLog(@"日志浏览%@",dic);
            for (NSDictionary *dic in array) {
                RZshangbaoModel *model = [[RZshangbaoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
            [_tableView reloadData];
        }
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
-(void)createBottomView{

    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-64-50, KscreenWidth, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [self addButtonS];
    [self.view addSubview:self.tableView];
    
    
}
-(void)addButtonS
{
    for (int i = 0 ; i < 3; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        
        // 圆角按钮
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [aBt setImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        [aBt addTarget:self action:@selector(jumpPageAction:) forControlEvents:UIControlEventTouchUpInside];
        aBt.tag = i+1000;
        [_bottomView addSubview:aBt];
    }
}
-(void)jumpPageAction:(UIButton *)sender{
    if (sender.tag == 1000) {
        LXRizhiManagerVC * vc = [[LXRizhiManagerVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){
        
    }else{
        
        TongjiVC * vc = [[TongjiVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 日志浏览审批数据
- (void)DataRequest
{
    /*
     action:"getBeansSelf"
     sort:"createtime"
     order:"desc"
     allflag:"1"
     page:"1"
     rows:"20"
     params:"{"reporttypeidEQ":"","isreplyEQ":"","createtimeGE":"2015-07-27","createtimeLE":"2015-08-27"}"
     */
    //日志上报列表的浏览接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeansSelf",@"table":@"rzsb",@"allflag":@"1"};
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
            NSLog(@"日志浏览%@",dic);
            for (NSDictionary *dic in array) {
                RZshangbaoModel *model = [[RZshangbaoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
            [_tableView reloadData];
        }
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

- (void)DataRequest1
{
    /*批复列表
     http://182.92.96.58:8005/yrt/servlet/dailyreport
     rows    10
     mobile    true
     page    1
     action    getBeansDepart
     params    {"isreplyEQ":0}
     table    rzsb
     */
    //日志上报列表审批的接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeansDepart",@"allflag":@"1",@"table":@"rzsb",@"params":@"{\"isreplyEQ\":\"0\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        [_dataArray2 removeAllObjects];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"日志批复列表的返回:%@",dic);
            for (NSDictionary *dic in array) {
                RZshangbaoModel *model = [[RZshangbaoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
//            [_tableView reloadData];
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
    
    if (self.selectIndex == 0) {
        return _dataArray1.count;
    }else{
        return _dataArray2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 0) {
        
        static NSString *cellID = @"cell";
        RZLiuLanCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell =(RZLiuLanCell *) [[[NSBundle mainBundle] loadNibNamed:@"RZLiuLanCell" owner:self options:nil]firstObject];
        }
        if (_dataArray1.count != 0) {
            cell.model = _dataArray1[indexPath.row];
        }
        
        return cell;
    }else{
        static NSString *cellID = @"cell";
        RZShenPiCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell1 == nil) {
            cell1 =(RZShenPiCell*)[[[NSBundle mainBundle] loadNibNamed:@"RZShenPiCell" owner:self options:nil]firstObject];
        }
        if (_dataArray2.count != 0) {
            cell1.model = _dataArray2[indexPath.row];
        }
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 0) {
        LiuLanMessageVC *liuLanMessage = [[LiuLanMessageVC alloc] init];
        RZshangbaoModel *model = [_dataArray1 objectAtIndex:indexPath.row];
        NSString * idstr = [NSString stringWithFormat:@"%@",model.Id];
        liuLanMessage.idEQ = idstr;
        liuLanMessage.model = model;
        [self.navigationController pushViewController:liuLanMessage animated:YES];
    }else{
        ShenPiMessageVC *spMessageVC = [[ShenPiMessageVC alloc] init];
        RZshangbaoModel *model = [_dataArray2 objectAtIndex:indexPath.row];
        NSString * idstr = [NSString stringWithFormat:@"%@",model.Id];
        spMessageVC.idEQ = idstr;
        spMessageVC.model = model;
        [self.navigationController pushViewController:spMessageVC animated:YES];
    }
}
#pragma mark - TNCustomsegmentDelegate
- (void)segment:(TNCustomSegment *)segment didSelectedIndex:(NSInteger)selectIndex{
    
    self.selectIndex = selectIndex;
    
    [self.tableView reloadData];
    
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40,KscreenWidth, KscreenHeight-64-50-40) style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
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
- (void)backButtonAction:(UIButton*)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
