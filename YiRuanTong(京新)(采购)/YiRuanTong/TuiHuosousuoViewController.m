//
//  TuiHuosousuoViewController.m
//  YiRuanTong
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "TuiHuosousuoViewController.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "KHmanageModel.h"
#import "CustCell.h"
#import "KHnameModel.h"


@interface TuiHuosousuoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITextField *_orderTextfield;
    UIButton *_custButton;
    UIButton *_statusButton;
    UIButton *_createtime1;
    UIButton *_createtime2;
    UIButton *_applytime1;
    UIButton *_applytime2;
    NSString *_custId;
    UITextField *_custField;
    UIView *_timeView;

    NSInteger _page;
    NSMutableArray *_dataArray;
    NSArray *_spArray;
    NSString *_pastDateStr;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _custpage;

}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *nameTableView;
@property(nonatomic,retain)UITableView *spTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation TuiHuosousuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    _spArray = @[@"未审批",@"已审批"];
    _page = 1;
    _custpage = 1;
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    _currentDateStr =[dateFormatter stringFromDate:currentDate];
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
   
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    orderLabel.text = @"订单号";
    orderLabel.textColor = UIColorFromRGB(0x333333);
    orderLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    orderLabel.font = [UIFont systemFontOfSize:15.0];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    _orderTextfield = [[UITextField alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH)];
    _orderTextfield.textAlignment = NSTextAlignmentCenter;
    _orderTextfield.textColor = UIColorFromRGB(0x999999);
    _orderTextfield.placeholder = @"请输入订单号";  // 提示文本
    [_orderTextfield setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_orderTextfield setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, orderLabel.bottom, KscreenWidth, 1)];
    orderView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:orderLabel];
    [self.view addSubview:_orderTextfield];
    [self.view addSubview:orderView];
    
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, orderLabel.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label1.text = @"客户名称";
    Label1.textColor = UIColorFromRGB(0x333333);
    Label1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _custButton.frame = CGRectMake(KscreenWidth/3, orderLabel.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_custButton addTarget:self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
    [_custButton setTitle:@"请选择名称" forState:UIControlStateNormal];

    [_custButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, Label1.bottom, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label1];
    [self.view addSubview:_custButton];
    [self.view addSubview:nameView];
    //
    UILabel *Label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, Label1.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label0.text = @"审批状态";
    Label0.textColor = UIColorFromRGB(0x333333);
    Label0.backgroundColor = UIColorFromRGB(0xf3f3f3);
    Label0.font = [UIFont systemFontOfSize:15.0];
    Label0.textAlignment = NSTextAlignmentCenter;
    _statusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _statusButton.frame = CGRectMake(KscreenWidth/3, Label1.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_statusButton setTitle:@"请选择状态" forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(spAction) forControlEvents:UIControlEventTouchUpInside];
    [_statusButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, Label0.bottom, KscreenWidth, 1)];
    view0.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label0];
    [self.view addSubview:_statusButton];
    [self.view addSubview:view0];
    //
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0,  Label0.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label2.text = @"退货日期";
    Label2.textColor = UIColorFromRGB(0x333333);
    Label2.backgroundColor = UIColorFromRGB(0xf3f3f3);
    Label2.font = [UIFont systemFontOfSize:15.0];
    Label2.textAlignment = NSTextAlignmentCenter;
    _createtime1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _createtime1.frame = CGRectMake(KscreenWidth/3,  Label0.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_createtime1 setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_createtime1 setTitle:_pastDateStr forState:UIControlStateNormal];
    [_createtime1 addTarget:self action:@selector(create1Action) forControlEvents:UIControlEventTouchUpInside];
    UIView *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, Label2.bottom, KscreenWidth, 1)];
    salerView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label2];
    [self.view addSubview:_createtime1];
    [self.view addSubview:salerView];
    //
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(0,  Label2.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label3.text = @"至";
    Label3.textColor = UIColorFromRGB(0x333333);
    Label3.backgroundColor = UIColorFromRGB(0xf3f3f3);
    Label3.font = [UIFont systemFontOfSize:15.0];
    Label3.textAlignment = NSTextAlignmentCenter;
    _createtime2 = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _createtime2.frame = CGRectMake(KscreenWidth/3,  Label2.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_createtime2 setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_createtime2 addTarget:self action:@selector(create2Action) forControlEvents:UIControlEventTouchUpInside];
    [_createtime2 setTitle:_currentDateStr forState:UIControlStateNormal];

    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0,  Label3.bottom , KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label3];
    [self.view addSubview:_createtime2];
    [self.view addSubview:typeView];
    
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, Label3.bottom)];
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
    if (_tuihuoblock) {
        
        _tuihuoblock(_custId,_orderTextfield.text,_createtime1.titleLabel.text,_createtime2.titleLabel.text,_statusButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)custAction{
    _custButton.userInteractionEnabled = NO;
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
//    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64,KscreenWidth - 100 , 40)];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
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
    [btn addTarget:self action:@selector(searchcust) forControlEvents:UIControlEventTouchUpInside];//getTHName
//    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.nameTableView == nil) {
//        self.nameTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 104,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.nameTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.nameTableView.backgroundColor = [UIColor whiteColor];
        self.nameTableView.tag = 30;
    }
    self.nameTableView.dataSource = self;
    self.nameTableView.delegate = self;
    self.nameTableView.rowHeight = 50;
    [bgView addSubview:self.nameTableView];
//    [self.m_keHuPopView addSubview:self.nameTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
//    [self nameRequest];
    //     下拉刷新
    self.nameTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _custpage = 1;
        [self searchcust];
        // 结束刷新
        [self.nameTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.nameTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.nameTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _custpage ++ ;
        [self searchcust];
        [self.nameTableView.mj_footer endRefreshing];
        
    }];
    _custpage = 1;
    [self searchcust];
}
- (void)closePop
{
    if ([self keyboardDid]) {
        [_orderTextfield resignFirstResponder];
        [_custField resignFirstResponder];
        
    }else{
        
        _custButton.userInteractionEnabled = YES;
        _statusButton.userInteractionEnabled = YES;
        
        [self.m_keHuPopView removeFromSuperview];
        [self.nameTableView removeFromSuperview];
        
    }
    
    
}
#pragma mark - 审批选择
- (void)spAction{
    
    _statusButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(40, 64, KscreenWidth - 80, KscreenHeight - 134)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [bgView.layer setCornerRadius:5.0];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.spTableView == nil) {
        self.spTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-80, KscreenHeight-164) style:UITableViewStylePlain];

        self.spTableView.backgroundColor = [UIColor whiteColor];
    }
    self.spTableView.dataSource = self;
    self.spTableView.delegate = self;
    [bgView addSubview:self.spTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.spTableView reloadData];
    
    
}
#pragma mark - 时间设置的点击方法
- (void)create1Action{
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
    [_createtime1 setTitle:_currentDateStr forState:UIControlStateNormal];
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
    [_createtime1 setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}
- (void)create2Action{
    
    
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
    [_createtime2 setTitle:_currentDateStr forState:UIControlStateNormal];
}

//监听datePicker值发生变化
- (void)dateChange2:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_createtime2 setTitle:dateString forState:UIControlStateNormal];
}

#pragma mark - 客户名称请求方法
- (void)nameRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        if(array.count != 0){
            for (NSDictionary *dic in array) {
                KHmanageModel *model = [[KHmanageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.nameTableView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [self showAlert:@"客户名称加载失败"];
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
    
}
- (void)getTHName{
    
    NSString *custName = _custField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        if(array.count != 0){
            for (NSDictionary *dic in array) {
                KHmanageModel *model = [[KHmanageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.nameTableView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [self showAlert:@"搜索客户名称加载失败"];
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
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
                    KHmanageModel *model = [[KHmanageModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.nameTableView reloadData];
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

- (void)chongZhi
{
    _orderTextfield.text = @" ";
    [_custButton setTitle:@" " forState:UIControlStateNormal];
    _custId = @" ";
    [_statusButton setTitle:@" " forState:UIControlStateNormal];
    [_createtime1 setTitle:@" " forState:UIControlStateNormal];
    [_createtime2 setTitle:@" " forState:UIControlStateNormal];
    [_applytime1 setTitle:@" " forState:UIControlStateNormal];
    [_applytime2 setTitle:@" " forState:UIControlStateNormal];
    
}
#pragma mark-UITableViewDelegateAndDataSource协议方法
//返回section的cell的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==self.nameTableView){
        return _dataArray.count;
    }else if (tableView == self.spTableView){
        return _spArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
   
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CustCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell3 == nil) {
        cell3 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell3.backgroundColor = [UIColor whiteColor];
    }
    
    if(tableView == self.nameTableView){
        if (_dataArray.count!=0) {
            cell3.model = _dataArray[indexPath.row];;
        }
        return cell3;
    }else if (tableView == self.spTableView){
        
        cell2.textLabel.text = _spArray[indexPath.row];
        cell2.textLabel.textColor = UIColorFromRGB(0x333333);
        return cell2;
    }
    return cell2;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.nameTableView){
        if (_dataArray.count!=0) {
            KHnameModel *model = _dataArray[indexPath.row];
            [_custButton setTitle:model.name forState:UIControlStateNormal];
            _custId = [NSString stringWithFormat:@"%@",model.Id];
            _custButton.userInteractionEnabled = YES;
        }
        [self.m_keHuPopView removeFromSuperview];
    }else if (tableView == self.spTableView){
        
        NSString *sp = _spArray[indexPath.row];
        [_statusButton setTitle:sp forState:UIControlStateNormal];
        [self.m_keHuPopView removeFromSuperview];
        _statusButton.userInteractionEnabled = YES;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  45;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.tag == 30){
        if(scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30)
        {
            [self upRefresh3];
        }
    }
    
    
}
//上拉加载更多
- (void)upRefresh3
{
    _page++;
    [self nameRequest];
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
