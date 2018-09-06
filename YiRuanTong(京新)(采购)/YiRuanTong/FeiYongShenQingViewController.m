//
//  FeiYongShenQingViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FeiYongShenQingViewController.h"
#import "MBProgressHUD.h"
#import "FYSQModel.h"
#import "YeWuYuanModel.h"
#import "FYSQLiuLanCell.h"
#import "FYSQLiuLanView.h"
#import "FYSQShenPiView.h"
#import "FYSQShangBaoViewController.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CommonModel.h"
@interface FeiYongShenQingViewController ()<UITextFieldDelegate>{

    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIView *_searchView;
    UIView *_backView;
    UIView *_timeView;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    
    
    NSMutableArray *_typeArray;
    NSMutableArray *_typeIdArray;
    NSArray *_spArray;
    
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    
    UIButton *_startButton;
    UIButton *_endButton;
    UIButton *_currentBtn;
    UIButton *_liuLanButton;
    UIButton *_shenPiButton;
    UIButton *_salerButton;
    NSString *_salerId;
    UITextField *_salerField;
    NSMutableArray *_salerArray;
    
    NSMutableArray *_btnArray;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *typeTableView;
@property(nonatomic,retain)UITableView *spTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;


@end

@implementation FeiYongShenQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _btnArray = [[NSMutableArray alloc] init];
    
    _typeIdArray = [[NSMutableArray alloc] init];
    _typeArray = [[NSMutableArray alloc] init];
    _salerArray = [NSMutableArray array];
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    
    self.title = @"费用申请";
    [self PageViewDidLoad];
    [self PageViewDidLoad1];
    //搜索视图
    [self searchView];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(request) object:nil];
    [thread start];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    
    
    
    
}

- (void)request
{
    [self DataRequest];
    [self DataRequest1];
}

- (void)searchView{
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
    Label1.text = @"上报人";
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
    Label2.text = @"上报日期";
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
    Label3.text = @"审批状态";
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
    //    //
    //    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, _searchView.frame.size.width/3, 40)];
    //    Label4.text = @"上报日期";
    //    Label4.backgroundColor = COLOR(231, 231, 231, 1);
    //    Label4.font = [UIFont systemFontOfSize:15.0];
    //    Label4.textAlignment = NSTextAlignmentCenter;
    //    _startButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    //    _startButton.frame = CGRectMake(_searchView.frame.size.width/3, 123, _searchView.frame.size.width/3*2, 40);
    //    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    //    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, 163, _searchView.frame.size.width, 1)];
    //    startView.backgroundColor = [UIColor grayColor];
    //    [_searchView addSubview:Label4];
    //    [_searchView addSubview:_startButton];
    //    [_searchView addSubview:startView];
    //    //
    //    UILabel *Label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 164, _searchView.frame.size.width/3, 40)];
    //    Label5.text = @"至";
    //    Label5.backgroundColor = COLOR(231, 231, 231, 1);
    //    Label5.font = [UIFont systemFontOfSize:15.0];
    //    Label5.textAlignment = NSTextAlignmentCenter;
    //    _endButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    //    _endButton.frame = CGRectMake(_searchView.frame.size.width/3, 164, _searchView.frame.size.width/3*2, 40);
    //    [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    //    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, 204, _searchView.frame.size.width, 1)];
    //    endView.backgroundColor = [UIColor grayColor];
    //    [_searchView addSubview:Label5];
    //    [_searchView addSubview:_endButton];
    //    [_searchView addSubview:endView];
    //    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 204)];
    //    fenGeXian.backgroundColor = [UIColor grayColor];
    //    [_searchView addSubview:fenGeXian];
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
    
    _backView.hidden = YES;
    _searchView.hidden = YES;
}
- (void)salerAction{
    
    //上报人
    _salerButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _salerField.backgroundColor = [UIColor whiteColor];
    _salerField.delegate = self;
    
    _salerField.placeholder = @"名称关键字";
    _salerField.borderStyle = UITextBorderStyleRoundedRect;
    _salerField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_salerField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_salerField.right, 40, 60, 40);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(getSalerName) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        // self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self salerRequest];
    
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
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
    
}
- (void)salerRequest{
    
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
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
}
- (void)closePop
{
    _salerButton.userInteractionEnabled = YES;
    
    [self.m_keHuPopView removeFromSuperview];
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

- (void)souSuoButtonClickMethod
{
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
    }
}
#pragma mark - 搜索方法

- (void)search
{   /*
     costapply
     action:"getReimBeans"
     table:"fybx"
     page:"1"
     rows:"20"
     params:"{"table":"fybx","applyeridEQ":"1","applytimeGE":"2015-05-04","applytimeLE":"2015-05-11"}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getReimBeans"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=fybx&rows=20&page=%zi&params={\"table\":\"fybx\",\"applyeridEQ\":\"%@\",\"applytimeGE\":\"%@\",\"applytimeLE\":\"%@\"}",_page3,_salerId,_startButton.titleLabel.text,_endButton.titleLabel.text];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"搜索字符串%@",str);
        NSLog(@"搜索返回%@",array);
        
        [_dataArray1 removeAllObjects];
        [_dataArray2 removeAllObjects];
        for (NSDictionary *dic in array) {
            
            FYSQModel *model = [[FYSQModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
            [_dataArray2 addObject:model];
        }
        [_HUD hide:YES];
        [self.liuLanTableView reloadData];
        [self.shenPiTableView reloadData];
        _searchView.hidden = YES;
        _backView.hidden = YES;
    }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }
    
}

- (void)chongZhi
{
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
    
    [_startButton setTitle:@" " forState:UIControlStateNormal];
    
    [_endButton setTitle:@" " forState:UIControlStateNormal];
    
}

#pragma mark - 费用浏览审批数据
- (void)DataRequest
{   /*
     costapply
     action:"getBeans"
     table:"fysq"
     page:"1"
     rows:"20"
     */
    //自定义审批列表的浏览接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getBeans"];
    NSDictionary *params = @{@"action":@"getBeans",@"table":@"fysq",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page1]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"浏览数据%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                FYSQModel *model = [[FYSQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
        }
        
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        NSLog(@"费用浏览列表的返回数据:%@",array);
        [self.liuLanTableView reloadData];
        
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

- (void)DataRequest1
{
    /*
     action:"getSPBeans"
     table:"fysq"
     sort:"applytime"
     order:"desc"
     page:"1"
     rows:"20"
     params:"{"table":"fysq","applyeridEQ":"","costtypeidEQ":"","applytimeGE":"","applytimeLE":"","isspEQ":"0"}"
     */
    //自定义审批列表审批的接口
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=getSPBeans"];
    NSDictionary *params = @{@"action":@"getBeans",@"table":@"fysq",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page2],@"params":@"{\"isspEQ\":\"0\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                FYSQModel *model = [[FYSQModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray2 addObject:model];
            }
        }
        
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        NSLog(@"费用批复列表的返回:%@",array);
        [self.shenPiTableView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //  [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
}

- (void)PageViewDidLoad
{
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setImage:[UIImage imageNamed:@"menu_add"] forState:UIControlStateNormal];
    [AddButton setTintColor:[UIColor whiteColor]];
    [AddButton addTarget:self action:@selector(AddAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)AddAction:(UIButton *)button{
    FYSQShangBaoViewController *FYSQVC = [[FYSQShangBaoViewController alloc] init];
    [self.navigationController pushViewController:FYSQVC animated:YES];
}

- (void)PageViewDidLoad1
{
    //标题下方的2个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 49)];
    buttonView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, KscreenWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttonView];
    [self.view addSubview:line];
    //搜索按钮
    self.souSuoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.souSuoButton.frame = CGRectMake(5, 5, 40, 40);
    [self.souSuoButton setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [buttonView addSubview:self.souSuoButton];
    [self.souSuoButton addTarget:self action:@selector(souSuoButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //2个按钮的设置
    _liuLanButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, (KscreenWidth - 50)/2, 49)];
    [_liuLanButton setTitle:@"浏览" forState:UIControlStateNormal];
    _liuLanButton.tag = 0;
    _liuLanButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_liuLanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_liuLanButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _liuLanButton.backgroundColor = [UIColor whiteColor];
    
    [_liuLanButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _currentBtn = _liuLanButton;
    _currentBtn.selected = YES;
    [buttonView addSubview:_liuLanButton];
    [_btnArray addObject:_liuLanButton];
    
    _shenPiButton = [[UIButton alloc] initWithFrame:CGRectMake(50 + (KscreenWidth - 50)/2,0 , (KscreenWidth - 50)/2,49)];
    [_shenPiButton setTitle:@"审批" forState:UIControlStateNormal];
    _shenPiButton.tag = 1;
    [_shenPiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shenPiButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [_shenPiButton setBackgroundColor:[UIColor lightGrayColor]];
    
    [_shenPiButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _shenPiButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [buttonView addSubview:_shenPiButton];
    [_btnArray addObject:_shenPiButton];
    //标题下方View的设置;
    //UIScrollerView
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114)];
    self.mainScrollView.contentSize = CGSizeMake(KscreenWidth*2, KscreenHeight-114);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    //scrollView上面的2个tableview实例化 并且添加到scrollView上去
    self.liuLanTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.liuLanTableView.delegate = self;
    self.liuLanTableView.dataSource = self;
    self.liuLanTableView.tag = 10;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.liuLanTableView addSubview:_refreshControl];
    [self.mainScrollView addSubview:self.liuLanTableView];
    //     下拉刷新
    self.liuLanTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.liuLanTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.liuLanTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.liuLanTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [self.liuLanTableView.mj_footer endRefreshing];
    }];
    
    self.shenPiTableView = [[UITableView alloc] initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-114) style:UITableViewStylePlain];
    self.shenPiTableView.delegate = self;
    self.shenPiTableView.dataSource = self;
    self.shenPiTableView.tag = 20;
//    _refreshControl2 = [[UIRefreshControl alloc] init];
//    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
//    [self.shenPiTableView addSubview:_refreshControl2];
    [self.mainScrollView addSubview:self.shenPiTableView];
    //     下拉刷新
    self.shenPiTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown2];
        // 结束刷新
        [self.shenPiTableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.shenPiTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.shenPiTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh2];
        [self.shenPiTableView.mj_footer endRefreshing];
    }];
}

- (void)selectBtn:(UIButton *)btn
{
    if (btn != _currentBtn)
    {
        _currentBtn.selected = NO;
        _currentBtn.backgroundColor = [UIColor lightGrayColor];
        _currentBtn = btn;
    }
    _currentBtn.selected = YES;
    _currentBtn.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView setContentOffset:CGPointMake(btn.tag * KscreenWidth, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else {
        int i = scrollView.contentOffset.x/KscreenWidth;
        for (int j = 0; j < _btnArray.count; j++) {
            if (j == i) {
                if (_btnArray[i] != _currentBtn) {
                    _currentBtn.selected = NO;
                    _currentBtn.backgroundColor = [UIColor lightGrayColor];
                    _currentBtn = _btnArray[i];
                }
                _currentBtn.selected = YES;
                _currentBtn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
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
    _page1 = 1;
    [self DataRequest];
    
    [_refreshControl endRefreshing];
}

- (void)refreshData2
{
    //开始刷新
    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl2 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown2) userInfo:nil repeats:NO];
}

- (void)refreshDown2
{
    [_dataArray2 removeAllObjects];
    _page2 = 1;
    [self DataRequest1];
    [_refreshControl2 endRefreshing];
}

- (void)upRefresh1
{
    [_HUD show:YES];
    _page1++;
    [self DataRequest];
}

- (void)upRefresh2
{
    [_HUD show:YES];
    _page2++;
    [self DataRequest1];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh1];
        }
    } else if (scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh2];
        }
    }
}

#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.liuLanTableView) {
        return _dataArray1.count;
    }
    else if(tableView == self.shenPiTableView){
        return _dataArray2.count;
    }else if(tableView == self.salerTableView){
        return _salerArray.count;
        
    }else if(tableView == self.typeTableView){
        return _typeArray.count;
    }else{
        return _spArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    FYSQLiuLanCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell =(FYSQLiuLanCell *) [[[NSBundle mainBundle] loadNibNamed:@"FYSQLiuLanCell" owner:self options:nil]firstObject];
    }
    FYSQLiuLanCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(FYSQLiuLanCell*)[[[NSBundle mainBundle] loadNibNamed:@"FYSQLiuLanCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView == self.liuLanTableView)
    {
        if (_dataArray1.count != 0) {
            FYSQModel *model = [_dataArray1 objectAtIndex:indexPath.row];
           
            cell.applyMoney.text = [NSString stringWithFormat:@"金额：%@",model.applymoney];
            cell.applyer.text = [NSString stringWithFormat:@"%@ | %@",model.applyer,model.applytime];
            
            NSString *isreply = [NSString stringWithFormat:@"%@",model.spstatus];
            NSInteger i = [isreply intValue];
            if (i == 0) {
                cell.spStatus.text = @"未批复";
                cell.spStatus.textColor = [UIColor orangeColor];
            }
            else if(i == 1)
            {
                cell.spStatus.text = @"已批复";
                cell.spStatus.textColor = [UIColor blackColor];
            }else if (i == 2){
                cell.spStatus.text = @"转特批";
                cell.spStatus.textColor = [UIColor orangeColor];
            }
            
            return cell;
        }
    } else if(tableView == self.shenPiTableView) {
        if (_dataArray2.count != 0) {
            FYSQModel *model = [_dataArray2 objectAtIndex:indexPath.row];
            
            cell1.applyMoney.text = [NSString stringWithFormat:@"金额：%@",model.applymoney];
            cell1.applyer.text = [NSString stringWithFormat:@"%@ | %@",model.applyer,model.applytime];
            
            NSString *isreply =[NSString stringWithFormat:@"%@",model.spstatus];
            NSInteger i = [isreply intValue];
            if (i == 0) {
                cell1.spStatus.text = @"未审批";
                cell1.spStatus.textColor = [UIColor orangeColor];
            }
            else if(i == 1)
            {
                cell1.spStatus.text = @"已审批";
                cell1.spStatus.textColor = [UIColor blackColor];
            }else if(i == 2){
                cell1.spStatus.text = @"转特批";
                cell1.spStatus.textColor = [UIColor orangeColor];
                
            }
                        return cell1;
        }
    } else if (tableView == self.salerTableView){
        CommonModel *model = _salerArray[indexPath.row];
        cell2.textLabel.text = model.name;
        return cell2;
    } else if(tableView == self.typeTableView){
        NSString *type = _typeArray[indexPath.row];
        cell2.textLabel.text = type;
        return cell2;
    } else if(tableView == self.spTableView){
        NSString *sp = _spArray[indexPath.row];
        cell2.textLabel.text = sp;
        return cell2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView){
        FYSQLiuLanView *liulan = [[FYSQLiuLanView alloc] init];
        FYSQModel *model = [_dataArray1 objectAtIndex:indexPath.row];
        liulan.model = model;
        [self.navigationController pushViewController:liulan animated:YES];
    } else if (tableView == self.shenPiTableView){
        FYSQShenPiView *shenPi =[[FYSQShenPiView alloc] init];
        FYSQModel *model = [_dataArray2 objectAtIndex:indexPath.row];
        shenPi.model = model;
        [self.navigationController pushViewController:shenPi animated:YES];
    } else if (tableView == self.salerTableView){
        CommonModel *model = _salerArray[indexPath.row];
        [_salerButton setTitle:model.name forState:UIControlStateNormal];
        _salerId = model.Id;
        _salerButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.liuLanTableView || tableView == self.shenPiTableView) {
        return 65;
    } else{
        return 45;
    }
}


@end
