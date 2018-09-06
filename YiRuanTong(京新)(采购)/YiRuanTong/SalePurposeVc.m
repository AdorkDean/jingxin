//
//  SalePurposeVc.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "SalePurposeVc.h"
#import "AFNetworking.h"
#import "DataPost.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "THCPModel.h"
#import "THCpInfoCell.h"
#import "SalePurposeCell.h"
#import "SalePurposeModel.h"
#import "CustModel.h"
#import "DWandLXModel.h"
#import "CommonModel.h"
@interface SalePurposeVc ()<UITextFieldDelegate>
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
    UIButton *_yearButton;
    UIButton *_monthButton;
    NSString *_salerId;
    UITextField *_salerField;
    NSMutableArray *_dataArray;
    UIButton *_areaButton;
    NSString *_areaId;
    NSMutableArray *_areaArray;
    NSMutableArray *_salerArray;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _salerpage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *areaTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;


@end

@implementation SalePurposeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _DataArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    _countArray = [[NSMutableArray alloc] init];
    _moneyArray = [[NSMutableArray alloc] init];
    _areaArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _salerArray = [NSMutableArray array];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchNameArray = [[NSMutableArray alloc]init];
    _searchCountArray = [[NSMutableArray alloc]init];
    _searchMoneyArray = [[NSMutableArray alloc]init];
    _page = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _salerpage = 1;
    // Do any additional setup after loading the view from its nib.
    self.title = @"销售目标对比";
    [self PageViewDidLoad];
    [self showBarWithName:@"搜索" addBarWithName:nil];
    [self initSearchView];
    
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

- (void)DataRequest
{
    /*
     action:"saleTarget"
     page	1
     rows	20
     params:"{"yearEQ":"2015","daxuan":"on","monthEQ":"","jiduEQ":"","accountidEQ":"","saletimeGE":"","saletimeLE":""}"
     */
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year =[dateFormatter stringFromDate:currentDate];
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:currentDate];
    NSLog(@"当前的年月%@  %@",year,month);
    //产品销售区域分析
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"saleTarget",@"params":[NSString stringWithFormat:@"{\"yearEQ\":\"%@\",\"daxuan\":\"\",\"monthEQ\":\"%@\",\"jiduEQ\":\"\",\"accountidEQ\":\"\",\"saletimeGE\":\"\",\"saletimeLE\":\"\"}",year,month]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"销售目标数据%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic  in array) {
                SalePurposeModel *model = [[SalePurposeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_DataArray addObject:model];
                NSString *str = [dic objectForKey:@"accountname"];
                [_nameArray addObject:str];
                NSString *str1 = [dic objectForKey:@"totalsendgoodsmoney"];
                [_countArray addObject:str1];
                NSString *str2 = [dic objectForKey:@"returnedmoney"];
                [_moneyArray addObject:str2];
                
            }
            [self.SalePurposeTableView reloadData];
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


-(void)DataRequest1
{
    /*
     action:"saleTarget"
     isstat	true
     */
    //总数量 和总金额
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year =[dateFormatter stringFromDate:currentDate];
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:currentDate];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"saleTarget",@"isstat":@"true",@"params":[NSString stringWithFormat:@"{\"yearEQ\":\"%@\",\"daxuan\":\"\",\"monthEQ\":\"%@\",\"jiduEQ\":\"\",\"accountidEQ\":\"\",\"saletimeGE\":\"\",\"saletimeLE\":\"\"}",year,month]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"销售目标总数%@",array);
        if (array.count != 0) {
            
            NSString *str1 =[NSString stringWithFormat:@"%@",array[0][@"totalsendgoodsmoneyall"]]; // 发货
            NSString *str2 =[NSString stringWithFormat:@"%@",array[0][@"returnedmoneyall"]]; //回款
            NSString *str3 =[NSString stringWithFormat:@"%@",array[0][@"totalsalesall"]];  //目标
            NSString *str4 =[NSString stringWithFormat:@"%@",array[0][@"tgperall"]];  //目标完成
            NSString *str5 =[NSString stringWithFormat:@"%@",array[0][@"reperall"]];  //回款
            _label1.text = [NSString stringWithFormat:@"发货:%@ | 回款:%@ | 目标:%@",str1,str2,str3];
            _label2.text = [NSString stringWithFormat:@"回款率:%@ | 完成率:%@",str5,str4];
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
    biaoTiView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:biaoTiView];
    
    _label1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, KscreenWidth - 20, 20)];
    _label1.textColor =[UIColor blackColor];
    _label1.backgroundColor =[UIColor clearColor];
    _label1.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:_label1];
    
    _label2 =[[UILabel alloc]initWithFrame:CGRectMake(10, 20, KscreenWidth - 20, 20)];
    _label2.textColor =[UIColor blackColor];
    _label2.backgroundColor =[UIColor clearColor];
    _label2.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:_label2];
    
    self.SalePurposeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.SalePurposeTableView.delegate = self;
    self.SalePurposeTableView.dataSource = self;
    self.SalePurposeTableView.rowHeight = 65;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.SalePurposeTableView addSubview:_refreshControl];
    [self.view addSubview:_SalePurposeTableView];
    //     下拉刷新
    _SalePurposeTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_SalePurposeTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _SalePurposeTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _SalePurposeTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_SalePurposeTableView.mj_footer endRefreshing];
    }];
}

#pragma mark UITableView DataSource AndDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.salerTableView) {
        return _salerArray.count;
    }else if (tableView == self.areaTableView){
        
        return _areaArray.count;
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
    SalePurposeCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell =(SalePurposeCell*)[[[NSBundle mainBundle]loadNibNamed:@"SalePurposeCell" owner:self options:nil]firstObject];
        
    }
    
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == self.SalePurposeTableView ) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.row];
            }
        }else{
            if(_DataArray.count != 0){
                cell.model = _DataArray[indexPath.row];
            }
        }
        return cell;
    }else if (tableView == self.salerTableView){
        if (_salerArray.count != 0) {
            CommonModel *model = _salerArray[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }else if (tableView == self.areaTableView){
        DWandLXModel *model = _areaArray[indexPath.row];
        cell2.textLabel.text = model.name;
        return cell2;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.SalePurposeTableView ) {
        
//        ChanPinXiaoShouChartView *chartVC = [[ChanPinXiaoShouChartView alloc] init];
//        chartVC.nameData =_nameArray;
//        chartVC.countData = _countArray;
//        chartVC.moneyData = _moneyArray;
//        [self.navigationController pushViewController:chartVC animated:YES];
    }else if (tableView == self.salerTableView){
        
        [self.m_keHuPopView removeFromSuperview];
        if (_salerArray.count!=0) {
            CommonModel *model = _salerArray[indexPath.row];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerId = model.Id;
        }
    }else if(tableView == self.areaTableView){
        
        [self .m_keHuPopView removeFromSuperview];
        DWandLXModel *model = _areaArray[indexPath.row];
        [_areaButton setTitle:model.name forState:UIControlStateNormal];
        _areaId = model.Id;
        
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
    ///
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
    Label1.text = @"销售员";
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
    //
//    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, _searchView.frame.size.width/3, 40)];
//    Label4.text = @"区域名称";
//    Label4.backgroundColor = COLOR(231, 231, 231, 1);
//    Label4.font = [UIFont systemFontOfSize:15.0];
//    Label4.textAlignment = NSTextAlignmentCenter;
//    
//    _areaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _areaButton.frame = CGRectMake(_searchView.frame.size.width/3, Label1.bottom + 1, _searchView.frame.size.width/3*2, 40);
//    [_areaButton addTarget:self action:@selector(areaAction) forControlEvents:UIControlEventTouchUpInside];
//    [_areaButton setTintColor:[UIColor blackColor]];
//    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , _searchView.frame.size.width, 1)];
//    view4.backgroundColor = [UIColor grayColor];
//    [_searchView addSubview:Label4];
//    [_searchView addSubview:_areaButton];
//    [_searchView addSubview:view4];
    //
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, _searchView.frame.size.width/3, 40)];
    Label2.text = @"开始时间";
    Label2.backgroundColor = COLOR(231, 231, 231, 1);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(_searchView.frame.size.width/3, Label1.bottom + 1, _searchView.frame.size.width/3*2, 40);
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, Label2.bottom , _searchView.frame.size.width, 1)];
    salerView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label2];
    [_searchView addSubview:_startButton];
    [_searchView addSubview:salerView];
    //
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label2.bottom + 1, _searchView.frame.size.width/3, 40)];
    Label3.text = @"结束时间";
    Label3.backgroundColor = COLOR(231, 231, 231, 1);
    Label3.font = [UIFont systemFontOfSize:15.0];
    Label3.textAlignment = NSTextAlignmentCenter;
    _endButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(_searchView.frame.size.width/3, Label2.bottom + 1, _searchView.frame.size.width/3*2, 40);
    [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, Label3.bottom, _searchView.frame.size.width, 1)];
    typeView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label3];
    [_searchView addSubview:_endButton];
    [_searchView addSubview:typeView];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, Label3.bottom+1, _searchView.frame.size.width/3, 40)];
    label4.text = @"年";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font = [UIFont systemFontOfSize:15.0];
    label4.textAlignment = NSTextAlignmentCenter;
    _yearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _yearButton.frame = CGRectMake(_searchView.frame.size.width/3, Label3.bottom + 1, _searchView.frame.size.width/3*2, 40);
    [_yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_yearButton addTarget:self action:@selector(yearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* yearView = [[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom+1, _searchView.frame.size.width, 1)];
    yearView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:label4];
    [_searchView addSubview:_yearButton];
    [_searchView addSubview:yearView];
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, label4.bottom+1, _searchView.frame.size.width/3, 40)];
    label5.text = @"月";
    label5.backgroundColor = COLOR(231, 231, 231, 1);
    label5.font = [UIFont systemFontOfSize:15.0];
    label5.textAlignment = NSTextAlignmentCenter;
    _monthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _monthButton.frame = CGRectMake(_searchView.frame.size.width/3, label4.bottom+1, _searchView.frame.size.width/3*2, 40);
    [_monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_monthButton addTarget:self action:@selector(monthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* monthView = [[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom+1, _searchView.frame.size.width, 1)];
    monthView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:label5];
    [_searchView addSubview:_monthButton];
    [_searchView addSubview:monthView];
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor grayColor];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, label5.bottom + 20, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:[UIColor grayColor]];
    [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, label5.bottom + 20, 60, 30);
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
//区域
- (void)areaAction{
    
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
    if (self.areaTableView == nil) {
        self.areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 20,KscreenWidth-120, KscreenHeight-114) style:UITableViewStylePlain];
        self.areaTableView.backgroundColor = [UIColor whiteColor];
    }
    self.areaTableView.dataSource = self;
    self.areaTableView.delegate = self;
    self.areaTableView.rowHeight = 45;
    [self.m_keHuPopView addSubview:self.areaTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self areaRquest];
    
}
- (void)areaRquest{
    /*
     syscate
     action: getSelectForMobile
     params :{\"type\":\"custarea\"}
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/syscate?action=getSelectForMobile"];
    NSDictionary *params = @{@"action":@"getSelectForMobile",@"params":@"{\"type\":\"custarea\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"区域名称数据%@",array);
        _areaArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            DWandLXModel *model = [[DWandLXModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_areaArray addObject:model];
        }
        [self.areaTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
}

//产品
- (void)salerAction{
    
    _salerButton.userInteractionEnabled = NO;
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.m_keHuPopView addSubview:bgView];
//    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _salerField.backgroundColor = [UIColor whiteColor];
    _salerField.delegate = self;
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
    [btn addTarget:self action:@selector(searchsaler) forControlEvents:UIControlEventTouchUpInside];//getSalerName
//    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _salerField.bottom+5,bgView.width-40, bgView.height - _salerField.bottom - 5) style:UITableViewStylePlain];
        // self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.rowHeight = 50;
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
- (void)getSalerName{
    /*params:"{"nameLIKE":"he"}"*/
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"业务员点击后返回:%@",array);
        [_salerArray removeAllObjects];
        for (NSDictionary *dic  in  array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_salerArray addObject:model];
        }
        [self.salerTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员加载失败");
    }];
    
    
}
- (void)salerRequest{
    [_salerArray removeAllObjects];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"业务员点击后返回:%@",array);
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_salerArray addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员加载失败");
    }];
    
}

- (void)searchsaler{
      MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_salerpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    if (_salerpage == 1) {
        [_salerArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                NSLog(@"业务员点击后返回:%@",array);
                for (NSDictionary *dic  in  array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_salerArray addObject:model];
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
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth,240)];
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

- (void)yearBtnClick:(UIButton*)sender
{
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
    [self.datePicker addTarget:self action:@selector(dateChange2:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
//    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
- (void)dateChange2:(id)sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_yearButton setTitle:dateString forState:UIControlStateNormal];
}

- (void)monthBtnClick:(UIButton*)sender
{
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
    [self.datePicker addTarget:self action:@selector(dateChange3:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
//    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
- (void)dateChange3:(id)sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"MM"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_monthButton setTitle:dateString forState:UIControlStateNormal];
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
     action:"proSaleArea"
     tjlx:"detail"
     page:"1"
     rows:"100"
     params:"{"pronameLIKE":"金毒克","specificationLIKE":"","departidEQ":"","departnameLIKE":"","saletimeGE":"2015-08-12","saletimeLE":"2015-09-12"}"
     {"pronameLIKE":"金毒克","specificationLIKE":"","departidEQ":"226","departnameLIKE":"季广飞区域","saletimeGE":"2015-08-14","saletimeLE":"2015-09-14"}
     */
    _salerId = [self convertNull:_salerId];
    NSString *depart = _areaButton.titleLabel.text;
    depart = [self convertNull:depart];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    NSString *end = _endButton.titleLabel.text;
    end = [self convertNull: end];
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([depart isEqualToString:@" "]&&[start isEqualToString:@" "]&&[end isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"action":@"saleTarget",@"params":[NSString stringWithFormat:@"{\"yearEQ\":\"\",\"daxuan\":\"\",\"monthEQ\":\"\",\"jiduEQ\":\"\",\"accountidEQ\":\"%@\",\"saletimeGE\":\"%@\",\"saletimeLE\":\"%@\"}",_salerId,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"销售目标数据%@",dic);
            if (array.count != 0) {
                for (NSDictionary *dic  in array) {
                    SalePurposeModel *model = [[SalePurposeModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                    NSString *str = [dic objectForKey:@"accountname"];
                    [_searchNameArray addObject:str];
                    NSString *str1 = [dic objectForKey:@"totalsendgoodsmoney"];
                    [_searchCountArray addObject:str1];
                    NSString *str2 = [dic objectForKey:@"returnedmoney"];
                    [_searchMoneyArray addObject:str2];
                }
            }
            [self.SalePurposeTableView reloadData];
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
    
    _barHideBtn.hidden = YES;
    _searchView.hidden = YES;
    _backView.hidden = YES;
}

-(void)getAll
{
    /*
     action:"saleTarget"
     isstat	true
     */
    //总数量 和总金额
    _salerId = [self convertNull:_salerId];
    NSString *depart = _areaButton.titleLabel.text;
    depart = [self convertNull:depart];
    NSString *start = _startButton.titleLabel.text;
    start = [self convertNull:start];
    NSString *end = _endButton.titleLabel.text;
    end = [self convertNull: end];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/report"];
    NSDictionary *params = @{@"action":@"saleTarget",@"isstat":@"true",@"params":[NSString stringWithFormat:@"{\"yearEQ\":\"\",\"daxuan\":\"\",\"monthEQ\":\"\",\"jiduEQ\":\"\",\"accountidEQ\":\"%@\",\"saletimeGE\":\"%@\",\"saletimeLE\":\"%@\"}",_salerId,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"销售目标总数%@",array);
        if (array.count != 0) {
            
            NSString *str1 =[NSString stringWithFormat:@"%@",array[0][@"totalsendgoodsmoneyall"]]; // 发货
            NSString *str2 =[NSString stringWithFormat:@"%@",array[0][@"returnedmoneyall"]]; //回款
            NSString *str3 =[NSString stringWithFormat:@"%@",array[0][@"totalsalesall"]];  //目标
            NSString *str4 =[NSString stringWithFormat:@"%@",array[0][@"tgperall"]];  //目标完成
            NSString *str5 =[NSString stringWithFormat:@"%@",array[0][@"reperall"]];  //回款
            _label1.text = [NSString stringWithFormat:@"发货:%@ | 回款:%@ | 目标:%@",str1,str2,str3];
            _label2.text = [NSString stringWithFormat:@"回款率:%@ | 完成率:%@",str5,str4];
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
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *year =[dateFormatter stringFromDate:currentDate];
        [dateFormatter setDateFormat:@"MM"];
        NSString *month = [dateFormatter stringFromDate:currentDate];
        [_yearButton setTitle:year forState:UIControlStateNormal];
        [_monthButton setTitle:month forState:UIControlStateNormal];
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
    }
    
}
- (void)searchAction{
    
    
}

@end
