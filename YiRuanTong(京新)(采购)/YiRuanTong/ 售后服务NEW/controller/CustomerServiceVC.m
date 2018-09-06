//
//  CustomerServiceVC.m
//  YiRuanTong
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CustomerServiceVC.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "CustomerServiceModel.h"
#import "CustomerServicetbCell.h"
#import "DataPost.h"
#import "CustomerServiceDetailVC.h"
#import "UIViewExt.h"
#import "CustomerServiceSearchVC.h"
#import "CustomerServiceAddVC.h"
@interface CustomerServiceVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSMutableArray*_resultData;
    
    NSString* _orederNo;
    NSString* _start;
    NSString* _end;
}
@property (strong, nonatomic)  UITableView *kuCunTableView;

@end

@implementation CustomerServiceVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"售后服务管理";
    _dataArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _resultData = [[NSMutableArray alloc]init];
    _searchPage = 1;
    _searchFlag = 0;
    _page = 1;
    self.navigationItem.rightBarButtonItem = nil;
    [self navigationSetRightButton];
    [self initTableView];
    [self DataRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRefresh) name:@"CustomerServiceVCNewRefresh" object:nil];
    
}
- (void)navigationSetRightButton{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(KscreenWidth - 90, 10, 40, 40);
    [searchButton setTitle:@"添加" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [button setTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(KscreenWidth - 50, 10, 40, 40);
    [button setImage:[UIImage imageNamed:@"rightBut"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    //将按钮数组放在navbar 上
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:right1,right, nil]];
    
}

#pragma mark - 页面设置
- (void)initTableView{
    
    self.kuCunTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    self.kuCunTableView.delegate = self;
    self.kuCunTableView.dataSource = self;
    self.kuCunTableView.rowHeight = 90;
    self.kuCunTableView.tag = 10;
    [self.view addSubview:_kuCunTableView];
    //     下拉刷新
    _kuCunTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_kuCunTableView.mj_header endRefreshing];
        
    }];
    NSString * roleid = [[NSUserDefaults standardUserDefaults]objectForKey:@"roleid"];
    if ([roleid integerValue] == 140) {
        
    }else{
        // 上拉刷新
        _kuCunTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
            [self upRefresh];
            [_kuCunTableView.mj_footer endRefreshing];
        }];
    }
    //隐藏多余cell
    _kuCunTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _kuCunTableView.mj_header.automaticallyChangeAlpha = YES;
    
    //    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    //    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.kuCunTableView addGestureRecognizer:swipe];
    
}

- (void)searchDataWithProName
{
    //HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText =  @"网络不给力,正在加载中...";
    [_HUD show:YES];
    NSString *question;
    question = [self convertNull:_orederNo];
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([_orederNo isEqualToString:@""]&&[_start isEqualToString:@""]&&[_end isEqualToString:@""]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/questions?action=searchQusetion"];
    NSString* datastr = [NSString stringWithFormat:@"{\"isdealEQ\":\"%@\",\"submittimeGE\":\"%@\",\"submittimeLE\":\"%@\"}",question,_start,_end];
    NSDictionary *params = @{@"action":@"searchQusetion",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_searchPage],@"params":datastr};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"rows"];
            for (NSDictionary *dic in array) {
                CustomerServiceModel *model = [[CustomerServiceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_searchDateArray addObject:model];
            }
            [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD removeFromSuperview];
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
#pragma mark - 浏览数据
- (void)DataRequest
{
    
    //HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText =  @"网络不给力,正在加载中...";
    [_HUD show:YES];
    //数据接口拼接
    /*
     params={"bomnoLIKE":"","plannoLIKE":"","isstockoutEQ":"0","proidEQ":""}
     url=http://192.168.1.199:8080/jingxin/servlet/pickinglist?action=getBeans
     分页
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/questions?action=searchQusetion"];
    NSDictionary *params = @{@"action":@"searchQusetion",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_page],@"params":@"{\"isdealEQ\":\"\",\"submittimeGE\":\"\",\"submittimeLE\":\"\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            
            NSLog(@"物料浏览列表:%@",array);
            for (NSDictionary *dic in array) {
                CustomerServiceModel *model = [[CustomerServiceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
                
            }
            [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
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
- (void)newRefresh{
    [self refreshDown];
}
- (void)refreshDown
{
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        [self searchDataWithProName];
    }else{
        [_dataArray removeAllObjects];
        _page = 1;
        [self DataRequest];
    }
}

- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
        [self searchDataWithProName];
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}
#pragma mark UITableViewDelegateAndDataSource

//返回每个section上cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.kuCunTableView){
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray.count;
        }
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"CustomerServicetbCellID";
    CustomerServicetbCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (CustomerServicetbCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustomerServicetbCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    
    if (tableView == self.kuCunTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                CustomerServiceModel * model = [[CustomerServiceModel alloc]init];
                model = [_searchDateArray objectAtIndex:indexPath.row];
                cell.model = model;
                return cell;
            }
        }else{
            if (_dataArray.count != 0) {
                CustomerServiceModel *model = [[CustomerServiceModel alloc]init];
                model = [_dataArray objectAtIndex:indexPath.row];
                cell.model = model;
                return cell;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 141;
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_searchFlag == 1) {
        
    }else{
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.kuCunTableView ){
        CustomerServiceDetailVC* vc = [[CustomerServiceDetailVC alloc]init];
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                CustomerServiceModel * model = [[CustomerServiceModel alloc]init];
                model = [_searchDateArray objectAtIndex:indexPath.row];
                vc.model = model;
            }
        }else{
            if (_dataArray.count != 0) {
                CustomerServiceModel *model = [[CustomerServiceModel alloc]init];
                model = [_dataArray objectAtIndex:indexPath.row];
                vc.model = model;
            }
        }
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)searchAction{
    NSLog(@"11");
    CustomerServiceAddVC* vc = [[CustomerServiceAddVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNext{
    [_searchDateArray removeAllObjects];
    CustomerServiceSearchVC * sousuoVC = [[CustomerServiceSearchVC alloc]init];
    void(^aBlock)(NSString *orederNo,NSString *start,NSString *end) = ^(NSString *orederNo,NSString *start,NSString *end){
        _orederNo = orederNo;
        _start = start;
        _end = end;
        [self searchDataWithProName];
    };
    sousuoVC.block = aBlock;
    [self.navigationController  pushViewController:sousuoVC animated:YES];
}


@end
