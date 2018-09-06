//
//  KHHuiKuanShuJuVc.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "KHHuiKuanShuJuVc.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "CustModel.h"
#import "UIViewExt.h"
#import "KHShuJuCell.h"
#import "KHShuJuModel.h"
#import "KHHuiKuanShuJuChart.h"
@interface KHHuiKuanShuJuVc ()<UITextFieldDelegate>{
    UIRefreshControl *_refreshControl;
    MBProgressHUD *_HUD;
    NSInteger _page;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray *_searchDataArray;
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

@implementation KHHuiKuanShuJuVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户回款数据对比";
    self.navigationItem.rightBarButtonItem = nil;
    
    _DataArray = [[NSMutableArray alloc] init];
    _dataArray = [NSMutableArray array];
    _nameArray = [[NSMutableArray alloc] init];
    _monenyData = [[NSMutableArray alloc] init];
    _countData = [[NSMutableArray alloc] init];
    _searchDataArray = [[NSMutableArray alloc]init];
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
    
    
    [self  PageViewDidLoad1];
    [self showBarWithName:@"搜索" addBarWithName:@"排名"];
    [self initSearchView];
    
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
        [_searchDataArray removeAllObjects];
        _searchPage = 1;
        [self searchData];
        [_refreshControl endRefreshing];
    }else{
        [_DataArray removeAllObjects];
        _page = 1;
        [self DataRequest];
        [_refreshControl endRefreshing];
    }
}

- (void)getDateStr{
    //取得系统的 当前日期
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDate =[dateFormatter stringFromDate:date];
    _currentDateStr = nowDate;
    //当前月
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:date];
    //当前年
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:date];
    //当前天
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    //获取前一个月
    NSInteger mon = [month integerValue];
    mon = mon - 1;
    NSString *pastmon;
    if (mon < 10) {
        pastmon = [NSString stringWithFormat:@"0%zi",mon];
    }else{
        pastmon = [NSString stringWithFormat:@"%zi",mon];
    }
    //获取前一年
    NSInteger ye = [year integerValue];
    ye = ye - 1;
    NSString *pastYear = [NSString stringWithFormat:@"%zi",ye];
    //判断是否是1月份 取得前一个月的时间
    NSString *dateStr;
    
    if ([month isEqualToString:@"01"]) {
        mon = 12;
        dateStr = [NSString stringWithFormat:@"%@-%zi-%@",pastYear,mon,day];
        
    }else{
        dateStr = [NSString stringWithFormat:@"%@-%@-%@",year,pastmon,day];
        
    }
    _pastDateStr = dateStr;
    
}



-(void)DataRequest
{
    /*
    action:custReturnMoneys
     tjlx:"detail"tjlx:"detail"
     params:"{"custnameLIKE":"","starttime":"2015-08-28","endtime":"2015-09-28"}"
     */
    //客户回款同期对比
    //时间的值还有传
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"custReturnMoneys",@"page":[NSString stringWithFormat:@"%zi",_page],@"rows":@"20",@"tjlx":@"detail",@"params":[NSString stringWithFormat:@"{\"starttime\":\"%@\",\"endtime\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array =dic[@"rows"];
        NSLog(@"客户回款数据:%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic  in array) {
                KHShuJuModel *model = [[KHShuJuModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_DataArray addObject:model];
                NSString *str = [self convertNull:model.custname];//[dic objectForKey:@"custname"];
                [_nameArray addObject:str];
                NSString *str1 = [self convertNull:model.fahuojine];//[dic objectForKey:@"sendmoney"];
                [_monenyData addObject:str1];
                NSString *str2 = [self convertNull:model.huikuanjine];//[dic objectForKey:@"returnmoney"];
                [_countData addObject:str2];
            }
        }
        [self.KeHuShuJuTableView reloadData];
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


-(void)DataRequest1
{
    /*
     
     tjlx	total
     tjlx:"total"
     action:"custReturnMoneys"
     params:"{"custnameLIKE":"","starttime":"2015-08-28","endtime":"2015-09-28"}"
     */
    //去年的 金额的 和今年的 接口的json 解析好好的good
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"custReturnMoneys",@"tjlx":@"total",@"params":[NSString stringWithFormat:@"{\"starttime\":\"%@\",\"endtime\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"客户回款总计%@",array);
        if (array.count != 0) {
            NSString *str1 =[NSString stringWithFormat:@"%@",array[0][@"allreturned"]];
            str1 = [self convertNull:str1];
            NSString *str2 =[NSString stringWithFormat:@"%@",array[0][@"tuihuojineall"]];
            str2 = [self convertNull:str2];
            NSString *str3 =[NSString stringWithFormat:@"%@",array[0][@"sendmoneyall"]];
            str3 = [self convertNull:str3];
            NSString *str4 =[NSString stringWithFormat:@"%@",array[0][@"shouldmoney"]];
            str4 = [self convertNull:str4];
            NSString *str5 = [NSString stringWithFormat:@"%@",array[0][@"kehuchongzhangall"]];
            str5 = [self convertNull:str5];
            _label1.text = [NSString stringWithFormat:@"发货金额合计:%@ | 应回款金额合计:%@",str3,str4];
            _label2.text = [NSString stringWithFormat:@"实际回款金额合计:%@ | 退货金额合计:%@ | 客户冲账合计:%@",str1,str2,str5];
            }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    //    NSURL *url =[NSURL URLWithString:urlStr];
    //    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    [request setHTTPMethod:@"POST"];
    //    NSString *str =[NSString stringWithFormat:@"tjlx=total&mobile=true&action=custShipsInSameTime&params={\"starttime\":\"%@\",\"endtime\":\"%@\"}",self.guoQuRiQi,self.dangQianRiQi];
    //    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setHTTPBody:data];
    //    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (data1 != nil) {
    //        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    //        if (array.count != 0) {
    //            NSString *lastallreturned =[NSString stringWithFormat:@"%@",array[0][@"lastyearall"]];
    //            self.m_quNian.text =lastallreturned;
    //
    //            NSString *allreturned =[NSString stringWithFormat:@"%@",array[0][@"thisyearall"]];
    //            self.m_jinNian.text =allreturned;
    //
    //        }
    //    }
}
-(void)PageViewDidLoad1
{
    
    //客户发货同期对比的 分析 下方的view的设置 上年和今年的添加
    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    biaoTiView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:biaoTiView];
    
    _label1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, KscreenWidth- 20, 25)];
    //self.m_quNian.text=@"4334";
    _label1.textColor =[UIColor blackColor];
    _label1.backgroundColor =[UIColor clearColor];
    _label1.adjustsFontSizeToFitWidth = YES;
    _label1.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:_label1];

    
    _label2 =[[UILabel alloc]initWithFrame:CGRectMake(10,25, KscreenWidth - 20, 25)];
    //self.m_jinNian.text=@"hha";
    _label2.textColor =[UIColor blackColor];
    _label2.backgroundColor =[UIColor clearColor];
    _label2.font =[UIFont systemFontOfSize:13];
    _label2.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_label2];
    self.KeHuShuJuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.KeHuShuJuTableView.delegate =self;
    self.KeHuShuJuTableView.dataSource =self;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.KeHuShuJuTableView addSubview:_refreshControl];
    [self.view addSubview:_KeHuShuJuTableView];
    //     下拉刷新
    _KeHuShuJuTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_KeHuShuJuTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _KeHuShuJuTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _KeHuShuJuTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_KeHuShuJuTableView.mj_footer endRefreshing];
    }];
}


#pragma mark UITableView DataSource AndDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.salerTableView) {
        return _dataArray.count;
    }else{
        if (_searchFlag == 1) {
            return _searchDataArray.count;
        }else{
            return _DataArray.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"cell";
    KHShuJuCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell =(KHShuJuCell*)[[[NSBundle mainBundle]loadNibNamed:@"KHShuJuCell" owner:self options:nil]firstObject];
        
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == self.KeHuShuJuTableView) {
        if (_searchFlag == 1) {
            if (_searchDataArray.count!=0) {
                cell.model = _searchDataArray[indexPath.row];
            }
        }else{
            if (_DataArray.count != 0) {
                cell.model = _DataArray[indexPath.row];
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
    if (tableView == self.KeHuShuJuTableView) {
        KHHuiKuanShuJuChart *chartView  = [[KHHuiKuanShuJuChart alloc] init];
        if (_searchFlag == 1) {
            chartView.nameData = @[_searchNameArray[indexPath.row]];
            chartView.countData = @[_searchCountArray[indexPath.row]];
            chartView.moneyData = @[_searchMoneyArray[indexPath.row]];
            
        }else{
            chartView.nameData = @[_nameArray[indexPath.row]];
            chartView.countData = @[_countData[indexPath.row]];
            chartView.moneyData = @[_monenyData[indexPath.row]];

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
        return 100;
        
    }
    
}



#pragma mark -  搜索

- (void)initSearchView{
    _barHideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _barHideBtn.frame = CGRectMake(0, 0, KscreenWidth, 64+50);
    _barHideBtn.backgroundColor = [UIColor clearColor];
    _barHideBtn.hidden = YES;
    [_barHideBtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_barHideBtn];
    //右侧模糊视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 50, KscreenWidth/3, KscreenHeight -64 - 50)];
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = 0.6;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTouchesRequired = 1;
    [ _backView addGestureRecognizer:singleTap];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    
    //信息视图
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth/3*2, KscreenHeight - 64 -50)];
    _searchView.backgroundColor = [UIColor whiteColor];
    
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
    Label1.text = @"客户名称";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    [_salerButton setTintColor:[UIColor blackColor]];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
    nameView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label1];
    [_searchView addSubview:_salerButton];
    [_searchView addSubview:nameView];
    
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, _searchView.frame.size.width/3, 40)];
    Label2.text = @"开始时间";
    Label2.backgroundColor = COLOR(231, 231, 231, 1);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(_searchView.frame.size.width/3, 41, _searchView.frame.size.width/3*2, 40);
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, 81, _searchView.frame.size.width, 1)];
    salerView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label2];
    [_searchView addSubview:_startButton];
    [_searchView addSubview:salerView];
    //
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, _searchView.frame.size.width/3, 40)];
    Label3.text = @"结束时间";
    Label3.backgroundColor = COLOR(231, 231, 231, 1);
    Label3.font = [UIFont systemFontOfSize:15.0];
    Label3.textAlignment = NSTextAlignmentCenter;
    _endButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(_searchView.frame.size.width/3, 82, _searchView.frame.size.width/3*2, 40);
    [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, _searchView.frame.size.width, 1)];
    typeView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label3];
    [_searchView addSubview:_endButton];
    [_searchView addSubview:typeView];
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor grayColor];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, 150, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:[UIColor grayColor]];
    [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, 150, 60, 30);
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    [_searchView addSubview:searchBtn];
    [_searchView addSubview:chongZhi];
    [self.view  addSubview:_searchView];
    _searchView.hidden = YES;
}

#pragma mark - 搜索页面方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
}
- (void)salerAction{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.m_keHuPopView addSubview:bgView];
//    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
//    _custField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_custField addSubview:line2];
    _custField.font = [UIFont systemFontOfSize:13];
//    [self.m_keHuPopView addSubview:_custField];
    [bgView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, _custField.top, 60, _custField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchcust) forControlEvents:UIControlEventTouchUpInside];//getName
//    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.tag = 10;
    self.salerTableView.rowHeight = 45;
    [bgView addSubview:self.salerTableView];
//    [self.m_keHuPopView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    [self nameRequest];
    //     下拉刷新
    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _custpage = 1;
        [self searchcust];
        // 结束刷新
        [self.salerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _custpage ++ ;
        [self searchcust];
        [self.salerTableView.mj_footer endRefreshing];
        
    }];
    _custpage = 1;
    [self searchcust];
    
}
- (void)getName{
    
    NSString *custName = _custField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getSelectName&params={\"nameLIKE\":\"%@\"}",custName];
    NSLog(@"客户名称信息搜索 = %@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.salerTableView reloadData];
        
    }
    
}


- (void)nameRequest
{
    //客户名称 的浏览接口
    NSLog(@"页数%zi",_page);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户数据%@",dic);
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户名称加载失败");
    }];
    
}

- (void)searchcust{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"table":@"khxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_custpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    if (_custpage == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                NSLog(@"客户名称数据:%@",array);
                for (NSDictionary *dic in array) {
                    CustModel *model = [[CustModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.salerTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];

}

- (void)closePop
{
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
        
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
    [self searchData];
    [self searchTotalData];
}

- (void)searchData
{
    /*
     action:"custReturnMoneys"
     tjlx:"detail"tjlx:"detail"
     params:"{"custnameLIKE":"","starttime":"2015-08-28","endtime":"2015-09-28"}"
     */
    NSString *cust = _salerButton.titleLabel.text;
    cust = [self convertNull:cust];
    _salerId = [self convertNull:_salerId];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    NSString *end = _endButton.titleLabel.text;
    end = [self convertNull: end];
    if ([cust isEqualToString:@""]&&[start isEqualToString:@""]&&[end isEqualToString:@""]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    if (_searchPage == 1) {
        [_searchDataArray removeAllObjects];
        [_searchNameArray removeAllObjects];
        [_searchCountArray removeAllObjects];
        [_searchMoneyArray removeAllObjects];
    }
    //客户回款同期对比
    //时间的值还有传
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"custReturnMoneys",@"page":[NSString stringWithFormat:@"%ld",(long)_searchPage],@"rows":@"20",@"tjlx":@"detail",@"params":[NSString stringWithFormat:@"{\"custnameLIKE\":\"%@\",\"starttime\":\"%@\",\"endtime\":\"%@\"}",cust,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array =dic[@"rows"];
            NSLog(@"客户回款数据:%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic  in array) {
                    KHShuJuModel *model = [[KHShuJuModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDataArray addObject:model];
                    NSString* str = [self convertNull:model.custname];
                    [_searchNameArray addObject:str];
                    NSString* str1 = [self convertNull:model.fahuojine];
                    [_searchMoneyArray addObject:str1];
                    NSString* str2 = [self convertNull:model.huikuanjine];
                    [_searchCountArray addObject:str2];
                }
                
            }
            [self.KeHuShuJuTableView reloadData];
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
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
}

- (void)searchTotalData
{
    /*
     
     tjlx	total
     tjlx:"total"
     action:"custReturnMoneys"
     params:"{"custnameLIKE":"","starttime":"2015-08-28","endtime":"2015-09-28"}"
     */
    //去年的 金额的 和今年的 接口的json 解析好好的good
    NSString *cust = _salerButton.titleLabel.text;
    cust = [self convertNull:cust];
    _salerId = [self convertNull:_salerId];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    NSString *end = _endButton.titleLabel.text;
    end = [self convertNull: end];
    NSString *urlStr1 = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params1 = @{@"action":@"custReturnMoneys",@"tjlx":@"total",@"params":[NSString stringWithFormat:@"{\"custnameLIKE\":\"%@\",\"starttime\":\"%@\",\"endtime\":\"%@\"}",cust,start,end]};
    [DataPost requestAFWithUrl:urlStr1 params:params1 finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"客户回款总计%@",array);
            if (array.count != 0) {
                NSString *str1 =[NSString stringWithFormat:@"%@",array[0][@"allreturned"]];
                str1 = [self convertNull:str1];
                NSString *str2 =[NSString stringWithFormat:@"%@",array[0][@"tuihuojineall"]];
                str2 = [self convertNull:str2];
                NSString *str3 =[NSString stringWithFormat:@"%@",array[0][@"sendmoneyall"]];
                str3 = [self convertNull:str3];
                NSString *str4 =[NSString stringWithFormat:@"%@",array[0][@"shouldmoney"]];
                str4 = [self convertNull:str4];
                NSString *str5 = [NSString stringWithFormat:@"%@",array[0][@"kehuchongzhangall"]];
                str5 = [self convertNull:str5];
                _label1.text = [NSString stringWithFormat:@"发货金额合计:%@ | 应回款金额合计:%@",str3,str4];
                _label2.text = [NSString stringWithFormat:@"实际回款金额合计:%@ | 退货金额合计:%@ | 客户冲账合计:%@",str1,str2,str5];
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
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
        _barHideBtn.hidden = NO;
        [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
        [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
    }
    
}
- (void)searchAction{
    
    KHHuiKuanShuJuChart *chartView  = [[KHHuiKuanShuJuChart alloc] init];
    if (_searchFlag == 1) {
        chartView.nameData = _searchNameArray;
        chartView.countData = _searchCountArray;
        chartView.moneyData = _searchMoneyArray;
    }else{
        chartView.nameData = _nameArray;
        chartView.countData = _countData;
        chartView.moneyData = _monenyData;
    }
    [self.navigationController pushViewController:chartView animated:YES];
    
}

@end
