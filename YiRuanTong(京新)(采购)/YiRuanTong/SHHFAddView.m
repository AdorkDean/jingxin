//
//  SHHFAddView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "SHHFAddView.h"
#import "YeWuYuanModel.h"
#import "KHnameModel.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"

@interface SHHFAddView (){
    UIRefreshControl *_refreshControl1;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    
    UIButton *_visitButton;
    UIButton *_repairButton;
    UIButton *_custButton;
    UILabel *_custTel;
    UIButton *_repairDate;
    UIButton *_levelButton; //服务等级
    NSMutableArray *_salerArray;
    NSMutableArray *_custArray;
    NSMutableArray *_repairArray;
    NSArray *_levelArray;
    
    UITextField *_textField7;
    UITextField *_note;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    
    
    UIView *_timeView;
    NSString *_visit;
    NSString *_visitId;
    NSString *_repair;
    NSString *_repairId;
    NSString *_cust;
    NSString *_custId;
    NSString *_level;
    NSString *_levelId;
    MBProgressHUD *_HUD;
    NSString *_currentDateStr;
    UIButton* _hide_keHuPopViewBut;
}
@property(nonatomic,retain)UIScrollView *mainScrollView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UIView *listBackView;
@property(nonatomic,retain)UITableView *repairTableView;
@property(nonatomic,retain)UITableView *levelTableView;


@end

@implementation SHHFAddView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"售后回访添加";
    self.navigationItem.rightBarButtonItem = nil;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _salerArray = [NSMutableArray array];
    _custArray = [NSMutableArray array];
    _repairArray = [NSMutableArray array];

    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self salerRequest];
        [self repairRequest];
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
    label1.text = @"回访人员";
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:view1];
    [self.mainScrollView addSubview:label1];
    _visitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _visitButton.frame = CGRectMake(86, 0, KscreenWidth - 90, 40);
    [_visitButton setTintColor:[UIColor blackColor]];
    _visitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_visitButton addTarget: self action:@selector(vistAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainScrollView addSubview:_visitButton];
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 80, 40)];
    label2.text = @"维护人员";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view2.backgroundColor = [UIColor grayColor];
    _repairButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _repairButton.frame = CGRectMake(86, 41, KscreenWidth - 90, 40);
    [_repairButton setTintColor:[UIColor blackColor]];
    _repairButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_repairButton addTarget: self action:@selector(repairAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainScrollView addSubview:label2];
    [self.mainScrollView addSubview:view2];
    [self.mainScrollView addSubview:_repairButton];
    
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 82, 80, 40)];
    label3.text = @"客户名称";
    label3.backgroundColor = COLOR(231, 231, 231, 1);
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    _custButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _custButton.frame = CGRectMake(86, 82, KscreenWidth - 90, 40);
    [_custButton setTintColor:[UIColor blackColor]];
    _custButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_custButton addTarget: self action:@selector(custAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainScrollView addSubview:label3];
    [self.mainScrollView addSubview:view3];
    [self.mainScrollView addSubview:_custButton];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 123, 80, 40)];
    label4.text = @"客户电话";
    label4.backgroundColor = COLOR(231, 231, 231, 1);
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    view4.backgroundColor = [UIColor grayColor];
    _custTel =[[UILabel alloc]initWithFrame:CGRectMake(86, 123, KscreenWidth - 90, 40)];
    _custTel.font =[UIFont systemFontOfSize:13];
    
    [self.mainScrollView addSubview:label4];
    [self.mainScrollView addSubview:view4];
    [self.mainScrollView addSubview:_custTel];
    
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, 80, 40)];
    label5.text = @"维护日期";
    label5.backgroundColor = COLOR(231, 231, 231, 1);
    label5.font =[UIFont systemFontOfSize:13];
    label5.textAlignment =NSTextAlignmentCenter;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, 204, KscreenWidth, 1)];
    view5.backgroundColor = [UIColor grayColor];
    _repairDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _repairDate.frame = CGRectMake(86, 164, KscreenWidth - 90, 40);
    [_repairDate setTintColor:[UIColor blackColor]];
    _repairDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_repairDate addTarget: self action:@selector(date) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.mainScrollView addSubview:label5];
    [self.mainScrollView addSubview:view5];
    [self.mainScrollView addSubview:_repairDate];
    
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, 80, 40)];
    label6.text = @"服务等级";
    label6.backgroundColor = COLOR(231, 231, 231, 1);
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 245, KscreenWidth, 1)];
    view6.backgroundColor = [UIColor grayColor];
    _levelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _levelButton.frame = CGRectMake(86, 205, KscreenWidth - 90, 40);
    [_levelButton setTintColor:[UIColor blackColor]];
    _levelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_levelButton addTarget: self action:@selector(levelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainScrollView addSubview:label6];
    [self.mainScrollView addSubview:view6];
    [self.mainScrollView addSubview:_levelButton];
    
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, 246, 80, 40)];
    label7.text = @"维修情况";
    label7.backgroundColor = COLOR(231, 231, 231, 1);
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentCenter;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, 286, KscreenWidth, 1)];
    view7.backgroundColor = [UIColor grayColor];
    [self.mainScrollView addSubview:label7];
    [self.mainScrollView addSubview:view7];
    
    _textField7 = [[UITextField alloc] initWithFrame:CGRectMake(86, 246, KscreenWidth - 90, 40)];
    _textField7.font = [UIFont systemFontOfSize:13];
    _textField7.delegate = self;
    [self.mainScrollView addSubview:_textField7];
    
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
    [_repairDate setTitle:_currentDateStr forState:UIControlStateNormal]; 
}
#pragma mark - 业务员
- (void)vistAction{
    _visitButton.userInteractionEnabled = NO;
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
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor grayColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.tag = 10;
    _refreshControl1 = [[UIRefreshControl alloc] init];
    [_refreshControl1 addTarget:self action:@selector(refreshData1) forControlEvents:UIControlEventValueChanged];
    [self.salerTableView addSubview:_refreshControl1];
    [bgView addSubview:self.salerTableView];
//    [self.view addSubview:self.listBackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.listBackView];
    [self.salerTableView reloadData];
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
    [_salerArray removeAllObjects];
    _page1 = 1;
    [self salerRequest];
    [_refreshControl1 endRefreshing];
}
//上拉加载更多
- (void)upRefresh1
{
    _page1 ++;
    [self salerRequest];
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
    }else if(scrollView.tag == 30){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh3];
        }
    }
}
- (void)closeback{
    [_listBackView removeFromSuperview];
    _repairButton.userInteractionEnabled = YES;
    _visitButton.userInteractionEnabled = YES;
    _custButton.userInteractionEnabled = YES;
    
}
#pragma mark - 回访人员请求
- (void)salerRequest{
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
        [_salerArray removeAllObjects];
        
        for (NSDictionary *dic  in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_salerArray addObject:model];
        }
        
    }
}
#pragma mark - 维修
- (void)repairAction{
    _repairButton.userInteractionEnabled = NO;
    
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
    if (self.repairTableView == nil) {
        self.repairTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.repairTableView.backgroundColor = [UIColor grayColor];
    }
    self.repairTableView.dataSource = self;
    self.repairTableView.delegate = self;
    self.repairTableView.tag = 10;
    _refreshControl3 = [[UIRefreshControl alloc] init];
    
    [_refreshControl3 addTarget:self action:@selector(refreshData3) forControlEvents:UIControlEventValueChanged];
    [self.repairTableView addSubview:_refreshControl1];
    [bgView addSubview:self.repairTableView];
//    [self.view addSubview:self.listBackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.listBackView];
    [self.repairTableView reloadData];
}
- (void)refreshData3
{
    //开始刷新
    _refreshControl3.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl3 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown3) userInfo:nil repeats:NO];
}
- (void)refreshDown3
{
    [_repairArray removeAllObjects];
    _page3 = 1;
    [self repairRequest];
    [_refreshControl3 endRefreshing];
}
//上拉加载更多
- (void)upRefresh3
{
    _page3 ++;
    [self repairRequest];
}
#pragma mark - 维修人员请求
- (void)repairRequest{
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
    NSString *str = [NSString stringWithFormat:@"action=getPrincipals&table=ddxx&page=%@&rows=20",[NSString stringWithFormat:@"%zi",_page3]];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // NSLog(@"业务员%@",array);
    if (data1 != nil) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSArray *array = dic[@"rows"];
        [_salerArray removeAllObjects];
        
        for (NSDictionary *dic  in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_repairArray addObject:model];
        }
        
    }
}


#pragma mark  - 客户信息
- (void)custAction{
    _custButton.userInteractionEnabled = NO;
    
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
    self.custTableView.tag = 20;
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
#pragma mark -  客户名称请求
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
        
    }
}
- (void)custDetailRequest{
    /*
     custService
     action:"getLinkerAndAddress"
     table:"yyzj"
     params:"{"custid":"137"}"
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
            _custTel.text = tel;
            
        }
        
    }
}


- (void)levelAction{
    
    _levelButton.userInteractionEnabled = NO;
    
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
    
    if (self.levelTableView == nil) {
        self.levelTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.levelTableView.backgroundColor = [UIColor grayColor];
    }
    self.levelTableView.dataSource = self;
    self.levelTableView.delegate = self;
    self.levelTableView.tag = 20;
    _refreshControl2 = [[UIRefreshControl alloc] init];
    
    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
    [self.levelTableView addSubview:_refreshControl2];
    [bgView addSubview:self.levelTableView];
//    [self.view addSubview:self.listBackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.listBackView];
    [self levelRequest];
    [self.levelTableView reloadData];
}
#pragma mark - 售后服务等级
- (void)levelRequest
{   /*
     custService
     action:"serviceLevel"
     */
    NSString *strAdress = @"/custService";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=serviceLevel";
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
         _levelArray =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户名字:%@",_levelArray);
        if (_levelArray.count != 0) {
            NSDictionary *dic = _levelArray[0];
            _level = dic[@"name"];
            
            _levelId = dic[@"id"];
        }
        
      }
}




- (void)date{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0,_repairDate.bottom, KscreenWidth, 270)];
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
    [_repairDate setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.salerTableView ) {
        return _salerArray.count;
    }else if(tableView == self.custTableView){
        return _custArray.count;
    }else if(tableView == self.repairTableView){
        return _repairArray.count;
    }else if(tableView == self.levelTableView){
        return _levelArray.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (tableView == self.salerTableView) {
        YeWuYuanModel *model = _salerArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else  if(tableView == self.repairTableView){
        YeWuYuanModel *model = _repairArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if(tableView == self.custTableView){
        KHnameModel *model = _custArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if(tableView == self.levelTableView){
        NSDictionary *dic = _levelArray[indexPath.row];
        NSString *name = dic[@"name"];
        cell.textLabel.text = name;
    
        return cell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.salerTableView) {
        YeWuYuanModel *model = _salerArray[indexPath.row];
        [_visitButton setTitle:model.name forState:UIControlStateNormal];
        _visitButton.userInteractionEnabled = YES;
        _visit = model.name;
        _visitId = model.Id;
        [_listBackView removeFromSuperview];
    }else  if(tableView == self.repairTableView){
        YeWuYuanModel *model = _repairArray[indexPath.row];
        [_repairButton setTitle:model.name forState:UIControlStateNormal];
        _repairButton.userInteractionEnabled = YES;
        _repair = model.name;
        _repairId = model.Id;
        [_listBackView removeFromSuperview];
        
    }else if(tableView == self.custTableView){
        KHnameModel *model = _custArray[indexPath.row];
        [_custButton setTitle:model.name forState:UIControlStateNormal];
        _custButton.userInteractionEnabled = YES;
        _cust = model.name;
        _custId = model.Id;
        [self custDetailRequest];
        [_listBackView removeFromSuperview];
    
    }else if (tableView == self.levelTableView){
        NSDictionary *dic = _levelArray[indexPath.row];
        NSString *name = dic[@"name"];
        [_levelButton setTitle:name forState:UIControlStateNormal];
        _level = name;
        _levelId = dic[@"id"];
        _levelButton.userInteractionEnabled = YES;
        [_listBackView removeFromSuperview];
    }
}
- (void)shangBao{
    /*
     custService
     action:"visitAdd"
     table:"shhf"
     data:"{"table":"shhf","id":"","visitorid":"126","visitorname":"张宝英","repairid":"124","repairname":"贾玉萌","custid":"137","custname":"临清吉利养殖","telno":"0531-82156845","repairdate":"2015-06-06","servicelevelid":"300","servicelevelname":"A服务等级","repairsituation":"测试","note":"测试"}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custService?action=visitAdd"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=shhf&data={\"table\":\"shhf\",\"id\":\"\",\"visitorid\":\"%@\",\"visitorname\":\"%@\",\"repairid\":\"%@\",\"repairname\":\"%@\",\"custid\":\"%@\",\"custname\":\"%@\",\"telno\":\"%@\",\"repairdate\":\"%@\",\"servicelevelid\":\"%@\",\"servicelevelname\":\"%@\",\"repairsituation\":\"%@\",\"note\":\"%@\"}",_visitId,_visit,_repairId,_repair,_custId,_cust,_custTel.text,_repairDate.titleLabel.text,_levelId,_level,_textField7.text,_note.text];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSLog(@"上传字符串%@",str);
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"上传返回%@",str1);
        NSRange range = {1,str1.length-2};
        NSString *realStr = [str1 substringWithRange:range];
        if ([realStr isEqualToString:@"true"]) {
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

@end
