//
//  TongjiSearchVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "TongjiSearchVC.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "KHmanageModel.h"
#import "CommonModel.h"
#import "KHnameModel.h"
#import "CustCell.h"
#import "THCPModel.h"
#import "TongjiModel.h"
@interface TongjiSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)NSMutableArray *dataArray;//客户名
@property(nonatomic,retain)NSMutableArray *salerArray;//业务员
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation TongjiSearchVC
{
    UITextField *_orderTextfield;
    UIButton *_custButton;
    UIButton *_salerButton;
    UIButton *_startButton;
    UIButton *_endButton;
    
    NSString *_custId;
    NSString *_salerID;
    NSString * _proName;
    
    UITextField *_custField;
    UITextField *_salerField;
    
    UIView *_timeView;
    NSInteger _page;
    UIButton* _hide_keHuPopViewBut;
    NSString *_currentDateStr;
    NSString * _pastDateStr;
    NSInteger _custpage;
    NSInteger _salerpage;
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
    _salerArray = [[NSMutableArray alloc]init];
    _page = 1;
    _custpage = 1;
    _salerpage = 1;
    //    NSDate *currentDa
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
    
    UILabel *selectProLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    selectProLabel.text = @"姓名";
    selectProLabel.textColor = UIColorFromRGB(0x333333);
    selectProLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    selectProLabel.font = [UIFont systemFontOfSize:15.0];
    selectProLabel.textAlignment = NSTextAlignmentCenter;
    _salerButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton setTitle:@"请选择姓名" forState:UIControlStateNormal];
    [_salerButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, selectProLabel.bottom, KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:selectProLabel];
    [self.view addSubview:_salerButton];
    [self.view addSubview:typeView];
    
    //
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, typeView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    startLabel.text = @"开始时间";
    startLabel.textColor = UIColorFromRGB(0x333333);
    startLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    startLabel.font = [UIFont systemFontOfSize:15.0];
    startLabel.textAlignment = NSTextAlignmentCenter;
    _startButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(KscreenWidth/3, typeView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_startButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, startLabel.bottom, KscreenWidth, 1)];
    startView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:startLabel];
    [self.view addSubview:_startButton];
    [self.view addSubview:startView];
    
    //
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    endLabel.text = @"结束时间";
    endLabel.textColor = UIColorFromRGB(0x333333);
    endLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    endLabel.font = [UIFont systemFontOfSize:15.0];
    endLabel.textAlignment = NSTextAlignmentCenter;
    _endButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(KscreenWidth/3, startView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_endButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, endLabel.bottom, KscreenWidth, 1)];
    endView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:endLabel];
    [self.view addSubview:_endButton];
    [self.view addSubview:endView];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, endView.bottom)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:fenGeXian];
    
    //
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, fenGeXian.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, fenGeXian.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)search{
//    if ([_salerButton.titleLabel.text isEqualToString:@"请选择姓名"]) {
//        [self showAlert:@"请选择姓名"];
//        return;
//    }
    NSString *_saler = _salerButton.titleLabel.text;
    if ([_saler isEqualToString:@"请选择姓名"]) {
        _saler = @"";
        _salerID = @"";
    }
    if (_block) {
        self.block(_salerID, _proName, _startButton.titleLabel.text, _endButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
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

    
    if (self.salerTableView == nil) {
        //        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _salerField.bottom+5,bgView.width-40, bgView.height - _salerField.bottom - 5) style:UITableViewStylePlain];
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
        _salerpage = 1;
        [_dataArray removeAllObjects];
        [self searchpro];
        // 结束刷新
        [self.salerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _salerpage ++ ;
        [self searchpro];
        [self.salerTableView.mj_footer endRefreshing];
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    
    //    [self proRequest];
    _salerpage = 1;
    [self searchpro];
}
#pragma mark - 产品名称请求方法
- (void)searchpro{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
//    NSString *proName = _salerField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_salerpage],@"action":@"getCountDepart",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"isstop\":\"%@\",\"dateGE\":\"%@\",\"dateLE\":\"%@\"}",@"",@"0",_pastDateStr,_currentDateStr]};
    if (_salerpage == 1) {
        [_salerArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    TongjiModel *model = [[TongjiModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_salerArray addObject:model];
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
//开始时间
- (void)startAction{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,KscreenHeight)];
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
    [_startButton setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
//结束时间
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
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
- (void)chongZhi
{
    [_salerButton setTitle:@""forState:UIControlStateNormal];
    _salerButton.titleLabel.text = @"";
    _salerID = @"";
    [_startButton setTitle:@""forState:UIControlStateNormal];
    [_endButton setTitle:@""forState:UIControlStateNormal];
    _startButton.titleLabel.text = @"";
    _endButton.titleLabel.text = @"";
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

- (void)closePop
{
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
        [_orderTextfield resignFirstResponder];
        [_salerField resignFirstResponder];
    }else{
        _custButton.userInteractionEnabled = YES;
        _salerButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        [self.custTableView removeFromSuperview];
        [self.salerTableView removeFromSuperview];
    }
    
}
#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.custTableView){
        return _dataArray.count;
    }else{
        return _salerArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    if (tableView == self.salerTableView){
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        if (_salerArray.count != 0) {
            
            TongjiModel *model = _salerArray[indexPath.row];
            cell2.textLabel.text = model.name;
        }
        return cell2;
    }
    
    
    CustCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"CustCell"];
    if (cell3 == nil) {
        cell3 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell3.backgroundColor = [UIColor whiteColor];
    }
    if (tableView == self.custTableView){
        if (_dataArray.count!=0) {
            cell3.model = _dataArray[indexPath.row];
        }
        return cell3;
    }
    
    return cell3;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.custTableView){
        if (_dataArray.count!=0) {
            KHnameModel *model = _dataArray[indexPath.row];
            [_custButton setTitle:model.name forState:UIControlStateNormal];
            _custButton.userInteractionEnabled = YES;
            _custId = [NSString stringWithFormat:@"%@",model.Id];
        }
        
    }else if (tableView == self.salerTableView){
        if (_salerArray.count!=0) {
            TongjiModel *model = _salerArray[indexPath.row];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerID = [NSString stringWithFormat:@"%@",model.Id];
            _proName = [NSString stringWithFormat:@"%@",model.name] ;
            _salerButton.userInteractionEnabled = YES;
        }
    }
    [self.m_keHuPopView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  45;
    
}
@end
