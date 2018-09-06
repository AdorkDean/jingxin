//
//  TongjiVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/6.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "TongjiVC.h"
#import "LXRizhiManagerVC.h"
#import "ScanReportVC.h"
#import "TNCustomSegment.h"
#import "DataPost.h"
#import "RZshangbaoModel.h"
#import "LXTongjiListCell.h"
#import "TongjiModel.h"
#import "TongjiSelectVC.h"
#import "TongjiSearchVC.h"
@interface TongjiVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TongjiVC
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
    self.title = @"统计";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    _page = 1;
    _imageArr = @[@"xiehui",@"xiezhi",@"lantongji"];
    _dataArray1 = [[NSMutableArray alloc]init];
    [self getDateStr];
    [self createBottomView];
    [self DataRequest1];
}
-(void)souSuoButtonClickMethod{
    TongjiSearchVC * vc = [[TongjiSearchVC alloc]init];
    [vc setBlock:^(NSString *proid,NSString *proname, NSString *start, NSString *end) {
        [self searchDataWithProid:proid StartTime:start EndTime:end ProName:proname];
        
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchDataWithProid:(NSString *)proid StartTime:(NSString *)start EndTime:(NSString *)end ProName:(NSString *)proname{
    //统计列表的接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getCountDepart",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"isstop\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",proid,@"0",start,end]};
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
                TongjiModel *model = [[TongjiModel alloc] init];
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
    //统计列表的接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getCountDepart",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"isstop\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",@"",@"0",_pastDateStr,_currentDateStr]};
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
                TongjiModel *model = [[TongjiModel alloc] init];
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
        ScanReportVC * vc = [[ScanReportVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"LXTongjiListCell";
    LXTongjiListCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(LXTongjiListCell*)[[[NSBundle mainBundle] loadNibNamed:@"LXTongjiListCell" owner:self options:nil]firstObject];
    }
    TongjiModel * model;
    if (_dataArray1.count != 0) {
        model = _dataArray1[indexPath.row];
        cell1.model = model;
    }
    cell1.sacnBtn.layer.cornerRadius = 3.f;
    cell1.sacnBtn.layer.borderWidth = 1.f;
    cell1.sacnBtn.layer.borderColor = ssRGBHex(0x03a9f4).CGColor;
    cell1.sacnBtn.layer.masksToBounds = YES;
    [cell1 setScanBtnBlock:^{
        TongjiSelectVC * vc = [[TongjiSelectVC alloc]init];
        vc.idString = [NSString stringWithFormat:@"%@",model.Id];
        vc.name = [NSString stringWithFormat:@"%@",model.name];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray1.count != 0) {
        TongjiModel * model = _dataArray1[indexPath.row];
        TongjiSelectVC * vc = [[TongjiSelectVC alloc]init];
        vc.idString = [NSString stringWithFormat:@"%@",model.Id];
        vc.name = [NSString stringWithFormat:@"%@",model.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)backButtonAction:(UIButton*)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight-64-50) style:UITableViewStylePlain];
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
