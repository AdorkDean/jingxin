//
//  CPFahuoDuiBiSearchVC.m
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CPFahuoDuiBiSearchVC.h"
#import "UIViewExt.h"
#import "AFNetworking.h"
#import "DataPost.h"
#import "THCPModel.h"
#import "zySheetPickerView.h"
@interface CPFahuoDuiBiSearchVC ()
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation CPFahuoDuiBiSearchVC
{
    UIButton *_salerButton;
    UIButton *_areaButton;
    UIButton *_startButton;
    UIButton *_endButton;
    //搜索
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    UIView *_timeView;
    NSString *_salerId;
    NSString * _proName;
    UITextField *_custField;
    NSMutableArray *_dataArray;
    NSString *_areaId;
    NSMutableArray *_areaArray;
    
    NSString *_pastDateStr;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _propage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [[NSMutableArray alloc]init];
    _areaArray = [[NSMutableArray alloc]init];
    [self getDateStr];
    [self createUIview];
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
- (void)createUIview{
    ///
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    Label1.text = @"客户名称";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    
    _salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    [_salerButton setTintColor:UIColorFromRGB(0x999999)];
    [_salerButton setTitle:@"请选择产品" forState:UIControlStateNormal];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*MYWIDTH, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label1];
    [self.view addSubview:_salerButton];
    [self.view addSubview:nameView];
    //
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label2.text = @"时间";
    Label2.backgroundColor = COLOR(231, 231, 231, 1);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(KscreenWidth/3, Label1.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_startButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_startButton setTitle:@"2018" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, Label2.bottom , KscreenWidth, 1)];
    salerView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label2];
    [self.view addSubview:_startButton];
    [self.view addSubview:salerView];
    
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, _endButton.bottom)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:fenGeXian];
    //
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, salerView.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, salerView.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)salerAction{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //    self.m_keHuPopView.alpha = 0.5;
    //
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
    
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.placeholder = @"名称关键字";
    //    _proField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_custField addSubview:line2];
    _custField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_proField];
    [bgView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, _custField.top, 60, _custField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchpro) forControlEvents:UIControlEventTouchUpInside];
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
        //        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.tag = 102;
    self.salerTableView.rowHeight = 80;
    //    [self.m_keHuPopView addSubview:self.proTableView];
    [bgView addSubview:self.salerTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _propage = 1;
        [_dataArray removeAllObjects];
        [self searchpro];
        // 结束刷新
        [self.salerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _propage ++ ;
        [self searchpro];
        [self.salerTableView.mj_footer endRefreshing];
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    
    //    [self proRequest];
    _propage = 1;
    [self searchpro];
}
#pragma mark - 产品名称请求方法
- (void)searchpro{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *proName = _custField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getMBProduct",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"table":@"cpxx",@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\"}",proName]};
    if (_propage == 1) {
        [_dataArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    THCPModel *model = [[THCPModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.salerTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
}
//- (void)salerAction{
//    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
//    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
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
//    //    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
//    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
//    _custField.backgroundColor = [UIColor whiteColor];
//    _custField.delegate = self;
//    _custField.tag =  101;
//    _custField.placeholder = @"名称关键字";
//    //    _custField.borderStyle = UITextBorderStyleRoundedRect;
//    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
//    line2.backgroundColor=[UIColor lightGrayColor];
//    [_custField addSubview:line2];
//    _custField.font = [UIFont systemFontOfSize:13];
//    //    [self.m_keHuPopView addSubview:_custField];
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
//    //    [self.m_keHuPopView addSubview:btn];
//    [bgView addSubview:btn];
//
//    if (self.salerTableView == nil) {
//        //        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
//        self.salerTableView.backgroundColor = [UIColor whiteColor];
//    }
//    self.salerTableView.dataSource = self;
//    self.salerTableView.delegate = self;
//    self.salerTableView.tag = 10;
//    self.salerTableView.rowHeight = 45;
//    [bgView addSubview:self.salerTableView];
//    //    [self.m_keHuPopView addSubview:self.salerTableView];
//    //    [self.view addSubview:self.m_keHuPopView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    //    [self nameRequest];
//    //     下拉刷新
//    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _propage = 1;
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
//        _propage ++ ;
//        [self searchcust];
//        [self.salerTableView.mj_footer endRefreshing];
//
//    }];
//    _propage = 1;
//    [self searchcust];
//
//}
//- (void)getName{
//
//    NSString *custName = _custField.text;
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = [NSString stringWithFormat:@"action=getSelectName&params={\"nameLIKE\":\"%@\"}",custName];
//    NSLog(@"客户名称信息搜索 = %@",str);
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"客户数据数据%@",array);
//        [_dataArray removeAllObjects];
//        for (NSDictionary *dic in array) {
//            CustModel *model = [[CustModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:model];
//        }
//        [self.salerTableView reloadData];
//
//    }
//
//}
//
//
//- (void)nameRequest
//{
//    //客户名称 的浏览接口
//    NSLog(@"页数%zi",_page);
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
//    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"action":@"getSelectName",@"table":@"khxx"};
//    if (_propage == 1) {
//        [_dataArray removeAllObjects];
//    }
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSArray *array = dic[@"rows"];
//        NSLog(@"客户数据%@",dic);
//        for (NSDictionary *dic in array) {
//            CustModel *model = [[CustModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:model];
//        }
//        [self.salerTableView reloadData];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"客户名称加载失败");
//    }];
//
//}
//
//- (void)searchcust{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
//    NSString *custName = _custField.text;
//    custName = [self convertNull:custName];
//
//
//    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
//    NSDictionary *params = @{@"action":@"getSelectName",@"table":@"khxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
//    if (_propage == 1) {
//        [_dataArray removeAllObjects];
//    }
//    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        if([[dic allKeys] containsObject:@"rows"])
//        {
//            NSArray *array = dic[@"rows"];
//            if (array.count!=0) {
//                NSLog(@"客户名称数据:%@",array);
//                for (NSDictionary *dic in array) {
//                    CustModel *model = [[CustModel alloc] init];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [_dataArray addObject:model];
//                }
//                [self.salerTableView reloadData];
//            }
//
//        }
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"业务员加载失败");
//        [hud removeFromSuperview];
//    }];
//
//}
#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (_dataArray.count!=0) {
        THCPModel *model = _dataArray[indexPath.row];
        cell1.textLabel.text = model.proname;
    }
    return cell1;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.m_keHuPopView removeFromSuperview];
//    if (_dataArray.count!=0) {
//        THCPModel *model = _dataArray[indexPath.row];
//        [_salerButton setTitle:model.name forState:UIControlStateNormal];
//        _salerId = model.Id;
//    }
    if (_dataArray.count!=0) {
        THCPModel *model = _dataArray[indexPath.row];
        [_salerButton setTitle:model.proname forState:UIControlStateNormal];
        _salerId = [NSString stringWithFormat:@"%@",model.Id];
        _proName = [NSString stringWithFormat:@"%@",model.proname] ;
        _salerButton.userInteractionEnabled = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  45;
    
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
    NSArray * str  = @[@"2014",@"2015",@"2016",@"2017",@"2018"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"日期选择" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        [_startButton setTitle:choiceString forState:UIControlStateNormal];
        [pickerView dismissPicker];
    }];
    [pickerView show];
    //    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    //    _timeView.backgroundColor = [UIColor whiteColor];
    //    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //    //
    //    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    //    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    //    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    //    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    //    [_timeView addSubview:_hide_keHuPopViewBut];
    //    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-270, KscreenWidth, 270)];
    //    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    //    [_timeView addSubview:bgView];
    //    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 240)];
    //    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 30)];
    //    [button setTitle:@"完成" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    //    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    //    [bgView addSubview:button];
    //
    //    self.datePicker.datePickerMode = UIDatePickerModeDate;
    //    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    //    self.datePicker.backgroundColor = [UIColor whiteColor];
    //    [bgView addSubview:_datePicker];
    //    //    [self.view addSubview:_timeView];
    //    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
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
- (void)chongZhi
{
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
    [_startButton setTitle:@"2018" forState:UIControlStateNormal];
    [_endButton setTitle:@" " forState:UIControlStateNormal];
    
}
-(void)search{
    NSString *_saler = _salerButton.titleLabel.text;
    if ([_saler isEqualToString:@"请选择客户"]) {
        _saler = @"";
    }
    if (_block) {
        self.block(_salerId, _startButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
