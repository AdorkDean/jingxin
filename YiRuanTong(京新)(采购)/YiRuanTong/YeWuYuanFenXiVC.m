//
//  YeWuYuanFenXiVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "YeWuYuanFenXiVC.h"
#import "BaoBiaoTongJiViewController.h"
#import "YeWuYuanHuiKuanChartView.h"
#import "YeWuYuanFenXiCell.h"
#import "YeWuYuanHuiKuanModel.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "CustModel.h"
#import "UIViewExt.h"
@interface YeWuYuanFenXiVC ()<UITextFieldDelegate>
{
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
    UITextField *_salerField;
    NSMutableArray *_dataArray;
    
    
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _salerpage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation YeWuYuanFenXiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售员同期发货对比";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    _DataArray = [[NSMutableArray alloc]init];
    _nameArray = [[NSMutableArray alloc]init];
    _sendArray = [[NSMutableArray alloc]init];
    _returnArray = [[NSMutableArray alloc]init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchNameArray = [[NSMutableArray alloc]init];
    _searchCountArray = [[NSMutableArray alloc]init];
    _searchMoneyArray = [[NSMutableArray alloc]init];
    _page = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _salerpage = 1;
    //进度HUD
    
    // Do any additional setup after loading the view from its nib.
    
    //页面
    [self initView];
    [self showBarWithName:@"搜索" addBarWithName:@"排名"];
    [self initSearchView];
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];

    //数据加载
    [self getDateStr];
    [self DataRequest];
    [self DataRequest1];
    [_HUD hide:YES afterDelay:1.0];
    
    
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
     report
     tjlx	detail
     mobile	true
     action	salerShipsReturn
     page	1
     rows	10
     params	{"starttime":"2015-02-05","endtime":"2015-03-05"}
     */
    //客户回款同期对比 的接口 
    //时间的值还有传
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"tjlx":@"detail",@"mobile":@"true",@"action":@"salerShipsReturn",@"page":[NSString stringWithFormat:@"%zi",_page],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"starttime\":\"%@\",\"endtime\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"销售员同期%@",dic);
        NSArray *array =dic[@"rows"];
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                YeWuYuanHuiKuanModel *model = [[YeWuYuanHuiKuanModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_DataArray addObject:model];
                NSString *str  = [dic objectForKey:@"saler"];
                [_nameArray addObject:str];
                NSString *str1  = [dic objectForKey:@"sendmoney"];
                [_sendArray addObject:str1];
                NSString *str2  = [dic objectForKey:@"returnmoney"];
                [_returnArray addObject:str2];
            }
            
            [self.yeWuYuanFenXiTableView reloadData];
            NSLog(@"业务员发货回款分析:%@",dic);
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

- (void)refreshDown
{
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        [self searchData];
        [_refreshControl endRefreshing];
    }else{
        [_DataArray removeAllObjects];
        _page = 1;
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
     report
     tjlx	total
     mobile	true
     action	salerShipsReturn
     params	{"starttime":"2015-02-05","endtime":"2015-03-05"}
     
     */
    //去年的 金额的 和今年的 接口的json 
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"salerShipsReturn",@"mobile":@"true",@"tjlx":@"total",@"params":[NSString stringWithFormat:@"{\"starttime\":\"%@\",\"endtime\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
       
        NSString *sendmoneyall =[NSString stringWithFormat:@"%@",dic[0][@"sendmoneyall"]];
        double send = [sendmoneyall doubleValue];
        self.m_yingHuiKuan.text = [NSString stringWithFormat:@"当年发货:%.2f",send];
        
        NSString *returnmoneyall =[NSString stringWithFormat:@"%@",dic[0][@"returnmoneyall"]];
        double returnm = [returnmoneyall doubleValue];
        self.m_shiJiHuiKuan.text = [NSString stringWithFormat:@"上年发货:%.2f",returnm];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
}


- (void)initView
{
    
    
    self.yeWuYuanFenXiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    self.yeWuYuanFenXiTableView.delegate =self;
    self.yeWuYuanFenXiTableView.dataSource =self;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.yeWuYuanFenXiTableView addSubview:_refreshControl];
    [self.view addSubview:_yeWuYuanFenXiTableView];
    //     下拉刷新
    _yeWuYuanFenXiTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_yeWuYuanFenXiTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _yeWuYuanFenXiTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _yeWuYuanFenXiTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_yeWuYuanFenXiTableView.mj_footer endRefreshing];
    }];
    //客户发货同期对比的 分析 下方的view的设置 上年和今年的添加
    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    biaoTiView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:biaoTiView];
    
    
    self.m_yingHuiKuan =[[UILabel alloc]initWithFrame:CGRectMake(15, 5, KscreenWidth/2 - 15, 40)];
    //self.m_quNian.text=@"4334";
    self.m_yingHuiKuan.textColor =[UIColor blackColor];
    self.m_yingHuiKuan.backgroundColor =[UIColor clearColor];
    self.m_yingHuiKuan.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.m_yingHuiKuan];
    
    
    
    self.m_shiJiHuiKuan =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/2 ,5, KscreenWidth/2 - 15, 40)];
    //self.m_jinNian.text=@"hha";
    self.m_shiJiHuiKuan.textColor =[UIColor blackColor];
    self.m_shiJiHuiKuan.backgroundColor =[UIColor clearColor];
    self.m_shiJiHuiKuan.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:self.m_shiJiHuiKuan];
}


#pragma mark UITableView DataSource AndDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"cell";
    YeWuYuanFenXiCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell =(YeWuYuanFenXiCell*)[[[NSBundle mainBundle]loadNibNamed:@"YeWuYuanFenXiCell" owner:self options:nil]firstObject];
        
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    
    if (tableView == self.yeWuYuanFenXiTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.row];
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
    if (tableView == self.yeWuYuanFenXiTableView) {
        YeWuYuanHuiKuanChartView *chartView = [[YeWuYuanHuiKuanChartView alloc] init];
        if (_searchFlag == 1) {
            chartView.nameData = @[_searchNameArray[indexPath.row]];
            chartView.sendData = @[_searchCountArray[indexPath.row]];
            chartView.returnData = @[_searchMoneyArray[indexPath.row]];
        }else{
            chartView.nameData = @[_nameArray[indexPath.row]];
            chartView.sendData = @[_sendArray[indexPath.row]];
            chartView.returnData = @[_returnArray[indexPath.row]];
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
    }else{
        return 65;
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
    Label1.text = @"业务员";
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
    //
//    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _salerField.backgroundColor = [UIColor whiteColor];
    _salerField.delegate = self;
    _salerField.tag =  102;
    _salerField.placeholder = @"名称关键字";
//    _salerField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_salerField.height-1,_salerField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_salerField addSubview:line2];
    _salerField.font = [UIFont systemFontOfSize:13];
//    [self.m_keHuPopView addSubview:_salerField];
    [bgView addSubview:_salerField];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_salerField.right, _salerField.top, 60, _salerField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(getName) forControlEvents:UIControlEventTouchUpInside];
//    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, _salerField.bottom,KscreenWidth-120, KscreenHeight-154) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _salerField.bottom+5,bgView.width-40, bgView.height - _salerField.bottom - 5) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.rowHeight = 45;
    [bgView addSubview:self.salerTableView];
//    [self.m_keHuPopView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    
    //     下拉刷新
    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _salerpage = 1;
        [self searchsaler];
        // 结束刷新
        [self.salerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _salerpage ++ ;
        [self searchsaler];
        [self.salerTableView.mj_footer endRefreshing];
        
    }];
    //    [self salerRequest];
    _salerpage = 1;
    [self searchsaler];
}

- (void)getName{
    [self searchsaler];

}
- (void)salerRequest{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员数据%@",array);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
    }];
    
    
}

- (void)searchsaler{
      MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_salerpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    if (_salerpage == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                NSLog(@"业务员点击后返回:%@",array);
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
        NSLog(@"业务员加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];

}

- (void)closePop
{
    if ([self keyboardDid]) {
        [_salerField resignFirstResponder];
        
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
    [self getAll];
}

- (void)searchData
{
    /*
     report
     action:"salerShipsRank"
     tjlx:"detail"
     page:"1"
     rows:"100"
     params:"{"departid":"","salerid":"265","starttime":"2015-08-12","endtime":"2015-09-12"}"
     */
    NSString *cust = _salerButton.titleLabel.text;
    cust = [self convertNull:cust];
    _salerId = [self convertNull:_salerId];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    NSString *end = _endButton.titleLabel.text;
    end = [self convertNull: end];
    if ([cust isEqualToString:@" "]&&[start isEqualToString:@" "]&&[end isEqualToString:@" "]) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"tjlx":@"detail",@"mobile":@"true",@"action":@"salerShipsReturn",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"departid\":\"\",\"salerid\":\"%@\",\"starttime\":\"%@\",\"endtime\":\"%@\"}",_salerId,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array =dic[@"rows"];
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    YeWuYuanHuiKuanModel *model = [[YeWuYuanHuiKuanModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                    NSString *str  = [dic objectForKey:@"saler"];
                    [_searchNameArray addObject:str];
                    NSString *str1  = [dic objectForKey:@"sendmoney"];
                    [_searchCountArray addObject:str1];
                    NSString *str2  = [dic objectForKey:@"returnmoney"];
                    [_searchMoneyArray addObject:str2];
                }
            }
            [self.yeWuYuanFenXiTableView reloadData];
            NSLog(@"业务员发货回款分析:%@",dic);
            [_HUD removeFromSuperview];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
}

- (void)getAll
{
    /*
     report
     tjlx	total
     mobile	true
     action	salerShipsReturn
     params	{"starttime":"2015-02-05","endtime":"2015-03-05"}
     
     */
    //去年的 金额的 和今年的 接口的json
    NSString *cust = _salerButton.titleLabel.text;
    cust = [self convertNull:cust];
    _salerId = [self convertNull:_salerId];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    NSString *end = _endButton.titleLabel.text;
    end = [self convertNull: end];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"salerShipsReturn",@"mobile":@"true",@"tjlx":@"total",@"params":[NSString stringWithFormat:@"{\"departid\":\"\",\"salerid\":\"%@\",\"starttime\":\"%@\",\"endtime\":\"%@\"}",_salerId,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        NSString *sendmoneyall =[NSString stringWithFormat:@"%@",dic[0][@"sendmoneyall"]];
        double send = [sendmoneyall doubleValue];
        self.m_yingHuiKuan.text = [NSString stringWithFormat:@"当年发货:%.2f",send];
        
        NSString *returnmoneyall =[NSString stringWithFormat:@"%@",dic[0][@"returnmoneyall"]];
        double returnm = [returnmoneyall doubleValue];
        self.m_shiJiHuiKuan.text = [NSString stringWithFormat:@"上年发货:%.2f",returnm];
        ;
        
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
    
    YeWuYuanHuiKuanChartView *chartView = [[YeWuYuanHuiKuanChartView alloc] init];
    if (_searchFlag == 1) {
        chartView.nameData = _searchNameArray;
        chartView.sendData = _searchCountArray;
        chartView.returnData =_searchMoneyArray;
    }else{
        chartView.nameData = _nameArray;
        chartView.sendData = _sendArray;
        chartView.returnData =_returnArray;
    }
    [self.navigationController pushViewController:chartView animated:YES];
    
}

@end
