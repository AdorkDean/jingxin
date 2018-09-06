//
//  KHCPXiaoShouVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "KHCPXiaoShouVC.h"
#import "KHCPXiaoShouChart.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustModel.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CustSaleModel.h"
#import "CustSaleCell.h"
#import "THCPModel.h"
#import "THCpInfoCell.h"
#import "QLXiaoShouHuiZongCell.h"
#import "KHCPXiaoShouSearchVC.h"
@interface KHCPXiaoShouVC ()<UITextFieldDelegate>{
    
    MBProgressHUD *_HUD;
    NSInteger _page;
    UIRefreshControl *_refreshControl;
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
    UIButton *_proButton;
    NSString *_salerId;
    UITextField *_custField;
    UITextField *_proField;
    NSMutableArray *_dataArray;
    NSMutableArray *_proArray;
    NSString *_proId;
    
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _custpage;
    NSInteger _propage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;


@end

@implementation KHCPXiaoShouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户产品销售额汇总";
    self.navigationItem.rightBarButtonItem = nil;
    
    _faHuoData = [[NSMutableArray alloc] init];
    _faHuoShuData = [NSMutableArray array];
    _faHuoJinEData = [NSMutableArray array];
    _faHuoRenData = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchNameArray = [[NSMutableArray alloc]init];
    _searchCountArray = [[NSMutableArray alloc]init];
    _searchMoneyArray = [[NSMutableArray alloc]init];
    _proArray = [[NSMutableArray alloc]init];
    _page = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _custpage = 1;
    _propage = 1;
     [self initTableView];
    [self PageViewDidLoad];
    [self showBarWithName:@"搜索" addBarWithName:@"排名"];
//    [self initSearchView];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    [self getDateStr];
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

- (void)DataRequest
{
    /*
     
     tjlx	detail
     action:"custProSales"
     page	1
     rows	20
     params:"{"custnameLIKE":"","proid":"","starttime":"2015-08-28","endtime":"2015-09-28"}"
     */
    //客户发货排名
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params  = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"custProSales",@"tjlx":@"detail",@"params":[NSString stringWithFormat:@"{\"starttime\":\"%@\",\"endtime\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户产品销售总额%@",dic);
        if (array.count != 0) {
            
            for (NSDictionary *dic in array) {
                CustSaleModel *model = [[CustSaleModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_faHuoData addObject:model];
                NSString *str = [dic objectForKey:@"allcount"];
                NSString *str1 = [dic objectForKey:@"allmoney"];
                NSString *str2 = [dic objectForKey:@"custname"];
                [_faHuoShuData addObject:str];
                [_faHuoJinEData addObject:str1];
                [_faHuoRenData addObject:str2];
            }
            [self.CustSaleTableView reloadData];
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
        
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
    }];
    
}
//下拉刷新
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
        [self searchData];
    }else{
        [_faHuoData removeAllObjects];
        _page = 1;
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
        [self searchData];
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



- (void)DataRequest1
{
    /*
     tjlx	total
     action:"custProSales"
     */
    //总数量和总金额的
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"custProSales",@"tjlx":@"total",@"params":[NSString stringWithFormat:@"{\"starttime\":\"%@\",\"endtime\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *array =[NSJSONSerialization  JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (array.count != 0) {
            
            NSString *str = [NSString stringWithFormat:@"%@",array[0][@"allsendmoney"]];
            double money = [str doubleValue];
            self.zongJinE2.text = [NSString stringWithFormat:@"总金额:%.2f",money];
        }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}
-(void)PageViewDidLoad
{
    //产品销售区域分析 下方的view的设置 总数量和 总金额的添加
    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    biaoTiView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:biaoTiView];
    
//    self.zongShuLiang2 =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 + 1,5, KscreenWidth/2, 40)];
//    self.zongShuLiang2.text = [NSString stringWithFormat:@"总数量:"];
//    self.zongShuLiang2.textColor =[UIColor blackColor];
//    self.zongShuLiang2.textAlignment = NSTextAlignmentCenter;
//    self.zongShuLiang2.backgroundColor =[UIColor clearColor];
//    self.zongShuLiang2.font =[UIFont systemFontOfSize:14];
//    [self.view addSubview:self.zongShuLiang2];
    
    UIView * linev = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth/2, 15, 1, 20)];
    linev.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:linev];
    
    self.zongJinE2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, KscreenWidth/2-1, 40)];
    self.zongJinE2.textColor =[UIColor blackColor];
    self.zongJinE2.text = [NSString stringWithFormat:@"总金额:"];
    self.zongJinE2.textAlignment = NSTextAlignmentCenter;
    self.zongJinE2.backgroundColor =[UIColor clearColor];
    self.zongJinE2.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.zongJinE2];
}
- (void)initTableView{
    
    self.CustSaleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114) style:UITableViewStyleGrouped];
    self.CustSaleTableView.delegate = self;
    self.CustSaleTableView.dataSource = self;
    self.CustSaleTableView.rowHeight = 150;
    //    _refreshControl = [[UIRefreshControl alloc] init];
    //    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
    //    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    //    [self.chanPinTableView addSubview:_refreshControl];
    [self.view addSubview:_CustSaleTableView];
    //     下拉刷新
    _CustSaleTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_CustSaleTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _CustSaleTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _CustSaleTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_CustSaleTableView.mj_footer endRefreshing];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView DataSource AndDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_searchFlag == 1) {
        return _searchDateArray.count;
    }else{
        return _faHuoData.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"QLXiaoShouHuiZongCell";
    QLXiaoShouHuiZongCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil)
    {
        cell =(QLXiaoShouHuiZongCell*)[[[NSBundle mainBundle]loadNibNamed:@"QLXiaoShouHuiZongCell" owner:self options:nil]firstObject];
    }
    
    
    if (tableView == self.CustSaleTableView ) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.section];
            }
        }else{
            if(_faHuoData.count != 0){
                cell.model = _faHuoData[indexPath.section];
            }
            return cell;
        }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.CustSaleTableView ) {
        
        KHCPXiaoShouChart *chartVC = [[KHCPXiaoShouChart alloc] init];
        if (_searchFlag == 1) {
            chartVC.countData = @[_searchNameArray[indexPath.row]];
            chartVC.moneyData = @[_searchCountArray[indexPath.row]];
            chartVC.nameData = @[_searchMoneyArray[indexPath.row]];
        }else{
            chartVC.countData = @[_faHuoShuData[indexPath.row]];
            chartVC.moneyData = @[_faHuoJinEData[indexPath.row]];
            chartVC.nameData = @[_faHuoRenData[indexPath.row]];
        }
        
        [self.navigationController pushViewController:chartVC animated:YES];
    }
    
    
//    if (tableView == self.salerTableView) {
//        [self.m_keHuPopView removeFromSuperview];
//        if (_dataArray.count!=0) {
//            CustModel *model = _dataArray[indexPath.row];
//            [_salerButton setTitle:model.name forState:UIControlStateNormal];
//            _salerId = model.Id;
//        }
//        
//    }else if(tableView == self.CustSaleTableView){
//        KHCPXiaoShouChart *chartVC = [[KHCPXiaoShouChart alloc] init];
//        if (_searchFlag == 1) {
//            chartVC.countData = @[_searchNameArray[indexPath.row]];
//            chartVC.moneyData = @[_searchCountArray[indexPath.row]];
//            chartVC.nameData = @[_searchMoneyArray[indexPath.row]];
//        }else{
//            chartVC.countData = @[_faHuoShuData[indexPath.row]];
//            chartVC.moneyData = @[_faHuoJinEData[indexPath.row]];
//            chartVC.nameData = @[_faHuoRenData[indexPath.row]];
//        }
//          
//        [self.navigationController pushViewController:chartVC animated:YES];
//    }else if (tableView == self.proTableView) {
//        [self.m_keHuPopView removeFromSuperview];
//        if (_proArray.count!=0) {
//            THCPModel *model = _proArray[indexPath.row];
//            [_proButton setTitle:model.proname forState:UIControlStateNormal];
//            _proId = model.Id;
//        }
//    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
    
}

#pragma mark - 搜索页面方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
}
//- (void)salerAction{
//    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
////    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
//    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    //
//    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
//    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
//    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
//    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
//    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
//    //
//    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
//    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.layer.masksToBounds = YES;
//    bgView.layer.cornerRadius = 5;
//    [self.m_keHuPopView addSubview:bgView];
//    //
////    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
//    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
//    _custField.backgroundColor = [UIColor whiteColor];
//    _custField.delegate = self;
//    _custField.tag =  101;
//    _custField.placeholder = @"名称关键字";
////    _custField.borderStyle = UITextBorderStyleRoundedRect;
//    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
//    line2.backgroundColor=[UIColor lightGrayColor];
//    [_custField addSubview:line2];
//    _custField.font = [UIFont systemFontOfSize:13];
////    [self.m_keHuPopView addSubview:_custField];
//    [bgView addSubview:_custField];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    btn.frame = CGRectMake(_custField.right, _custField.top, 60, _custField.height);
//    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//    [btn.layer setBorderWidth:0.5]; //边框宽度
//    [btn addTarget:self action:@selector(searchcust) forControlEvents:UIControlEventTouchUpInside];//getName
////    [self.m_keHuPopView addSubview:btn];
//    [bgView addSubview:btn];
//
//    if (self.salerTableView == nil) {
////        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
//        self.salerTableView.backgroundColor = [UIColor whiteColor];
//    }
//    self.salerTableView.dataSource = self;
//    self.salerTableView.delegate = self;
//    self.salerTableView.tag = 10;
//    self.salerTableView.rowHeight = 45;
//    [bgView addSubview:self.salerTableView];
////    [self.m_keHuPopView addSubview:self.salerTableView];
////    [self.view addSubview:self.m_keHuPopView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
////    [self nameRequest];
//    //     下拉刷新
//    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _custpage = 1;
//        [self searchcust];
//        // 结束刷新
//        [self.salerTableView.mj_header endRefreshing];
//
//    }];
//
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
//    // 上拉刷新
//    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        _custpage ++ ;
//        [self searchcust];
//        [self.salerTableView.mj_footer endRefreshing];
//
//    }];
//    _custpage = 1;
//    [self searchcust];
//
//}


//#pragma mark -  pro
//- (void)proAction{
//    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
////    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
//    //
//    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    //
//    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
//    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
//    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
//    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
//    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
//    //
//    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
//    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.layer.masksToBounds = YES;
//    bgView.layer.cornerRadius = 5;
//    [self.m_keHuPopView addSubview:bgView];
//    //
////    _proField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
//    _proField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
//    _proField.backgroundColor = [UIColor whiteColor];
//    _proField.delegate = self;
//    _proField.tag =  102;
//    _proField.placeholder = @"名称关键字";
////    _proField.borderStyle = UITextBorderStyleRoundedRect;
//    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_proField.height-1,_proField.width, 1)];
//    line2.backgroundColor=[UIColor lightGrayColor];
//    [_proField addSubview:line2];
//    _proField.font = [UIFont systemFontOfSize:13];
////    [self.m_keHuPopView addSubview:_proField];
//    [bgView addSubview:_proField];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    btn.frame = CGRectMake(_proField.right, _proField.top, 60, _proField.height);
//    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//    [btn.layer setBorderWidth:0.5]; //边框宽度
//    [btn addTarget:self action:@selector(searchpro) forControlEvents:UIControlEventTouchUpInside];//getProName
////    [self.m_keHuPopView addSubview:btn];
//    [bgView addSubview:btn];
//    
//    if (self.proTableView == nil) {
////        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-154) style:UITableViewStylePlain];
//        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _proField.bottom+5,bgView.width-40, bgView.height - _proField.bottom - 5) style:UITableViewStylePlain];
//        self.proTableView.backgroundColor = [UIColor whiteColor];
//    }
//    self.proTableView.dataSource = self;
//    self.proTableView.delegate = self;
//    self.proTableView.rowHeight = 80;
//    [bgView addSubview:self.proTableView];
////    [self.m_keHuPopView addSubview:self.proTableView];
////    [self.view addSubview:self.m_keHuPopView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    //     下拉刷新
//    self.proTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _propage = 1;
//        [self searchpro];
//        // 结束刷新
//        [self.proTableView.mj_header endRefreshing];
//        
//    }];
//    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.proTableView.mj_header.automaticallyChangeAlpha = YES;
//    // 上拉刷新
//    self.proTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        _propage ++ ;
//        [self searchpro];
//        [self.proTableView.mj_footer endRefreshing];
//        
//    }];
//    _propage = 1;
//    [self searchpro];
//
////    [self proRequest];
//}
//- (void)getProName{
//    
//    NSString *pro = _proField.text;
//    pro = [self convertNull:pro];
//    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
//    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",pro]};
//    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"产品数据%@",array);
//        _proArray = [NSMutableArray array];
//        for (NSDictionary *dic in array) {
//            CustModel *model = [[CustModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_proArray addObject:model];
//        }
//        [self.salerTableView reloadData];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"产品加载失败");
//    }];
//    
//    
//    
//}
//- (void)proRequest{
//    
//    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
//    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
//    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"产品数据%@",array);
//        _proArray = [NSMutableArray array];
//        for (NSDictionary *dic in array) {
//            CustModel *model = [[CustModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_proArray addObject:model];
//        }
//        [self.salerTableView reloadData];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"产品加载失败");
//    }];
//    
//    
//}
//
//- (void)searchpro{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
//    NSString *proName = _proField.text;
//    proName = [self convertNull:proName];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
//    NSDictionary *params = @{@"action":@"getMBProduct",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"table":@"cpxx",@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\"}",proName]};
//    if (_propage == 1) {
//        [_proArray removeAllObjects];
//    }
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        if([[dic allKeys] containsObject:@"rows"])
//            
//        {
//            NSArray *array = dic[@"rows"];
//            NSLog(@"新的产品接口%@",array);
//            if (array.count!=0) {
//                for (NSDictionary *dic in array) {
//                    THCPModel *model = [[THCPModel alloc] init];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [_proArray addObject:model];
//                }
//                [self.proTableView reloadData];
//            }
//            
//        }
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"加载失败");
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    }];
//}



- (void)closePop
{
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
        [_proField resignFirstResponder];
    }else{
        _salerButton.userInteractionEnabled = YES;
        
        [self.m_keHuPopView removeFromSuperview];
    }
}


#pragma mark - 搜索方法

- (void)search
{
//    [self searchData];
//    [self searchTotalData];
}

- (void)searchData
{
    /*
     
     tjlx	detail
     action:"custProSales"
     page	1
     rows	20
     params:"{"custnameLIKE":"","proid":"","starttime":"2015-08-28","endtime":"2015-09-28"}"
     */
    //客户发货排名
//    NSString *cust = _salerButton.titleLabel.text;
//    cust = [self convertNull:cust];
//    _salerId = [self convertNull:_salerId];
//    NSString *pro = _proButton.titleLabel.text;
//    pro =[self convertNull:pro];
//    _proId = [self convertNull:_proId];
//    NSString *start = _startButton.titleLabel.text;
//    start = [self convertNull:start];
//    NSString *end = _endButton.titleLabel.text;
//    end = [self convertNull: end];
//    if ([cust isEqualToString:@" "]&& [pro isEqualToString:@" "]&&[start isEqualToString:@" "]&&[end isEqualToString:@" "]) {
//        _searchFlag = 0;
//    }else{
//        _searchFlag = 1;
//    }
//    if (_searchPage == 1) {
//        [_searchDateArray removeAllObjects];
//        [_searchNameArray removeAllObjects];
//        [_searchCountArray removeAllObjects];
//        [_searchMoneyArray removeAllObjects];
//    }
//
//    _searchView.hidden = YES;
//    _backView.hidden = YES;
//    _barHideBtn.hidden = YES;
}

- (void)searchTotalData
{
    /*
     tjlx	total
     action:"custProSales"
     */
    
}
- (void)searchDataWithproname:(NSString *)proname areaname:(NSString *)areaname areaid:(NSString *)areaid start:(NSString *)start end:(NSString *)end
{
    //总数量和总金额的
    NSString *cust = proname;
    cust = [self convertNull:cust];
    //    _proId = [self convertNull:areaid];
    NSString *depart = areaname;
    depart = [self convertNull:depart];
    areaid = [self convertNull:areaid];
    if ([depart isEqualToString:@" "]) {
        _salerId = @"";
    }
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([cust isEqualToString:@" "]&&[depart isEqualToString:@" "]&&[start isEqualToString:@" "]&&[end isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    start = [self convertNull:start];
    
    end = [self convertNull: end];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params  = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"action":@"custProSales",@"tjlx":@"detail",@"params":[NSString stringWithFormat:@"{\"custnameLIKE\":\"%@\",\"proid\":\"%@\",\"starttime\":\"%@\",\"endtime\":\"%@\"}",depart,areaid,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"客户产品销售总额%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    CustSaleModel *model = [[CustSaleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                    NSString *str = [dic objectForKey:@"allcount"];
                    str = [self convertNull:str];
                    NSString *str1 = [dic objectForKey:@"allmoney"];
                    str1 = [self convertNull:str1];
                    NSString *str2 = [dic objectForKey:@"custname"];
                    str2 = [self convertNull:str2];
                    [_searchNameArray addObject:str];
                    [_searchCountArray addObject:str1];
                    [_searchMoneyArray addObject:str2];
                }
                
            }
            [self.CustSaleTableView reloadData];
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
    }];
    
}
- (void)getAllsearchDataWithproname:(NSString *)proname areaname:(NSString *)areaname areaid:(NSString *)areaid start:(NSString *)start end:(NSString *)end

{
    //总数量和总金额的
    NSString *cust = proname;
    cust = [self convertNull:cust];
//    _proId = [self convertNull:areaid];
    NSString *depart = areaname;
    depart = [self convertNull:depart];
    areaid = [self convertNull:areaid];
    if ([depart isEqualToString:@" "]) {
        _salerId = @"";
    }
    start = [self convertNull:start];
    end = [self convertNull: end];
    if ([cust isEqualToString:@" "]&&[depart isEqualToString:@" "]&&[start isEqualToString:@" "]&&[end isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"custProSales",@"tjlx":@"total",@"params":[NSString stringWithFormat:@"{\"custnameLIKE\":\"%@\",\"proid\":\"%@\",\"starttime\":\"%@\",\"endtime\":\"%@\"}",depart,areaid,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray *array =[NSJSONSerialization  JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count != 0) {
                
                NSString *str = [NSString stringWithFormat:@"%@",array[0][@"allsendmoney"]];
                double money = [str doubleValue];
                self.zongJinE2.text = [NSString stringWithFormat:@"总金额:%.2f",money];
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
    [_proButton setTitle:@" " forState:UIControlStateNormal];
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
    KHCPXiaoShouSearchVC * vc = [[KHCPXiaoShouSearchVC alloc]init];
    [vc setBlock:^(NSString *proname,NSString *areaname,NSString *areaid,NSString *start,NSString *end) {
        [self searchDataWithproname:proname areaname:areaname areaid:areaid start:start end:end];
        
        [self getAllsearchDataWithproname:proname areaname:areaname areaid:areaid start:start end:end];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchAction{
    
    KHCPXiaoShouChart *chartVC = [[KHCPXiaoShouChart alloc] init];
    if (_searchFlag == 1) {
        chartVC.countData = _searchNameArray;
        chartVC.moneyData = _searchCountArray;
        chartVC.nameData = _searchMoneyArray;
    }else{
        chartVC.countData = _faHuoShuData;
        chartVC.moneyData = _faHuoJinEData;
        chartVC.nameData = _faHuoRenData;
    }
    [self.navigationController pushViewController:chartVC animated:YES];
    
}


@end
