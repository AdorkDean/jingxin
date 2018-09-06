//
//  TongXunLuViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "TongXunLuViewController.h"
#import "DetailView.h"
#import "TongXunLuCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "TongxunluModel.h"
#import "RCIM.h"
#import "RCChatViewController.h"
#import "MBProgressHUD.h"

@interface TongXunLuViewController ()<RCIMUserInfoFetcherDelegagte,UISearchBarDelegate>
{
    NSMutableArray *_dataArray;
    DetailView *_Detail;
    UITableView *_searchTableView;
    UISearchBar *_searchBar;
    NSMutableArray *_searArray;
    MBProgressHUD *_HUD;
    
    UIView *_m_keHuPopView;
    UIButton *_hide_keHuPopViewBut;
}

@end

@implementation TongXunLuViewController

- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"no" userInfo:nil];
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _searArray = [[NSMutableArray alloc] init];

    self.title = @"通讯录";
    //取消返回按钮 添加 logo
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    //初始化
    [self initTabView];
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44,KscreenWidth, KscreenHeight-64 - 49) style:UITableViewStylePlain];
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.tag = 2;
    _searchTableView.showsVerticalScrollIndicator = NO;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    [self.view addSubview:_searchTableView];
    _searchTableView.hidden = YES;
    
    [self setSearchBar:YES];
    
    //进度HUD
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [self.view bringSubviewToFront:_HUD];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];
    
    [self dataRequest];
    // 设置用户信息提供者。
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:NO];
}

//是否需要searchBar
- (void)setSearchBar:(BOOL)searchBar{
    if (searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
        _searchBar.placeholder = @"搜索朋友";
        _searchBar.delegate = self;
        //显示取消按钮
        _searchBar.showsCancelButton = YES;
        //显示书签按钮
        _searchBar.showsBookmarkButton = YES;
        //显示搜索结果按钮
        _searchBar.showsSearchResultsButton = YES;
        
        _tabView.tableHeaderView = _searchBar;
        
    } else {
        _tabView.tableHeaderView = nil;
    }
}

//searchBar delegate
// 当动态的输入完就进行搜索

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchtext:searchBar.text];
}

//取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    _searchTableView.hidden = YES;
}

//触发搜索
- (void)searchtext:(NSString*)text
{
    if ([text isEqualToString:@""]) {
        _searchTableView.hidden = YES;
    } else {
        _searchTableView.hidden = NO;
        [_searArray removeAllObjects];
        for (int i = 0; i < _dataArray.count; i++) {
            TongxunluModel *model = [_dataArray objectAtIndex:i];
            if ([model.name rangeOfString:text].location != NSNotFound)
            {
                [_searArray addObject:model];
            }
        }
        [_searchTableView reloadData];
    }
}
// 获取用户信息的方法。
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
    for (TongxunluModel *model in _dataArray) {
        
        if ([model.idEQ isEqual:userId]) {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = model.idEQ;
            user.name = model.name;
            user.portraitUri = model.portraituri;
            return completion(user);
        }
    }
    return completion(nil);
}

- (void)initTabView{
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64 - 49 )];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.tag = 1;
    [self.view addSubview:_tabView];
}

- (void)dataRequest
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/rongcloud"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getFriendsList"};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = (NSArray *)responseObject;
        for (NSDictionary *dic in arr) {
            TongxunluModel *model = [[TongxunluModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.idEQ = dic[@"id"];
            [_dataArray addObject:model];
        }
        [_tabView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

#pragma  mark - UItableViewDataxource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return _dataArray.count;
    }
    if (tableView.tag == 2)
    {
        return _searArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_tuxunlu";
    
    if (tableView.tag == 1) {
        
       TongXunLuCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
       if (cell == nil) {
           cell = [[[NSBundle mainBundle]loadNibNamed:@"TongXunLuCell" owner:self options:nil]firstObject];
       }
       TongxunluModel *model = [_dataArray objectAtIndex:indexPath.row];
       cell.detail.layer.cornerRadius = 18.0;
       cell.detail.layer.masksToBounds = YES;
       cell.name.text = model.name;
       cell.detail.text  = [cell.name.text substringToIndex:1];
       cell.cell.text = model.cellno;
       if ([model.loginstatus isEqualToString:@"0"]) {
           cell.status.text = @"离线";
           [cell.detail setBackgroundColor:[UIColor lightGrayColor]];
       } else if ([model.loginstatus isEqualToString:@"1"]) {
           cell.status.text = @"电脑";
           
       } else if ([model.loginstatus isEqualToString:@"2"]) {
           cell.status.text = @"手机";
       }
       cell.detail.userInteractionEnabled = YES;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDetail:)];
       cell.detail.tag = indexPath.row;
       [cell.detail addGestureRecognizer:tap];
       
       NSString *depart = [[NSString alloc] init];
       if (model.depart.count > 1) {
         for (NSDictionary *dic in model.depart) {
           NSString *str = dic[@"departname"];
           depart = [depart stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
         }
         cell.company.text = depart;
       } else if (model.depart.count == 1) {
         NSDictionary *dic = model.depart[0];
         depart = dic[@"departname"];
         cell.company.text = depart;
       }
       //打电话的按钮
       cell.call.userInteractionEnabled = YES;
       UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
       cell.call.tag = indexPath.row;
       [cell.call addGestureRecognizer:tap1];
       return cell;
    }
    if (tableView.tag == 2) {
        TongXunLuCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TongXunLuCell" owner:self options:nil]firstObject];
        }
        TongxunluModel *model = [_searArray objectAtIndex:indexPath.row];
        cell.detail.layer.cornerRadius = 18.0;
        cell.detail.layer.masksToBounds = YES;
        cell.name.text = model.name;
        cell.detail.text  = [cell.name.text substringToIndex:1];
        cell.cell.text = model.cellno;
        if ([model.loginstatus isEqualToString:@"0"]) {
            cell.status.text = @"离线";
        } else if ([model.loginstatus isEqualToString:@"1"]) {
            cell.status.text = @"电脑";
            [cell.detail setBackgroundColor:[UIColor blueColor]];
        } else if ([model.loginstatus isEqualToString:@"2"]) {
            cell.status.text = @"手机";
            [cell.detail setBackgroundColor:[UIColor blueColor]];
        }
        cell.detail.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDetail:)];
        cell.detail.tag = indexPath.row;
        [cell.detail addGestureRecognizer:tap];
        
        NSString *depart = [[NSString alloc] init];
        if (model.depart.count > 1) {
            for (NSDictionary *dic in model.depart) {
                NSString *str = dic[@"departname"];
                depart = [depart stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
            }
            cell.company.text = depart;
        } else if (model.depart.count == 1) {
            NSDictionary *dic = model.depart[0];
            depart = dic[@"departname"];
            cell.company.text = depart;
        }
        //打电话的按钮
        cell.call.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        cell.call.tag = indexPath.row;
        [cell.call addGestureRecognizer:tap1];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 1) {
       TongxunluModel *model = [_dataArray objectAtIndex:indexPath.row];
       // 创建单聊视图控制器。
       RCChatViewController *chatViewController = [[RCIM sharedRCIM]createPrivateChat:model.idEQ title:model.name completion:^(){
       // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
       }];
       // 把单聊视图控制器添加到导航栈。
       [self.navigationController pushViewController:chatViewController animated:YES];
    }
    if (tableView.tag == 2) {
        TongxunluModel *model = [_searArray objectAtIndex:indexPath.row];
        // 创建单聊视图控制器。
        RCChatViewController *chatViewController = [[RCIM sharedRCIM]createPrivateChat:model.idEQ title:model.name completion:^(){
        // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
        }];
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
}

- (void)callPhone:(UITapGestureRecognizer *)tap
{
    TongxunluModel *model = [_dataArray objectAtIndex:tap.view.tag];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",model.cellno]]];
}

- (void)checkDetail:(UITapGestureRecognizer *)tap {
    
    _m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    _m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //
    _hide_keHuPopViewBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [_m_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_m_keHuPopView];
    
    _Detail = [[[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:self options:nil] firstObject];
    _Detail.center = CGPointMake(KscreenWidth/2, KscreenHeight/2);
 
    TongxunluModel *model = [_dataArray objectAtIndex:tap.view.tag];
    if ([model.sex isEqualToString:@"0"]) {
        _Detail.sex.text = @"男";
    } else if ([model.sex isEqualToString:@"1"]) {
        _Detail.sex.text = @"女";
    }
    _Detail.name.text = model.name;
    _Detail.firstWord.text  = [_Detail.name.text substringToIndex:1];
    _Detail.cell.text = model.cellno;
    _Detail.email.text = model.email;
    _Detail.beizhu.text = model.note;
    _Detail.work.text = model.myposition;
    
    NSString *depart = [[NSString alloc] init];
    if (model.depart.count > 1) {
        for (NSDictionary *dic in model.depart) {
            NSString *str = dic[@"departname"];
            depart = [depart stringByAppendingString:[NSString stringWithFormat:@" %@",str]];
        }
        _Detail.bumen.text = depart;
    } else if (model.depart.count == 1) {
        NSDictionary *dic = model.depart[0];
        depart = dic[@"departname"];
        _Detail.bumen.text = depart;
    }
    [_m_keHuPopView addSubview:_Detail];
}
- (void)closePop{
    [_hide_keHuPopViewBut removeFromSuperview];
    [_Detail removeFromSuperview];
    [_m_keHuPopView removeFromSuperview];
}
@end
