//
//  CPFahuoDuiBiVC.m
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CPFahuoDuiBiVC.h"
#import "BaoBiaoTongJiViewController.h"
#import "FaHuoTongQiChartView.h"
//#import "KeHuFaHuoDuiBiCell.h"
#import "CPFahuoDuiBiCell.h"
#import "FaHuoTongQiModel.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "CustModel.h"
#import "UIViewExt.h"
#import "CPFahuoDuiBiChartVC.h"
#import "CPFahuoDuiBiSearchVC.h"
@interface CPFahuoDuiBiVC ()<UITextFieldDelegate>{
    UIRefreshControl *_refreshControl;
    MBProgressHUD *_HUD;
    NSInteger _page;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSMutableArray* _searchNameArray;
    NSMutableArray* _searchCountArray;
    NSMutableArray* _searchMoneyArray;
    //搜索
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    UIView *_timeView;
    UIButton *_startButton;
    UIButton *_endButton;
    UIButton *_salerButton;
    NSString *_salerId;
    UITextField *_custField;
    NSMutableArray *_dataArray;
    
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _custpage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;

@end

@implementation CPFahuoDuiBiVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品发货同期对比";
    self.navigationItem.rightBarButtonItem = nil;
    
    _DataArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc]init];
    _nameArray = [[NSMutableArray alloc] init];
    _thisYearArray = [[NSMutableArray alloc] init];
    _lastYearArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchNameArray = [[NSMutableArray alloc]init];
    _searchCountArray = [[NSMutableArray alloc]init];
    _searchMoneyArray = [[NSMutableArray alloc]init];
    _page = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _custpage = 1;
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    // Do any additional setup after loading the view from its nib.
    self.KeHuFaHuoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114) style:UITableViewStyleGrouped];
    self.KeHuFaHuoTableView.delegate =self;
    self.KeHuFaHuoTableView.dataSource =self;
    //    _refreshControl = [[UIRefreshControl alloc] init];
    //    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
    //    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    //    [self.KeHuFaHuoTableView addSubview:_refreshControl];
    [self.view addSubview:_KeHuFaHuoTableView];
    //     下拉刷新
    _KeHuFaHuoTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_KeHuFaHuoTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _KeHuFaHuoTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _KeHuFaHuoTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_KeHuFaHuoTableView.mj_footer endRefreshing];
    }];
    
    [self  PageViewDidLoad1];
    [self showBarWithName:@"搜索" addBarWithName:@"排名"];
    
    [self getDateStr];
    [self DataRequest];
    [self DataRequest1];
    [_HUD hide:YES afterDelay:1.0];
    
    
    
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
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
//        [self searchData];
        [_refreshControl endRefreshing];
    }else{
        [_DataArray removeAllObjects];
        _page = 1;
        [self DataRequest];
        [self DataRequest1];
        [_refreshControl endRefreshing];
    }
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


-(void)DataRequest
{
    /*
     report
     tjlx    detail
     mobile    true
     action    custShipsInSameTime
     page    1
     rows    10
     params    {"starttime":"2015-02-05","endtime":"2015-03-05"}
     */
    //客户回款同期对比
    //时间的值还有传
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=productSendTongQiDuiBi"];
    NSDictionary *params = @{@"tjlx":@"detail",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"proidEQ\":\"%@\",\"yeartimeEQ\":\"%@\"}",@"",@"2018"]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array =dic[@"rows"];
            for (NSDictionary *dic  in array) {
                FaHuoTongQiModel *model = [[FaHuoTongQiModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_DataArray addObject:model];
                NSString *str = [dic objectForKey:@"proname"];
                [_nameArray addObject:str];
                NSString *str1 = [dic objectForKey:@"totalcount"];
                [_thisYearArray addObject:str1];
                NSString *str2 = [dic objectForKey:@"uptotalcount"];
                [_lastYearArray addObject:str2];
            }
            [self.KeHuFaHuoTableView reloadData];
            NSLog(@"客户发货同期对比:%@",dic);
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
            
        }
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
    
}
//上拉加载更多
- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
//        [self searchData];
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 15) {
        //        [self upRefresh];
    }
}


-(void)DataRequest1
{
    /*
     report
     tjlx    total
     mobile    true
     action    custShipsInSameTime
     params    {"starttime":"2015-02-05","endtime":"2015-03-05"}
     */
    //去年的 金额的 和今年的 接口的json 解析好好的good
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=productSendTongQiDuiBi&issum=yes"];
    NSDictionary *params = @{@"tjlx":@"total",@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"proidEQ\":\"%@\",\"yeartimeEQ\":\"%@\"}",@"",@"2018"]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count != 0) {
                NSString *lastallreturned =[NSString stringWithFormat:@"%@",array[0][@"uptotalcount"]];
                double last = [lastallreturned doubleValue];
                self.m_quNian.text =[NSString stringWithFormat:@"上年:%.2f",last];
                
                NSString *allreturned =[NSString stringWithFormat:@"%@",array[0][@"totalcount"]];
                double this = [allreturned doubleValue];
                self.m_jinNian.text = [NSString stringWithFormat:@"今年:%.2f",this];
                
            }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}
-(void)PageViewDidLoad1
{
    
    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    biaoTiView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:biaoTiView];
    self.m_jinNian =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, KscreenWidth/2-1, 40)];
    self.m_jinNian.text = [NSString stringWithFormat:@"今年总数量:"];
    self.m_jinNian.textColor =[UIColor blackColor];
    self.m_jinNian.textAlignment = NSTextAlignmentCenter;
    self.m_jinNian.backgroundColor =[UIColor clearColor];
    self.m_jinNian.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.m_jinNian];
    
    UIView * linev = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth/2, 15, 1, 20)];
    linev.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:linev];
    
    self.m_quNian =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 + 1,5, KscreenWidth/2, 40)];
    self.m_quNian.textColor =[UIColor blackColor];
    self.m_quNian.text = [NSString stringWithFormat:@"去年总数量:"];
    self.m_quNian.textAlignment = NSTextAlignmentCenter;
    self.m_quNian.backgroundColor =[UIColor clearColor];
    self.m_quNian.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.m_quNian];
    
}


#pragma mark UITableView DataSource AndDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.salerTableView) {
        return _dataArray.count;
    }else{
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _DataArray.count;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"cell";
    CPFahuoDuiBiCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell =(CPFahuoDuiBiCell*)[[[NSBundle mainBundle]loadNibNamed:@"CPFahuoDuiBiCell" owner:self options:nil]firstObject];
        
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == self.KeHuFaHuoTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.section];
            }
        }else{
            if (_DataArray.count != 0) {
                cell.model = _DataArray[indexPath.section];
            }
        }
        return cell;
        
    }else if (tableView == self.salerTableView){
        if (_dataArray.count!=0) {
            CustModel *model = _dataArray[indexPath.row];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.KeHuFaHuoTableView) {
        CPFahuoDuiBiChartVC *chartView  = [[CPFahuoDuiBiChartVC alloc] init];
        if (_searchFlag == 1) {
            chartView.nameData = @[_searchNameArray[indexPath.section]];
            chartView.thisYearData = @[_searchCountArray[indexPath.section]];
            chartView.lastYearData = @[_searchMoneyArray[indexPath.section]];
        }else{
            chartView.nameData = @[_nameArray[indexPath.section]];
            chartView.thisYearData = @[_thisYearArray[indexPath.section]];
            chartView.lastYearData = @[_lastYearArray[indexPath.section]];
        }
        [self.navigationController pushViewController:chartView animated:YES];
    }else if (tableView == self.salerTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_dataArray.count!=0) {
            CustModel *model = _dataArray[indexPath.row];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerId = model.Id;
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.salerTableView) {
        return 45;
    }else {
        return 160;
        
    }
    
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
#pragma mark - 搜索方法

- (void)search
{

}

- (void)searchDataWithCustid:(NSString *)proid createTime:(NSString *)createTime
{
    /*
     report
     action:"custShipsInSameTime"
     tjlx:"detail"
     page:"1"
     rows:"100"
     params:"{"custidEQ":"5449","departidEQ":"","custnameLIKE":"莱西姜炳光","starttime":"2015-08-12","endtime":"2015-09-12"}"
     */
    NSString *cust = _salerButton.titleLabel.text;
    cust = [self convertNull:cust];
    proid = [self convertNull:proid];
    createTime = [self convertNull:createTime];
    if ([cust isEqualToString:@" "]&&[createTime isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
        [_searchNameArray removeAllObjects];
        [_searchCountArray removeAllObjects];
        [_searchMoneyArray removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=productSendTongQiDuiBi"];
    NSDictionary *params  = @{@"tjlx":@"detail",@"tjlx":@"detail",@"page":[NSString stringWithFormat:@"%ld",(long)_searchPage],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"proidEQ\":\"%@\",\"yeartimeEQ\":\"%@\"}",proid,createTime]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            //            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array =dic[@"rows"];
            NSLog(@"搜索源数据%@",array);
            
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    FaHuoTongQiModel *model = [[FaHuoTongQiModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                    NSString *str = [dic objectForKey:@"custname"];
                    str = [self convertNull:str];
                    [_searchNameArray addObject:str];
                    NSString *str1 = [dic objectForKey:@"totalcount"];
                    str1 = [self convertNull:str1];
                    [_searchCountArray addObject:str1];
                    NSString *str2 = [dic objectForKey:@"uptotalcount"];
                    str2 = [self convertNull:str2];
                    [_searchMoneyArray addObject:str2];
                    
                }
            }
            [self.KeHuFaHuoTableView reloadData];
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"请求失败");
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
    }];
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
}

-(void)getAllWithCustid:(NSString *)proid createTime:(NSString *)createTime
{
    /*
     report
     tjlx    total
     mobile    true
     action    custShipsInSameTime
     params    {"starttime":"2015-02-05","endtime":"2015-03-05"}
     */
    //去年的 金额的 和今年的
    
    NSString *cust = _salerButton.titleLabel.text;
    cust = [self convertNull:cust];
    proid = [self convertNull:proid];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=productSendTongQiDuiBi&issum=yes"];
    NSDictionary *params = @{@"action":@"custShipsInSameTime",@"tjlx":@"total",@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"proidEQ\":\"%@\",\"yeartimeEQ\":\"%@\"}",proid,createTime]};

    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (array.count != 0) {
            NSString *lastallreturned =[NSString stringWithFormat:@"%@",array[0][@"uptotalcount"]];
            double last = [lastallreturned doubleValue];
            self.m_quNian.text =[NSString stringWithFormat:@"上年:%.2f",last];
            
            NSString *allreturned =[NSString stringWithFormat:@"%@",array[0][@"totalcount"]];
            double this = [allreturned doubleValue];
            self.m_jinNian.text = [NSString stringWithFormat:@"今年:%.2f",this];
            
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}
- (void)addNext{
//    if ([_searchView isHidden]) {
//        _searchView.hidden = NO;
//        _backView.hidden = NO;
//        _barHideBtn.hidden = NO;
//        [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
//        [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
//    }
//    else if (![_searchView isHidden])
//    {
//        _searchView.hidden = YES;
//        _backView.hidden = YES;
//        _barHideBtn.hidden = YES;
//    }
    [_searchDateArray removeAllObjects];
    CPFahuoDuiBiSearchVC * vc = [[CPFahuoDuiBiSearchVC alloc]init];
    [vc setBlock:^(NSString *proid, NSString *time) {
        [self searchDataWithCustid:proid createTime:time];
        [self getAllWithCustid:proid createTime:time];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchAction{
    
    FaHuoTongQiChartView *chartView  = [[FaHuoTongQiChartView alloc] init];
    if (_searchFlag == 1) {
        chartView.nameData = _searchNameArray;
        chartView.thisYearData = _searchCountArray;
        chartView.lastYearData = _searchMoneyArray;
    }else{
        chartView.nameData = _nameArray;
        chartView.thisYearData = _thisYearArray;
        chartView.lastYearData = _lastYearArray;
    }
    [self.navigationController pushViewController:chartView animated:YES];
    
}


@end
