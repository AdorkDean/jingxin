//
//  DaiBanViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "DaiBanViewController.h"
#import "DaiBanCell.h"
#import "RiZhiShangBaoViewController.h"
#import "XinWenViewController.h"
#import "GongGaoViewController.h"
#import "DingDanViewController.h"
#import "TuiHuoViewController.h"
#import "OtherNewsViewController.h"
#import "MBProgressHUD.h"
#import "DataPost.h"

@interface DaiBanViewController ()

{
    MBProgressHUD *_hud;
    NSMutableArray *_countArray;
    NSArray *_array;
    NSMutableArray *_nameArray;
}

@end

@implementation DaiBanViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    _countArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    NSThread *thread  = [[NSThread alloc] initWithTarget:self selector:@selector(DataRequest) object:nil];
    [thread start];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //取消返回按钮 添加 logo
    self.title = @"待办";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self initTabView];
}

- (void)initTabView {
    
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.rowHeight = 60;
    [self.view addSubview:_tabView];
}

- (void)DataRequest
{
    /*
     待办事项
     http://182.92.96.58:8004/jxs/servlet/schedule
     action	getCount
     [{"count":"40","name":"dailyreport_pf"},{"count":"7","name":"news_un"},{"count":"1","name":"notice_un"},{"count":"0","name":"order_sp"},{"count":"0","name":"goodsreturn_sp"},{"count":"0","name":"others"}]
    */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/schedule"];
    NSDictionary *params = @{@"action":@"getCount"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        _array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"代办返回:%@",_array);
        for (NSDictionary *dic1 in _array) {
            [_countArray  addObject:[dic1 objectForKey:@"count"]];
            [_nameArray addObject:[dic1 objectForKey:@"name"]];
        }
        
        NSLog(@"数目数组:%@",_countArray);
        //图片
        _photoArray = @[@"db_rz",@"db_xw",@"db_gg",@"db_dd",@"db_th",@"db_other"];
    
        [_tabView reloadData];

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"待办加载失败");
    }];
    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = @"action=getCount";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        _array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"代办返回:%@",_array);
//        for (NSDictionary *dic1 in _array) {
//            [_countArray  addObject:[dic1 objectForKey:@"count"]];
//            [_nameArray addObject:[dic1 objectForKey:@"name"]];
//        }
//        
//        NSLog(@"数目数组:%@",_countArray);
//        //图片
//        _photoArray = @[@"db_rz",@"db_xw",@"db_gg",@"db_dd",@"db_th",@"db_other"];
//        [_hud hide:YES];
//        [_tabView reloadData];
//
//    }
}

#pragma  mark - UItableViewDataxource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell_daiban";
    DaiBanCell  *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (DaiBanCell *)[[[NSBundle mainBundle] loadNibNamed:@"DaiBanCell" owner:self options:nil]lastObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (_nameArray.count != 0) {
        NSString *nameStr = [_nameArray objectAtIndex:indexPath.row];
        if ([nameStr isEqualToString:@"dailyreport_pf"]) {
            cell.nameLabel.text = @"日志审批";
            cell.tuPian.image = [UIImage imageNamed:@"db_rz"];
        } else if ([nameStr isEqualToString:@"news_un"]) {
            cell.nameLabel.text = @"新闻浏览";
            cell.tuPian.image = [UIImage imageNamed:@"db_xw"];
        } else if ([nameStr isEqualToString:@"notice_un"]) {
            cell.nameLabel.text = @"公告浏览";
            cell.tuPian.image = [UIImage imageNamed:@"db_gg"];
        } else if ([nameStr isEqualToString:@"order_sp"]) {
            cell.nameLabel.text = @"订单审批";
            cell.tuPian.image = [UIImage imageNamed:@"db_dd"];
        } else if ([nameStr isEqualToString:@"goodsreturn_sp"]) {
            cell.nameLabel.text = @"退货审批";
            cell.tuPian.image = [UIImage imageNamed:@"db_th"];
        } else if ([nameStr isEqualToString:@"others"]) {
            cell.nameLabel.text = @"其他消息";
            cell.tuPian.image = [UIImage imageNamed:@"db_other"];
        }

    }
    NSLog(@"栏目数组的个数:%zi",_countArray.count);
    if (_countArray.count != 0) {
        
        NSString *count = [_countArray objectAtIndex:indexPath.row];
        if ([count isEqualToString:@"0"]) {
            cell.countLabel.text = @"";
        } else {
            cell.countLabel.text = count;
            cell.countLabel.backgroundColor = [UIColor redColor];
            cell.countLabel.font = [UIFont systemFontOfSize:13.0];
            cell.countLabel.textColor = [UIColor whiteColor];
           
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
    DaiBanCell *cell = (DaiBanCell *)[tableView cellForRowAtIndexPath:indexPath];
    UILabel *Label = (UILabel *)[cell.contentView viewWithTag:111];
    
    if ([Label.text isEqualToString:@"日志审批"]){
        RiZhiShangBaoViewController *rizhiVC = [[RiZhiShangBaoViewController alloc] init];
        [self.navigationController pushViewController:rizhiVC animated:YES];
    } else if ([Label.text isEqualToString:@"新闻浏览"]){
        
        XinWenViewController *xinwenVC = [[XinWenViewController alloc] init];
        [self.navigationController pushViewController:xinwenVC animated:YES];
    
    } else if ([Label.text isEqualToString:@"公告浏览"]){
        GongGaoViewController *gonggaoVC = [[GongGaoViewController alloc] init];
        [self.navigationController pushViewController:gonggaoVC animated:YES];
        
    } else if ([Label.text isEqualToString:@"订单审批"]){
        DingDanViewController *dingdanVC = [[DingDanViewController alloc] init];
        [self.navigationController pushViewController:dingdanVC animated:YES];
        
    } else if ([Label.text isEqualToString:@"退货审批"]){
        TuiHuoViewController *tuihuoVC = [[TuiHuoViewController alloc] init];
        [self.navigationController pushViewController:tuihuoVC animated:YES];
        
    } else if ([Label.text isEqualToString:@"其他消息"]){
        OtherNewsViewController *otherVC = [[OtherNewsViewController alloc] init];
        [self.navigationController pushViewController:otherVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
