//
//  ZYKDeatilView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZYKDeatilView.h"
#import "ZYKDetailCell.h"
#import "AFNetworking.h"
#import "ZYKModel.h"
#import "MBProgressHUD.h"
#import "PreviewDetailView.h"
@interface ZYKDeatilView (){
    

    UIRefreshControl *_refreshControl;
    NSInteger _page;
    NSMutableArray *_dataArray;
    NSString *_downloadStr;

    MBProgressHUD *_HUD;
}
@property(nonatomic,retain)UITableView *zyTableView;

@end

@implementation ZYKDeatilView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the v
    self.title = @"资源库详情";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //数据加载
        [self DataRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            //创建TablView
            [self initTableView];
        });
    });
    
}
//创建TablView
- (void)initTableView{
    _zyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _zyTableView.delegate = self;
    _zyTableView.dataSource = self;
    _zyTableView.rowHeight = 70;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.zyTableView addSubview:_refreshControl];
    [self.view addSubview:_zyTableView];
    //     下拉刷新
    _zyTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_zyTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _zyTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _zyTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_zyTableView.mj_footer endRefreshing];
    }];
}
//数据加载
- (void)DataRequest{
    /*
     picture
     action:"getAllFile"
     page:"1"
     rows:"20"
     params:"{"folderidEQ":"31"}"
     */
    //数据接口拼接
    NSLog(@"ID%@",_Model.Id);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getAllFile&rows=20&page=%zi&params={\"folderidEQ\":\"%@\"}",_page,_Model.Id];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"详情数据%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                ZYKDetailModel *model = [[ZYKDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.zyTableView reloadData];
            [_HUD hide:YES];
        }
        
        }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
        
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
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//        [self upRefresh];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_zyk";
    ZYKDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYKDetailCell" owner:self options:nil]lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (_dataArray.count != 0) {
        cell.model = _dataArray[indexPath.row];
        
    }
   return cell;
}
//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZYKDetailModel *model = _dataArray[indexPath.row];
    PreviewDetailView *preVC  = [[PreviewDetailView alloc] init];
    preVC.model = model;
    UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:@"是否预览？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    [tan show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==  0) {
        [alertView removeFromSuperview];
    }else if(buttonIndex == 1){
        //点击下载
        PreviewDetailView *preVC  = [[PreviewDetailView alloc] init];
        
        
        [self.navigationController pushViewController:preVC animated:YES];
        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        
//        NSURL *URL = [NSURL URLWithString:_downloadStr];
//        NSURLRequest *Request = [NSURLRequest requestWithURL:URL];
//        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:Request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//            
//                NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//                return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
//        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            
//        }];
//        [downloadTask resume];
////        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
//        NSDictionary *parameters = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getFolders"};
//        [manager POST:_downloadStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//            [_HUD hide:YES];
//            [_HUD removeFromSuperview];
        
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"请求失败");
//            [_HUD hide:YES];
//            [_HUD removeFromSuperview];
//            UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [tan show];
//        }];
//
    }

        
}
@end
