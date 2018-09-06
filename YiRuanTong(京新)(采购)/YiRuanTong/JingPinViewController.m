//
//  JingPinViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "JingPinViewController.h"
#import "MainViewController.h"
#import "JingPinTianJiaVC.h"
#import "JingPinXiangQingVC.h"
#import "JingPinCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "JPmanageModel.h"
#import "CPINfoModel.h"

@interface JingPinViewController ()
{
    UIRefreshControl *_refreshControl;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    NSInteger _page;
    NSInteger _page1;
    UIView *_searchView;
    UIView *_backView;
    UIButton *_proButton;
    UIButton* _hide_keHuPopViewBut;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;

@end

@implementation JingPinViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 =[NSMutableArray array];
    _page = 1;
    _page1 = 1;
    self.title = @"竞品管理";
    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DataRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            //页面设置
            [self initTableView];
            [self searchView];
            
            //进度HUD
            _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //设置模式为进度框形的
            _HUD.mode = MBProgressHUDModeIndeterminate;
            _HUD.labelText = @"网络不给力，正在加载中...";
            [_HUD show:YES];        });
    });

    
    
}
//手势方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

- (void)swipeAction{
    _searchView.hidden = NO;
    _backView.hidden = NO;
    
}
- (void)initTableView{
    self.jingPinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,KscreenHeight - 14) style:UITableViewStylePlain];
    self.jingPinTableView.delegate = self;
    self.jingPinTableView.dataSource = self;
    self.jingPinTableView.tag = 10;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.jingPinTableView addSubview:_refreshControl];
    [self.view addSubview:_jingPinTableView];
    //     下拉刷新
    _jingPinTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_jingPinTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _jingPinTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _jingPinTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_jingPinTableView.mj_footer endRefreshing];
    }];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.jingPinTableView addGestureRecognizer:swipe];

}
#pragma mark - 搜索页面
- (void)searchView{
    
    [_proButton setTitle:@" " forState:UIControlStateNormal];
    //右侧模糊视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 0, KscreenWidth/3, KscreenHeight -64)];
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = .6;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTouchesRequired = 1;
    [ _backView addGestureRecognizer:singleTap];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    //信息视图
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3*2, KscreenHeight - 64)];
    _searchView.backgroundColor = [UIColor whiteColor];
    //
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 40)];
    Label1.text = @"产品名称";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:15.0];
    Label1.textAlignment = NSTextAlignmentCenter;
    _proButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _proButton.frame = CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 40);
    [_proButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_proButton addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _searchView.frame.size.width, 1)];
    nameView.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:Label1];
    [_searchView addSubview:_proButton];
    [_searchView addSubview:nameView];
    //
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor lightGrayColor];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, 40 +30, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:[UIColor lightGrayColor]];
    [chongZhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, 40 + 30, 60, 30);
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    UIView *fenGenXian = [[UIView alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, 1, 40)];
    fenGenXian.backgroundColor = [UIColor grayColor];
    [_searchView addSubview:fenGenXian];
    
    [_searchView addSubview:searchBtn];
    [_searchView addSubview:chongZhi];
    [self.view  addSubview:_searchView];
    _searchView.hidden = YES;
    
}
#pragma mark -搜索页面方法
- (void)singleTapAction{
    _backView.hidden = YES;
    _searchView.hidden = YES;
    
}
- (void)proAction{
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.proTableView == nil) {
        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.proTableView.backgroundColor = [UIColor grayColor];
    }
    self.proTableView.dataSource = self;
    self.proTableView.delegate = self;
    self.proTableView.tag = 20;
    [bgView addSubview:self.proTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    
}
- (void)closePop{
    [self.proTableView removeFromSuperview];
    [self.m_keHuPopView removeFromSuperview];
}
- (void)CPInfoRequest
{
    //产品名称－－的接口  解析good
    NSString *strAdress = @"/order";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=fuzzyQuery&mobile=true&page=%zi&rows=10&table=cpxx",_page];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",array);
        for (NSDictionary *dic in array) {
            CPINfoModel *model = [[CPINfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray1 addObject:model];
        }
        [self.proTableView reloadData];
    }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }
    
}

//搜索方法
- (void)search
{   /*
     action:"getBeans"
     table:"jpgl"
     page:"1"
     rows:"20"
     params:"{"table":"jpgl","thispronameLIKE":"新灭菌注射用水","otherpronameLIKE":"","othersupplierLIKE":""}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/competing"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getBeans&table=jpgl&rows=20&page=%zi&params={\"table\":\"jpgl\",\"thispronameLIKE\":\"%@\",\"otherpronameLIKE\":\"\",\"othersupplierLIKE\":\"\"}",_page1,_proButton.titleLabel.text];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = dic[@"rows"];
    [_dataArray removeAllObjects];
    for (NSDictionary *dic in array) {
        JPmanageModel *model = [[JPmanageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
    }
    [self.jingPinTableView reloadData];
    [_HUD hide:YES];
    
    
    
    _searchView.hidden = YES;
    _backView.hidden = YES;
}

- (void)chongZhi
{
    [_proButton setTitle:@" " forState:UIControlStateNormal];
}


- (void)DataRequest
{
    /*sevlet/competing
     action=getBeans
     table  jpgl*/
    
    //竞品管理   的接口 解析good，棒棒的
    //数据接口拼接
    NSString *strAdress = @"/competing";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"rows":@"10",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeans",@"table":@"jpgl"};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *array = dic[@"rows"];
        NSLog(@"竞品管理输出:%@",array);
        for (NSDictionary *dic in array) {
            JPmanageModel *model = [[JPmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.jingPinTableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];

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
    [_dataArray removeAllObjects];
    _page = 1;
    [self DataRequest];
    [_refreshControl endRefreshing];
}

- (void)upRefresh
{
    [_HUD show:YES];
    _page++;
    [self DataRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//        [self upRefresh];
    }
}

#pragma mark UITableViewDelegataAndDataSource协议方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.jingPinTableView){
        return _dataArray.count;

    }else{
        return _dataArray1.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellID=@"cell";
    JingPinCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (JingPinCell *)[[[NSBundle mainBundle]loadNibNamed:@"JingPinCell" owner:self options:nil]firstObject];
        
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell1.backgroundColor = [UIColor grayColor];
        cell1.textLabel.textColor = [UIColor whiteColor];
    }
    if (tableView == self.jingPinTableView) {
        if (_dataArray.count != 0) {
            JPmanageModel *model = [_dataArray objectAtIndex:indexPath.row];
            cell.chanPinName.text = model.proname;
            // 规格单价
            NSString * thisprice= [NSString stringWithFormat:@"%@",model.thisprice];
            cell.chanPinGuiGe.text = [NSString stringWithFormat:@"%@ | 单价：%@",model.thisspecification,thisprice];
            
        }
        return cell;
    }else if (tableView == self.proTableView){
        CPINfoModel *model = _dataArray1[indexPath.row];
        cell1.textLabel.text = model.proname;
        return cell1;
    }
    return cell;
}
//点击事件 点击进入详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.jingPinTableView){
        JingPinXiangQingVC * jingPinMessage = [[JingPinXiangQingVC alloc] init];
        JPmanageModel *model = [_dataArray objectAtIndex:indexPath.row];
        jingPinMessage.model = model;
        [self.navigationController pushViewController:jingPinMessage animated:YES];
    }else if(tableView == self.proTableView){
        CPINfoModel *model = _dataArray1[indexPath.row];
        [_proButton setTitle:model.proname forState:UIControlStateNormal];
        _proButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.jingPinTableView) {
        return 65;
    }else {
        return 45;
    }
    
}

/*"id":29,"province":42,"city":4228,"county":422827,"thisproid":45,"thisproname":"氨苄青霉素","thisprono":"P201501060001","thissupplier":"","thisproducter":"","thisscope":"","thisspecification":"234df","thisprice":30,"thisproducetime":"","thisvalidtime":0,"thisoptimal":"","thislack":"","thisnote":"","otherproid":0,"otherproname":"fasdfasdf","otherprono":"","othersupplier":"","otherproducter":"","otherscope":"","otherspecification":"","otherprice":0,"otherproducetime":"","othervalidtime":0,"otheroptimal":"","otherlack":"","othernote":""}
 */

- (void)AddAction:(UIButton *)button{
    
    JingPinTianJiaVC *jingpinVC = [[JingPinTianJiaVC alloc] init];
    [self.navigationController pushViewController:jingpinVC animated:YES];
}

@end
