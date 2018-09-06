//
//  XiaoShouFahuoVC.m
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "XiaoShouFahuoVC.h"
#import "BaoBiaoTongJiViewController.h"
#import "ChanPinFaHuoChartViewController.h"
#import "XiaoshouFahuoSearchVC.h"
#import "XiaoShouFaHuoACell.h"
#import "ChanPinFaHuoCell.h"
#import "ChanPinFaHuoModel.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "THCPModel.h"
#import "THCpInfoCell.h"
#import "QLChanPinFahuoCell.h"
@interface XiaoShouFahuoVC ()<UITextFieldDelegate>
{
    MBProgressHUD *_HUD;
    UIRefreshControl *_refreshControl;
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
    UITextField *_proField;
    NSMutableArray *_dataArray;
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _propage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation XiaoShouFahuoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售员发货排名";
    self.navigationItem.rightBarButtonItem = nil;
    
    _DataArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    _countArray = [[NSMutableArray alloc] init];
    _moneyArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchNameArray = [[NSMutableArray alloc]init];
    _searchCountArray = [[NSMutableArray alloc]init];
    _searchMoneyArray = [[NSMutableArray alloc]init];
    _dataArray = [NSMutableArray array];
    _page = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _propage = 1;
    // Do any additional setup after loading the view from its nib.
    self.chanPinFaHuoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114) style:UITableViewStyleGrouped];
    self.chanPinFaHuoTableView.delegate = self;
    self.chanPinFaHuoTableView.dataSource = self;
    self.chanPinFaHuoTableView.rowHeight = 150;
    //    _refreshControl = [[UIRefreshControl alloc] init];
    //    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
    //    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    //    [self.chanPinFaHuoTableView addSubview:_refreshControl];
    [self.view addSubview:_chanPinFaHuoTableView];
    //     下拉刷新
    _chanPinFaHuoTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_chanPinFaHuoTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _chanPinFaHuoTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _chanPinFaHuoTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_chanPinFaHuoTableView.mj_footer endRefreshing];
    }];
    
    
    [self PageViewDidLoad];
    [self showBarWithName:@"搜索" addBarWithName:@"排名"];
    //    [self initSearchView];
    [self getDateStr];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    [self DataRequest];
    [self DataRequest1];
    [_HUD removeFromSuperview];
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
     http://182.92.96.58:8005/yrt/servlet/report
     mobile    true
     action    proShipRank
     page    1
     rows    10
     params:"{"pronameEQ":"","protypeidEQ":"","specificationLIKE":"","saletimeGE":"2015-09-14","saletimeLE":"2015-10-14"}"
     */
    
    //产品发货排名
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=salerFaHuoPaiMing"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"params":[NSString stringWithFormat:@"{\"saleridEQ\":\"%@\",\"proidEQ\":\"%@\",\"pronoEQ\":\"%@\",\"specificationLIKE\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",@"",@"",@"",@"",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"源数据%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic  in array) {
                    ChanPinFaHuoModel *model = [[ChanPinFaHuoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_DataArray addObject:model];
                    NSString *str = [dic objectForKey:@"proname"];
                    [_nameArray addObject:str];
                    NSString *str1 = [dic objectForKey:@"totalcount"];
                    [_countArray addObject:str1];
                    NSString *str2= [dic objectForKey:@"totalmoney"];
                    [_moneyArray addObject:str2];
                }
                [self.chanPinFaHuoTableView reloadData];
                [_HUD hide:YES];
                [_HUD removeFromSuperview];
            }
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
- (void)refreshData
{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown) userInfo:nil repeats:NO];
}
- (void)refreshDown{
    if (_searchFlag == 1) {
        _searchPage = 1;
        [_searchDateArray removeAllObjects];
        [_refreshControl endRefreshing];
    }else{
        _page = 1;
        [_DataArray removeAllObjects];
        [self DataRequest];
        [_refreshControl endRefreshing];
    }
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
     mobile    true
     action    proShipRank
     isstat    true
     */
    //总数量和总金额的  数据统计
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=salerFaHuoPaiMing&issum=yes"];
    NSDictionary *params = @{@"mobile":@"true",@"isstat":@"true",@"params":[NSString stringWithFormat:@"{\"saleridEQ\":\"%@\",\"proidEQ\":\"%@\",\"pronoEQ\":\"%@\",\"specificationLIKE\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",@"",@"",@"",@"",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray *array =[NSJSONSerialization  JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count != 0) {
                NSString *str =[NSString stringWithFormat:@"%@",array[0][@"totalcount"]];
                double count = [str doubleValue];
                NSString * stringcount = [NSString stringWithFormat:@"%.2f",count];
                self.zongShuLiang2.text = [NSString stringWithFormat:@"总数量:%@",stringcount];
                NSString *str1 =[NSString stringWithFormat:@"%@",array[0][@"totalmoney"]];
                double money = [str1 doubleValue];
                NSString * stringMoney = [NSString stringWithFormat:@"%.2f",money];
                self.zongJinE2.text = [NSString stringWithFormat:@"总金额:%@",stringMoney];
            }
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}

-(void)PageViewDidLoad
{
    //客户发货排名 下方的view设置 和总数量 总金额的 添加
    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    biaoTiView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:biaoTiView];
    self.zongShuLiang2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, KscreenWidth/2-1, 40)];
    self.zongShuLiang2.text = [NSString stringWithFormat:@"总数量:"];
    self.zongShuLiang2.textColor =[UIColor blackColor];
    self.zongShuLiang2.textAlignment = NSTextAlignmentCenter;
    self.zongShuLiang2.backgroundColor =[UIColor clearColor];
    self.zongShuLiang2.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.zongShuLiang2];
    
    UIView * linev = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth/2, 15, 1, 20)];
    linev.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:linev];
    
    self.zongJinE2 =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 + 1,5, KscreenWidth/2, 40)];
    self.zongJinE2.textColor =[UIColor blackColor];
    self.zongJinE2.text = [NSString stringWithFormat:@"总金额:"];
    self.zongJinE2.textAlignment = NSTextAlignmentCenter;
    self.zongJinE2.backgroundColor =[UIColor clearColor];
    self.zongJinE2.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.zongJinE2];
    /*
     原来版本的布局
     */
    //    UILabel *zongShuLiang =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 40)];
    //    zongShuLiang.text =@"总数量 :";
    //    zongShuLiang.textColor =[UIColor blackColor];
    //    zongShuLiang.backgroundColor =[UIColor clearColor];
    //    zongShuLiang.font =[UIFont systemFontOfSize:14];
    //    [self.view addSubview:zongShuLiang];
    //    self.zongShuLiang2 =[[UILabel alloc]initWithFrame:CGRectMake(65, 5, KscreenWidth/2 - 45, 40)];
    //    self.zongShuLiang2.textColor =[UIColor blackColor];
    //    self.zongShuLiang2.backgroundColor =[UIColor clearColor];
    //    self.zongShuLiang2.font =[UIFont systemFontOfSize:14];
    //    [self.view addSubview:self.zongShuLiang2];
    //
    //    UILabel *zongJinE =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 +5, 5, 60, 40)];
    //    zongJinE.text =@"总金额 :";
    //    zongJinE.textColor =[UIColor blackColor];
    //    zongJinE.backgroundColor =[UIColor clearColor];
    //    zongJinE.font =[UIFont systemFontOfSize:14];
    //    [self.view addSubview:zongJinE];
    //    self.zongJinE2 =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 + 65,5, KscreenWidth/2, 40)];
    //    self.zongJinE2.textColor =[UIColor blackColor];
    //    self.zongJinE2.backgroundColor =[UIColor clearColor];
    //    self.zongJinE2.font =[UIFont systemFontOfSize:14];
    //    [self.view addSubview:self.zongJinE2];
    
    
}
#pragma mark UITabLeView Delegate And DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (tableView == self.proTableView) {
    //        return _dataArray.count;
    //    }else{
    //        if (_searchFlag == 1) {
    //            return _searchDateArray.count;
    //        }else{
    //            return _DataArray.count;
    //        }
    //    }
    if (tableView == self.proTableView) {
        return 1;
    }else{
        if (_searchFlag == 1) {
            return 1;
        }else{
            return 1;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.proTableView) {
        return _dataArray.count;
    }else{
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _DataArray.count;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"XiaoShouFaHuoACell";
    XiaoShouFaHuoACell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil)
    {
        cell =(XiaoShouFaHuoACell*)[[[NSBundle mainBundle]loadNibNamed:@"XiaoShouFaHuoACell" owner:self options:nil]firstObject];
    }
    THCpInfoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = (THCpInfoCell *) [[[NSBundle mainBundle] loadNibNamed:@"THCpInfoCell" owner:self options:nil]firstObject];
    }
    if (tableView == self.chanPinFaHuoTableView ) {
        if (_searchFlag == 1) {
            if(_searchDateArray.count != 0){
                cell.model = _searchDateArray[indexPath.section];
            }
        }else{
            if(_DataArray.count != 0){
                cell.model = _DataArray[indexPath.section];
            }
        }
        
        return cell;
    }else if (tableView == self.proTableView){
        if (_dataArray.count!=0) {
            cell1.model = _dataArray[indexPath.section];
        }
        return cell1;
    }
    
    
    
    return cell;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.chanPinFaHuoTableView) {
        ChanPinFaHuoChartViewController *fahuoChartVC = [[ChanPinFaHuoChartViewController alloc] init];
        if (_searchFlag == 1) {
            
            fahuoChartVC.nameData = @[_searchNameArray[indexPath.section]];
            fahuoChartVC.countData = @[_searchCountArray[indexPath.section]];
            fahuoChartVC.moneyData = @[_searchMoneyArray[indexPath.section]];
        }else{
            fahuoChartVC.nameData = @[_nameArray[indexPath.section]];
            fahuoChartVC.countData = @[_countArray[indexPath.section]];
            fahuoChartVC.moneyData = @[_moneyArray[indexPath.section]];
            
        }
        [self.navigationController pushViewController:fahuoChartVC animated:YES];
    }else if (tableView == self.proTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_dataArray.count!=0) {
            THCPModel *model = _dataArray[indexPath.section];
            [_salerButton setTitle:model.proname forState:UIControlStateNormal];
        }
    }
    
    
}
- (void)proRequest{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn?action=getShipments"];
    NSDictionary *params = @{@"action":@"getShipments",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"table":@"fhxx"};
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"退货的产品名称%@",array);
        for (NSDictionary *dic in array) {
            THCPModel *model = [[THCPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.proTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}
- (void)closePop
{
    if ([self keyboardDid]) {
        [_proField resignFirstResponder];
        
    }else{
        _salerButton.userInteractionEnabled = YES;
        
        [self.m_keHuPopView removeFromSuperview];
    }
    
}

- (void)startAction{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-270, KscreenWidth, 270)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 240)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
//监听datePicker值发生变化
- (void)dateChange:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_startButton setTitle:dateString forState:UIControlStateNormal];
}

- (void)closetime
{
    [_timeView removeFromSuperview];
}

- (void)endAction{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-270, KscreenWidth, 270)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 240)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}

//监听datePicker值发生变化
- (void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_endButton setTitle:dateString forState:UIControlStateNormal];
}

#pragma mark - 搜索方法

- (void)search
{
    
}

- (void)searchDataWithProid:(NSString *)proid StartTime:(NSString *)start EndTime:(NSString *)end saleid:(NSString *)saleid
{
    /*
     report
     action:"proShipRank"
     tjlx:"detail"
     page:"1"
     rows:"100"
     params:"{"pronameLIKE":"太奇止泻SD组合","protypeidEQ":"","specificationLIKE":"","saletimeGE":"2015-08-12","saletimeLE":"2015-09-12"}"
     */
    proid = [self convertNull:proid];
    saleid = [self convertNull:saleid];
    NSString *st = start;
    st = [self convertNull:st];
    NSString *ed = end;
    ed = [self convertNull: ed];
    if([st isEqualToString:@" "]&&[ed isEqualToString:@" "]){
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=salerFaHuoPaiMing"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"params":[NSString stringWithFormat:@"{\"saleridEQ\":\"%@\",\"proidEQ\":\"%@\",\"pronoEQ\":\"%@\",\"specificationLIKE\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",saleid,proid,@"",@"",start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"源数据%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic  in array) {
                    ChanPinFaHuoModel *model = [[ChanPinFaHuoModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                    NSString *str = [dic objectForKey:@"proname"];
                    str = [self convertNull:str];
                    [_searchNameArray addObject:str];
                    NSString *str1 = [dic objectForKey:@"totalcount"];
                    str1 = [self convertNull:str1];
                    [_searchCountArray addObject:str1];
                    NSString *str2= [dic objectForKey:@"totalmoney"];
                    str2 = [self convertNull:str2];
                    [_searchMoneyArray addObject:str2];
                }
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                [self searchTotalDataWithProid:proid StartTime:start EndTime:end saleid:saleid];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [self.chanPinFaHuoTableView reloadData];
                });
            });
            
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    //    _searchView.hidden = YES;
    //    _backView.hidden = YES;
    //    _barHideBtn.hidden = YES;
}
- (void)searchTotalDataWithProid:(NSString *)proid StartTime:(NSString *)start EndTime:(NSString *)end saleid:(NSString *)saleid
{
    /*
     report
     mobile    true
     action    proShipRank
     isstat    true
     */
    //总数量和总金额的  数据统计
    proid = [self convertNull:proid];
    saleid = [self convertNull:saleid];
    NSString *st = start;
    st = [self convertNull:st];
    NSString *ed = end;
    ed = [self convertNull: ed];
    //    NSString *cust = _salerButton.titleLabel.text;
    //    cust = [self convertNull:cust];
    //    _salerId = [self convertNull:_salerId];
    //    NSString *start = _startButton.titleLabel.text;
    //    start = [self convertNull:start];
    //    NSString *end = _endButton.titleLabel.text;
    //    end = [self convertNull: end];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report?action=salerFaHuoPaiMing&issum=yes"];
    NSDictionary *params = @{@"mobile":@"true",@"isstat":@"true",@"params":[NSString stringWithFormat:@"{\"saleridEQ\":\"%@\",\"proidEQ\":\"%@\",\"pronoEQ\":\"%@\",\"specificationLIKE\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",saleid,proid,@"",@"",start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray *array =[NSJSONSerialization  JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count != 0) {
                NSString *str =[NSString stringWithFormat:@"%@",array[0][@"totalcount"]];
                double count = [str doubleValue];
                NSString * countstring = [NSString stringWithFormat:@"%.2f",count];
                self.zongShuLiang2.text = [NSString stringWithFormat:@"总数量:%@",countstring];
                NSString *str1 =[NSString stringWithFormat:@"%@",array[0][@"totalmoney"]];
                double money = [str1 doubleValue];
                NSString * stringMoney = [NSString stringWithFormat:@"%.2f",money];
                self.zongJinE2.text = [NSString stringWithFormat:@"总金额:%@",stringMoney];
                
            }
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}

- (void)chongZhi
{
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
    [_startButton setTitle:@" " forState:UIControlStateNormal];
    [_endButton setTitle:@" " forState:UIControlStateNormal];
    
}

- (void)addNext{
    [_searchDateArray removeAllObjects];
    XiaoshouFahuoSearchVC * vc = [[XiaoshouFahuoSearchVC alloc]init];
    [vc setBlock:^(NSString *proid, NSString *saleid, NSString *start, NSString *end, NSString *guige, NSString *prono) {
        [self searchDataWithProid:proid StartTime:start EndTime:end saleid:saleid];
        [self searchTotalDataWithProid:proid StartTime:start EndTime:end saleid:saleid];
    }];
    [self.navigationController pushViewController:vc animated:YES];
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
    
}
- (void)searchAction{
    
    ChanPinFaHuoChartViewController *fahuoChartVC = [[ChanPinFaHuoChartViewController alloc] init];
    if (_searchFlag == 1) {
        fahuoChartVC.nameData = _searchNameArray;
        fahuoChartVC.countData = _searchCountArray;
        fahuoChartVC.moneyData = _searchMoneyArray;
    }else{
        fahuoChartVC.nameData = _nameArray;
        fahuoChartVC.countData = _countArray;
        fahuoChartVC.moneyData = _moneyArray;
    }
    [self.navigationController pushViewController:fahuoChartVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
