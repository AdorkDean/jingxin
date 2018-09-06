//
//  JDXJAddView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "JDXJAddView.h"
#import "MBProgressHUD.h"
#import "YeWuYuanModel.h"
#import "KHnameModel.h"
#import "MBProgressHUD.h"
#import "IsNumberOrNot.h"
#import "UIViewExt.h"

@interface JDXJAddView (){
    UIRefreshControl *_refreshControl1;
    UIRefreshControl *_refreshControl2;
    
    UIButton *_routingbutton;
    UIButton *_custbutton;
    UIButton *_datebutton1;
    UIButton *_datebutton2;
    UILabel  *_label22;  //人员电话
    UILabel  *_label44;  //客户电话
    
    
    UITextField *_routingsituation;
    UITextField *_note;
    NSInteger _page1;
    NSInteger _page2;
    
    NSMutableArray *_routArray;
    NSMutableArray *_custArray;
    NSString *_cust;
    NSString *_custId;
    NSString *_custTel;
    NSString *_rout;
    NSString *_routTel;

    NSString *_routId;
    UIView *_timeView;
    MBProgressHUD *_HUD;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
}

@property(nonatomic,retain)UIScrollView *mainScrollView;
@property(nonatomic,retain)UIView *listBackView;
@property(nonatomic,retain)UITableView *routTableView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation JDXJAddView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"季度巡检添加";
    _routArray = [NSMutableArray array];
    _custArray = [NSMutableArray array];
    _page1 = 1;
    _page2 = 1;
    self.navigationItem.rightBarButtonItem = nil;

    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self routRequest];
        [self nameRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self initScrollView];
            [self initDetailView];
            
        });
    });

    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    
    

    
}
- (void)initScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(KscreenWidth, 330+17);
    _mainScrollView.bounces = NO;
    _mainScrollView.backgroundColor =[UIColor clearColor];
    _mainScrollView.delegate =self;
    [self.view addSubview:_mainScrollView];
    UIButton *shangBao = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shangBao.frame =  CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [shangBao setTitle:@"上报" forState:UIControlStateNormal];
    [shangBao addTarget:self action:@selector(shangBao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:shangBao];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)initDetailView{
    //
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label1.text = @"巡检人员";
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:view1];
    [self.mainScrollView addSubview:label1];
    _routingbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _routingbutton.frame = CGRectMake(86, 0, KscreenWidth - 90, 40);
    [_routingbutton setTintColor:[UIColor blackColor]];
    _routingbutton.tag = 10;
    _routingbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_routingbutton addTarget:self action:@selector(routing) forControlEvents:UIControlEventTouchUpInside];
    //[_routingbutton setTitle:@"测试" forState:UIControlStateNormal];
    [self.mainScrollView addSubview:_routingbutton];
    
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label2.text = @"人员电话";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view2.backgroundColor = [UIColor grayColor];
    _label22 =[[UILabel alloc]initWithFrame:CGRectMake(86, 41, KscreenWidth - 90, 40)];
    _label22.font =[UIFont systemFontOfSize:13];
    [self.mainScrollView addSubview:label2];
    [self.mainScrollView addSubview:view2];
    [self.mainScrollView addSubview:_label22];
    
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label3.text = @"客户名称";
    label3.backgroundColor = COLOR(231, 231, 231, 1);
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    _custbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _custbutton.frame = CGRectMake(86, 82, KscreenWidth - 90, 40);
    _custbutton.tag = 20;
    [_custbutton setTintColor:[UIColor blackColor]];
    _custbutton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [_custbutton addTarget: self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:label3];
    [self.mainScrollView addSubview:view3];
    [self.mainScrollView addSubview:_custbutton];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label4.text = @"客户电话";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    view4.backgroundColor = [UIColor grayColor];
    _label44 =[[UILabel alloc]initWithFrame:CGRectMake(86, 123, KscreenWidth - 90, 40)];
    _label44.font =[UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label4];
    [self.mainScrollView addSubview:view4];
    [self.mainScrollView addSubview:_label44];
    
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 40)];
    label5.text = @"巡检日期";
    label5.backgroundColor = COLOR(231, 231, 231, 1);
    label5.font =[UIFont systemFontOfSize:13];
    label5.textAlignment =NSTextAlignmentCenter;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, 204, KscreenWidth, 1)];
    view5.backgroundColor = [UIColor grayColor];
    _datebutton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _datebutton1.frame = CGRectMake(86, 164, KscreenWidth - 90, 40);
    [_datebutton1 setTintColor:[UIColor blackColor]];
    _datebutton1.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [_datebutton1 addTarget:self action:@selector(date1) forControlEvents:UIControlEventTouchUpInside];
    [_datebutton1 setTitle:_currentDateStr forState:UIControlStateNormal];
    [self.mainScrollView addSubview:label5];
    [self.mainScrollView addSubview:view5];
    [self.mainScrollView addSubview:_datebutton1];
    
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 40)];
    label6.text = @"下次巡检日期";
    label6.backgroundColor = COLOR(231, 231, 231, 1);
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 245, KscreenWidth, 1)];
    view6.backgroundColor = [UIColor grayColor];
    _datebutton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _datebutton2.frame = CGRectMake(86, 205, KscreenWidth - 90, 40);
    [_datebutton2 setTintColor:[UIColor blackColor]];
    _datebutton2.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [_datebutton2 addTarget:self action:@selector(date2) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:label6];
    [self.mainScrollView addSubview:view6];
    [self.mainScrollView addSubview:_datebutton2];

    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, 246, 80, 40)];
    label7.text = @"巡检情况";
    label7.backgroundColor = COLOR(231, 231, 231, 1);
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentCenter;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, 286, KscreenWidth, 1)];
    view7.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label7];
    [self.mainScrollView addSubview:view7];
    
    _routingsituation = [[UITextField alloc] initWithFrame:CGRectMake(86, 246, KscreenWidth - 90, 40)];
    _routingsituation.font = [UIFont systemFontOfSize:13];
    _routingsituation.delegate = self;
    [self.mainScrollView addSubview:_routingsituation];
    
    //
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(0, 287, 80, 40)];
    label8.text = @"备注";
    label8.backgroundColor = COLOR(231, 231, 231, 1);
    label8.font =[UIFont systemFontOfSize:13];
    label8.textAlignment =NSTextAlignmentCenter;
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, 327, KscreenWidth, 1)];
    view8.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label8];
    [self.mainScrollView addSubview:view8];
    _note = [[UITextField alloc] initWithFrame:CGRectMake(86, 287, KscreenWidth - 90, 40)];
    _note.font = [UIFont systemFontOfSize:13];
    _note.delegate = self;
    [self.mainScrollView addSubview:_note];
    //
    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, 327)];
    shu.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:shu];
    [_datebutton2 setTitle:_currentDateStr forState:UIControlStateNormal];
    
}
- (void)routing{
   //巡检员
    _routingbutton.userInteractionEnabled = NO;
    
    self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.listBackView.backgroundColor = [UIColor grayColor];
    self.listBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [self.listBackView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.listBackView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.routTableView == nil) {
        self.routTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.routTableView.backgroundColor = [UIColor grayColor];
    }
    self.routTableView.dataSource = self;
    self.routTableView.delegate = self;
    _refreshControl1 = [[UIRefreshControl alloc] init];
    [_refreshControl1 addTarget:self action:@selector(refreshData1) forControlEvents:UIControlEventValueChanged];
    [self.routTableView addSubview:_refreshControl1];
    [bgView addSubview:self.routTableView];
//    [self.view addSubview:self.listBackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.listBackView];
    [self.routTableView reloadData];
}
#pragma mark - 巡检人员请求
- (void)routRequest{
    /*
     account
     action:"getPrincipals"
     table:"yhzh"
     cflag:"1"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getPrincipals&table=ddxx&page=%@&rows=20",[NSString stringWithFormat:@"%zi",_page1]];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

   // NSLog(@"业务员%@",array);
    if (data1 != nil) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSArray *array = dic[@"rows"];
        [_routArray removeAllObjects];
    
        for (NSDictionary *dic  in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_routArray addObject:model];
        }
        if (array.count != 0) {
            YeWuYuanModel *model = _routArray[0];
            NSString *type =  model.name;
            NSString *ID =  model.Id;
            [_routingbutton setTitle:type forState:UIControlStateNormal];
            
            _routId = ID;
            NSLog(@"返回类型%@",array);
        }
        
    }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
        }
}
- (void)routDetailRequest{
    /*
     custService
     action:"getAccountTelNo"
     table:"jdxj"
     params:"{"accountid":"126"}"
     
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getAccountTelNo&table=jdxj&params={\"accountid\":\"%@\"}",_routId];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // NSLog(@"业务员%@",array);
    if (data1 != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            NSString *tel = dic[@"cellno"];
            NSLog(@"tel%@",tel);
            _label22.text = tel;
            _routTel = tel;
        }
        

    }

}

- (void)refreshData1
{
    //开始刷新
    _refreshControl1.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl1 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown1) userInfo:nil repeats:NO];
}
- (void)refreshDown1
{
    [_routArray removeAllObjects];
    _page1 = 1;
    [self routRequest];
    [_refreshControl1 endRefreshing];
}
//上拉加载更多
- (void)upRefresh1
{
    _page1 ++;
    [self routRequest];
}


- (void)closeback{
    [_listBackView removeFromSuperview];
    [_routTableView removeFromSuperview];
    _routingbutton.userInteractionEnabled = YES;
}
-(void)custAction{
    _custbutton.userInteractionEnabled = NO;
    
    self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.listBackView.backgroundColor = [UIColor grayColor];
    self.listBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [self.listBackView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.listBackView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.custTableView == nil) {
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor grayColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 30;
    _refreshControl2 = [[UIRefreshControl alloc] init];
    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
    [self.custTableView addSubview:_refreshControl2];
    [bgView addSubview:self.custTableView];
//    [self.view addSubview:self.listBackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.listBackView];
    
}
//下拉刷新
- (void)refreshData2
{
    //开始刷新
    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl2 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown2) userInfo:nil repeats:NO];
}
- (void)refreshDown2
{
    [_custArray removeAllObjects];
    _page2 = 1;
    [self nameRequest];
    [_refreshControl2 endRefreshing];
}
//上拉加载更多
- (void)upRefresh2
{
    _page2 ++;
    [self nameRequest];
}
#pragma mark - 客户名称请求
- (void)nameRequest
{
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"rows=20&mobile=true&page=%zi&action=getSelectName&table=khxx",_page2];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"客户名字:%@",dic);
        NSArray *array = dic[@"rows"];
        
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_custArray addObject:model];
        }
        [self.custTableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
    }else{
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
        UIAlertView *tan =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
        
    }
}
- (void)nameDetailRequest{
    /*
     custService
     action:"getLinkerAndAddress"
     table:"yyzj"
     params:"{"custid":"166"}"
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService"];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getLinkerAndAddress&table=yyzj&params={\"custid\":\"%@\"}",_custId];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户名字:%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            NSString *tel = dic[@"telno"];
            _label44.text = tel;
            _custTel = tel;
        }

    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            //[self upRefresh];
        }
    }else if(scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh2];
        }
    }
}
#pragma mark - 时间
- (void)date1{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0,_datebutton2.bottom, KscreenWidth, 270)];
    _timeView.backgroundColor = [UIColor grayColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, KscreenWidth, 230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_timeView.frame.size.width-60, 0, 60, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_timeView addSubview:_datePicker];
    [self.view addSubview:_timeView];
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
    [_datebutton1 setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}

- (void)date2{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0,_datebutton2.bottom, KscreenWidth, 270)];
    _timeView.backgroundColor = [UIColor grayColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, KscreenWidth, 230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_timeView.frame.size.width-60, 0, 60, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange2:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_timeView addSubview:_datePicker];
    [self.view addSubview:_timeView];
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
    [_datebutton2 setTitle:dateString forState:UIControlStateNormal];
}



#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.routTableView) {
        return _routArray.count;
    }else if(tableView == self.custTableView){
        return _custArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_rout";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (tableView == self.routTableView) {
        YeWuYuanModel *model = _routArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if(tableView == self.custTableView){
        KHnameModel *model = _custArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.routTableView) {
        YeWuYuanModel *model = _routArray[indexPath.row];
        [_routingbutton setTitle:model.name forState:UIControlStateNormal];
        _rout = model.name;
        _routId = model.Id;
        [self routDetailRequest];
        _routingbutton.userInteractionEnabled = YES;
        [_listBackView removeFromSuperview];
    }else if(tableView== self.custTableView){
        KHnameModel *model = _custArray[indexPath.row];
        [_custbutton setTitle:model.name forState:UIControlStateNormal];
        _cust = model.name;
        _custId = model.Id;
        [self nameDetailRequest];
        _custbutton.userInteractionEnabled = YES;
        [self.listBackView removeFromSuperview];
    }

}
- (void)shangBao{
    /*
    custService
     action:"routingAdd"
     table:"jdxj"
     data:"{"table":"jdxj","id":"","routingid":"152","routingname":"胡云龙","routingtelno":"15012345678","custid":"137","custname":"临清吉利养殖","custnametelno":"0531-82156845","routingdate":"2015-06-05","nextroutingdate":"2015-06-25","routingsituation":"测试","note":"测试"}"
     */
    NSString *date1 = _datebutton1.titleLabel.text;
    NSString *date2 = _datebutton2.titleLabel.text;
    if(_rout.length == 0||_cust.length == 0||date1.length == 0||date2.length == 0){
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入字段有误！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [tan show];
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=routingAdd"];
        NSURL *url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str = [NSString stringWithFormat:@"table=jdxj&data={\"table\":\"jdxj\",\"id\":\"\",\"routingid\":\"%@\",\"routingname\":\"%@\",\"routingtelno\":\"%@\",\"custid\":\"%@\",\"custname\":\"%@\",\"custnametelno\":\"%@\",\"routingdate\":\"%@\",\"nextroutingdate\":\"%@\",\"routingsituation\":\"%@\",\"note\":\"%@\"}",_routId,_rout,_routTel,_custId,_cust,_custTel,_datebutton1.titleLabel.text,_datebutton2.titleLabel.text,_routingsituation.text,_note.text];
        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSLog(@"上传字符串%@",str);
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"上传返回%@",str1);
            NSRange range = {1,str1.length-2};
            NSString *realStr = [str1 substringWithRange:range];
            if ([IsNumberOrNot isAllNum:realStr]) {
                _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _HUD.mode = MBProgressHUDModeText;
                _HUD.labelText = @"上报成功";
                _HUD.margin = 10.f;
                _HUD.yOffset = 150.f;
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                
                _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _HUD.mode = MBProgressHUDModeText;
                _HUD.labelText = @"上报失败";
                _HUD.margin = 10.f;
                _HUD.yOffset = 150.f;
                [_HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_HUD removeFromSuperview];
                }];
            }
        }
    
    }
    
}

@end
