//
//  ChanPinXiaoShouVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ChanPinXiaoShouVC.h"
#import "BaoBiaoTongJiViewController.h"
#import "ChanPinXiaoShouChartView.h"
#import "ChanPinXiaoShouModel.h"
#import "ChanPinXiaoShouCell.h"
#import "AFNetworking.h"
#import "DataPost.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "THCPModel.h"
#import "THCpInfoCell.h"
#import "DWandLXModel.h"
#import "QLChanPinXiaoShouCell.h"
#import "ChanPinXiaoShouSearchVC.h"
@interface ChanPinXiaoShouVC ()<UITextFieldDelegate>
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
    UIButton *_areaButton;
    NSString *_areaId;
    NSMutableArray *_areaArray;
    
    NSString *_pastDateStr;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _propage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;




@end

@implementation ChanPinXiaoShouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品销售区域分析";
    self.navigationItem.rightBarButtonItem = nil;

    _DataArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    _countArray = [[NSMutableArray alloc] init];
    _moneyArray = [[NSMutableArray alloc] init];
    _areaArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchNameArray = [[NSMutableArray alloc]init];
    _searchCountArray = [[NSMutableArray alloc]init];
    _searchMoneyArray = [[NSMutableArray alloc]init];
    _page = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _propage = 1;
    // Do any additional setup after loading the view from its nib.
    [self initTableView];
    //
    
    [self PageViewDidLoad];
    [self showBarWithName:@"搜索" addBarWithName:@"排名"];
    
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
- (void)initTableView{
    
    self.chanPinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114) style:UITableViewStyleGrouped];
    self.chanPinTableView.delegate = self;
    self.chanPinTableView.dataSource = self;
    self.chanPinTableView.rowHeight = 150;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.chanPinTableView addSubview:_refreshControl];
    [self.view addSubview:_chanPinTableView];
    //     下拉刷新
    _chanPinTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_chanPinTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _chanPinTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _chanPinTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_chanPinTableView.mj_footer endRefreshing];
    }];

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
     report
     mobile	true
     action	proSaleArea
     page	1
     rows	10
     */
    //产品销售区域分析
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"proSaleArea",@"params":[NSString stringWithFormat:@"{\"saletimeGE\":\"%@\",\"saletimeLE\":\"%@\"}",_pastDateStr,_currentDateStr]};
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
                ChanPinXiaoShouModel *model = [[ChanPinXiaoShouModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_DataArray addObject:model];
                NSString *str = [dic objectForKey:@"proname"];
                [_nameArray addObject:str];
                NSString *str1 = [dic objectForKey:@"totalcount"];
                [_countArray addObject:str1];
                NSString *str2 = [dic objectForKey:@"totalmoney"];
                [_moneyArray addObject:str2];
                
            }
            [self.chanPinTableView reloadData];
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            
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
    if (_searchFlag == 1) {
        _searchPage = 1;
        [_searchDateArray removeAllObjects];
        [_searchNameArray removeAllObjects];
        [_searchCountArray removeAllObjects];
        [_searchMoneyArray removeAllObjects];
        
        [_refreshControl endRefreshing];
    }else{
        _page = 1;
        [_DataArray removeAllObjects];
        [_nameArray removeAllObjects];
        [_countArray removeAllObjects];
        [_moneyArray removeAllObjects];
        [self DataRequest];
        [self DataRequest1];
        [_refreshControl endRefreshing];
    }
}
//上拉加载更多
- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
        
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
     mobile	true
     action	proSaleArea
     isstat	true
     */
    //总数量 和总金额的数据JSON
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"proSaleArea",@"mobile":@"true",@"isstat":@"true",@"params":[NSString stringWithFormat:@"{\"saletimeGE\":\"%@\",\"saletimeLE\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"总计%@",dic);
        if (dic.count != 0) {
            NSString *str =[NSString stringWithFormat:@"%@",dic[0][@"totalcountall"]];
            double count = [str doubleValue];
            
            self.zongShuLiang2.text = [NSString stringWithFormat:@"总数量:%.2f",count];
            NSString *str1 =[NSString stringWithFormat:@"%@",dic[0][@"totalmoneyall"]];
            double money = [str1 doubleValue];
            self.zongJinE2.text = [NSString stringWithFormat:@"总金额:%.2f",money];
        }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
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
-(void)PageViewDidLoad
{
    //产品销售区域分析 下方的view的设置 总数量和 总金额的添加
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
    
//    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
//    biaoTiView.backgroundColor =[UIColor groupTableViewBackgroundColor];
//    [self.view addSubview:biaoTiView];
//    
//    UILabel *zongShuLiang =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 40)];
//    zongShuLiang.text =@"总数量 :";
//    zongShuLiang.textColor =[UIColor blackColor];
//    zongShuLiang.backgroundColor =[UIColor clearColor];
//    zongShuLiang.font =[UIFont systemFontOfSize:14];
//    [self.view addSubview:zongShuLiang];
//    
//    self.zongShuLiang2 =[[UILabel alloc]initWithFrame:CGRectMake(65, 5, KscreenWidth/2 - 65, 40)];
//    self.zongShuLiang2.textColor =[UIColor blackColor];
//    self.zongShuLiang2.backgroundColor =[UIColor clearColor];
//    self.zongShuLiang2.font =[UIFont systemFontOfSize:14];
//    [self.view addSubview:self.zongShuLiang2];
//    
//    
//    UILabel *zongJinE =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 +5, 5, 60, 40)];
//    zongJinE.text =@"总金额 :";
//    zongJinE.textColor =[UIColor blackColor];
//    zongJinE.backgroundColor =[UIColor clearColor];
//    zongJinE.font =[UIFont systemFontOfSize:14];
//    [self.view addSubview:zongJinE];
//    
//    self.zongJinE2 =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 + 65,5, KscreenWidth/2, 40)];
//    self.zongJinE2.textColor =[UIColor blackColor];
//    self.zongJinE2.backgroundColor =[UIColor clearColor];
//    self.zongJinE2.font =[UIFont systemFontOfSize:14];
//    [self.view addSubview:self.zongJinE2];
    
    
}

#pragma mark UITableView DataSource AndDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (tableView == self.proTableView) {
//        return _dataArray.count;
//    }else if (tableView == self.areaTableView){
//        return _areaArray.count;
//    }else{
//        if (_searchFlag == 1) {
//            return _searchDateArray.count;
//        }else{
//            return _DataArray.count;
//        }
//    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
            
    if (_searchFlag == 1) {
        return _searchDateArray.count;
    }else{
        return _DataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"QLChanPinXiaoShouCell";
    QLChanPinXiaoShouCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil)
    {
        cell =(QLChanPinXiaoShouCell*)[[[NSBundle mainBundle]loadNibNamed:@"QLChanPinXiaoShouCell" owner:self options:nil]firstObject];
    }
    
    
    if (tableView == self.chanPinTableView ) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.section];
            }
        }else{
            if(_DataArray.count != 0){
                cell.model = _DataArray[indexPath.section];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.chanPinTableView ) {
        
        ChanPinXiaoShouChartView *chartVC = [[ChanPinXiaoShouChartView alloc] init];
        if (_searchFlag == 1) {
            chartVC.nameData = @[_searchNameArray[indexPath.section]];
            chartVC.countData = @[_searchCountArray[indexPath.section]];
            chartVC.moneyData = @[_searchMoneyArray[indexPath.section]];
        }else{
            chartVC.nameData = @[_nameArray[indexPath.section]];
            chartVC.countData = @[_countArray[indexPath.section]];
            chartVC.moneyData = @[_moneyArray[indexPath.section]];
        }
        [self.navigationController pushViewController:chartVC animated:YES];
    }

    
    
}




#pragma mark - 搜索页面方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
}



//- (void)getPro{
//    NSString *proName = _proField.text;
//
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn?action=getShipments"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = [NSString stringWithFormat:@"action=getShipments&params={\"nameLIKE\":\"%@\"}",proName];
//    NSLog(@"产品信息搜索 = %@",str);
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
//
//        NSLog(@"产品信息搜索返回:%@",dic);
//        [_dataArray removeAllObjects];
//        for (NSDictionary *dic1 in dic) {
//            THCPModel *model = [[THCPModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic1];
//            [_dataArray addObject:model];
//        }
//        [self.proTableView reloadData];
//    }
//
//}
//- (void)proRequest{
//
//
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn?action=getShipments"];
//    NSDictionary *params = @{@"action":@"getShipments",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"table":@"fhxx",};
//    if (_page == 1) {
//        [_dataArray removeAllObjects];
//    }
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSArray *array = dic[@"rows"];
//        NSLog(@"退货的产品名称%@",array);
//        for (NSDictionary *dic in array) {
//            THCPModel *model = [[THCPModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:model];
//        }
//        [self.proTableView reloadData];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"加载失败");
//    }];
//
//
//}









#pragma mark - 搜索方法

- (void)search
{
//    [self searchData];
//    [self getAll];
}

- (void)searchDataWithproname:(NSString *)proname areaname:(NSString *)areaname areaid:(NSString *)areaid start:(NSString *)start end:(NSString *)end
{
    /*
     report
     action:"proSaleArea"
     tjlx:"detail"
     page:"1"
     rows:"100"
     params:"{"pronameLIKE":"金毒克","specificationLIKE":"","departidEQ":"","departnameLIKE":"","saletimeGE":"2015-08-12","saletimeLE":"2015-09-12"}"
     {"pronameLIKE":"金毒克","specificationLIKE":"","departidEQ":"226","departnameLIKE":"季广飞区域","saletimeGE":"2015-08-14","saletimeLE":"2015-09-14"}
     */
    NSString *pro = proname;
    pro = [self convertNull:pro];
    _areaId = [self convertNull:areaid];
    NSString *depart = areaname;
    depart = [self convertNull:depart];
    if ([depart isEqualToString:@" "]) {
        _areaId = @"";
    }
    start = [self convertNull:start];
    end = [self convertNull: end];
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([pro isEqualToString:@" "]&&[depart isEqualToString:@" "]&&[start isEqualToString:@" "]&&[end isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%ld",(long)_searchPage],@"action":@"proSaleArea",@"params":[NSString stringWithFormat:@"{\"pronameLIKE\":\"%@\",\"specificationLIKE\":\"\",\"departidEQ\":\"%@\",\"departnameLIKE\":\"%@\",\"saletimeGE\":\"%@\",\"saletimeLE\":\"%@\"}",pro,_areaId,depart,start,end]};
    NSLog(@"上传数据%@",params);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"源数据%@",array);
            if (array.count != 0) {
                for (NSDictionary *dic  in array) {
                    ChanPinXiaoShouModel *model = [[ChanPinXiaoShouModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                    NSString *str = [dic objectForKey:@"proname"];
                    str = [self convertNull:str];
                    [_searchNameArray addObject:str];
                    NSString *str1 = [dic objectForKey:@"totalcount"];
                    str1 = [self convertNull:str1];
                    [_searchCountArray addObject:str1];
                    NSString *str2 = [dic objectForKey:@"totalmoney"];
                    str2 = [self convertNull:str2];
                    [_searchMoneyArray addObject:str2];
                }
            }
            [self.chanPinTableView reloadData];
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
}

- (void)getAllsearchDataWithproname:(NSString *)proname areaname:(NSString *)areaname areaid:(NSString *)areaid start:(NSString *)start end:(NSString *)end

{
    /*
     report
     mobile	true
     action	proSaleArea
     isstat	true
     */
    //总数量 和总金额的数据JSON
    
    NSString *pro = proname;
    pro = [self convertNull:pro];
    NSString *depart = areaname;
    depart = [self convertNull:depart];
    areaid = [self convertNull:areaid];
    if ([depart isEqualToString:@" "]) {
        _areaId = @"";
    }
    
    start = [self convertNull:start];
    
    end = [self convertNull: end];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"proSaleArea",@"mobile":@"true",@"isstat":@"true",@"params":[NSString stringWithFormat:@"{\"pronameLIKE\":\"%@\",\"specificationLIKE\":\"\",\"departidEQ\":\"%@\",\"departnameLIKE\":\"%@\",\"saletimeGE\":\"%@\",\"saletimeLE\":\"%@\"}",pro,_areaId,depart,start,end]};
    NSLog(@"数据参数%@",params);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"总计%@",dic);
        if (dic.count != 0) {
            NSString *str =[NSString stringWithFormat:@"%@",dic[0][@"totalcountall"]];
            double count = [str doubleValue];
            
            self.zongShuLiang2.text = [NSString stringWithFormat:@"总数量:%.2f",count];

            NSString *str1 =[NSString stringWithFormat:@"%@",dic[0][@"totalmoneyall"]];
            double money = [str1 doubleValue];
            self.zongJinE2.text = [NSString stringWithFormat:@"总金额:%.2f",money];

        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
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


- (void)chongZhi
{
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
    [_startButton setTitle:@" " forState:UIControlStateNormal];
    [_endButton setTitle:@" " forState:UIControlStateNormal];
    [_areaButton setTitle:@" " forState:UIControlStateNormal];
}

- (void)addNext{
    [_searchDateArray removeAllObjects];
    ChanPinXiaoShouSearchVC * vc = [[ChanPinXiaoShouSearchVC alloc]init];
    [vc setBlock:^(NSString *proname,NSString *areaname,NSString *areaid,NSString *start,NSString *end) {
        [self searchDataWithproname:proname areaname:areaname areaid:areaid start:start end:end];
        
        [self getAllsearchDataWithproname:proname areaname:areaname areaid:areaid start:start end:end];
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
    ChanPinXiaoShouChartView *chartVC = [[ChanPinXiaoShouChartView alloc] init];
    if (_searchFlag == 1) {
        chartVC.nameData =_searchNameArray;
        chartVC.countData = _searchCountArray;
        chartVC.moneyData = _searchMoneyArray;
    }else{
        chartVC.nameData =_nameArray;
        chartVC.countData = _countArray;
        chartVC.moneyData = _moneyArray;
    }
    [self.navigationController pushViewController:chartVC animated:YES];
    
}



@end
