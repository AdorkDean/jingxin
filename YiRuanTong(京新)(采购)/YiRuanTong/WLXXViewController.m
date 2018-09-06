//
//  WLXXViewController.m
//  YiRuanTong
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "WLXXViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "WLXXcellmodel.h"
#import "WLXXTableViewCell.h"
#import "DataPost.h"
#import "WLXXdetailVC.h"
#import "UIViewExt.h"
#import "WLXXSearchVC.h"
@interface WLXXViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
}

@end

@implementation WLXXViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"物料管理";
    _dataArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchPage = 1;
    _searchFlag = 0;
    _page = 1;
    self.navigationItem.rightBarButtonItem = nil;
    [self showBarWithName:@"搜索" addBarWithName:nil];
    [self initTableView];
    [self DataRequest];
    
    
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

- (void)searchDataWithProName:(NSString *)proname
{
    NSString *pro = proname;
    pro = [self convertNull:proname];
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([pro isEqualToString:@""]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/materials?action=getBeans"];
    NSString* datastr = [NSString stringWithFormat:@"{\"nameLIKE\":\"%@\",\"helpnoLIKE\":\"\",\"labelnoLIKE\":\"\",\"typeidEQ\":\"\",\"isvalidEQ\":\"1\"}",pro];
    NSDictionary *params = @{@"action":@"getBeans",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_searchPage],@"params":datastr};
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
                WLXXcellmodel *model = [[WLXXcellmodel alloc] init];
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
     params={"nameLIKE":"","helpnoLIKE":"","labelnoLIKE":"","typeidEQ":"","isvalidEQ":"1"}
     url=http://192.168.1.199:8080/jingxin/servlet/materials?action=getBeans
     分页
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/materials?action=getBeans"];
    NSDictionary *params = @{@"action":@"getBeans",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_page],@"params":@"{\"nameLIKE\":\"\",\"helpnoLIKE\":\"\",\"labelnoLIKE\":\"\",\"typeidEQ\":\"\",\"isvalidEQ\":\"1\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
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
                WLXXcellmodel *model = [[WLXXcellmodel alloc] init];
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

- (void)refreshDown
{
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        
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
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (scrollView.tag == 10) {
//        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//            //            [self upRefresh];
//        }
//    }else if(scrollView.tag == 20){
//        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//            //            [self upRefresh1];
//        }
//    }
//
//}

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
    static NSString *iden = @"cell_1";
    WLXXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (WLXXTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"WLXXTableViewCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    
    if (tableView == self.kuCunTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                WLXXcellmodel *model = [_searchDateArray objectAtIndex:indexPath.row];
                cell.nameLabel.text = model.name;
                cell.guigeLabel.text = model.size;
                cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
                return cell;
            }
        }else{
            if (_dataArray.count != 0) {
                WLXXcellmodel *model = [_dataArray objectAtIndex:indexPath.row];
                cell.nameLabel.text = model.name;
                cell.guigeLabel.text = model.size;
                cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
                return cell;
            }
        }
    }
    return cell;
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
        if (_searchFlag == 1) {
            WLXXcellmodel *model= _searchDateArray[indexPath.row];
            WLXXdetailVC *detail = [[WLXXdetailVC alloc] init];
            detail.promodel = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            WLXXcellmodel *model= _dataArray[indexPath.row];
            WLXXdetailVC *detail = [[WLXXdetailVC alloc] init];
            detail.promodel = model;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    
}


- (void)searchAction{
    NSLog(@"11");
    
}

- (void)addNext{
    [_searchDateArray removeAllObjects];
    WLXXSearchVC * vc = [[WLXXSearchVC alloc]init];
    [vc setBlock:^(NSString *proid,NSString *proname, NSString *start, NSString *end) {
        [self searchDataWithProName:proname];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
