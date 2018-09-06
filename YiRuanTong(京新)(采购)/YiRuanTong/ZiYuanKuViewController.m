//
//  ZiYuanKuViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZiYuanKuViewController.h"
#import "ZYKCell.h"
#import "AFNetworking.h"
#import "ZYKModel.h"
#import "MBProgressHUD.h"
#import "ZYKDeatilView.h"
#import "DataPost.h"
#import "LXPreViewVC.h"
#import <QuickLook/QuickLook.h>
@interface ZiYuanKuViewController ()<QLPreviewControllerDataSource>{
    UIRefreshControl *_refreshControl;
    NSInteger _page;
    NSMutableArray *_dataArray;
    
    
    MBProgressHUD *_HUD;
    
}
@property (strong, nonatomic)QLPreviewController *previewController;
@property (copy, nonatomic)NSURL *fileURL; //文件路径


@end

@implementation ZiYuanKuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资源库";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    _page = 1;
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    self.zyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    self.zyTableView.delegate = self;
    self.zyTableView.dataSource = self;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.zyTableView addSubview:_refreshControl];
    [self.view addSubview:self.zyTableView];
    //     下拉刷新
//    self.zyTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
//        [self refreshDown];
//        // 结束刷新
//        [self.zyTableView.mj_header endRefreshing];
//
//    }];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.zyTableView.mj_header.automaticallyChangeAlpha = YES;
//    // 上拉刷新
//    self.zyTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
//        [self upRefresh];
//        [self.zyTableView.mj_footer endRefreshing];
//    }];
}
//数据加载
- (void)DataRequest{
    /*
     picture
     action:"getFolders"
     page:"1"
     rows:"20"
     */
    //数据接口拼接
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/Upload"];
    NSDictionary *params = @{@"action":@"getFiles",@"tableName":@"filtermanager",@"isenable":@"1",@"tableId":@"12"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
//        NSArray *array = dic[@"rows"];
        NSLog(@"资源库列表:%@",array);
        for (NSDictionary *dic in array) {
            ZYKModel *model = [[ZYKModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.zyTableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
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
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//        [self upRefresh];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_zyk";
    ZYKCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYKCell" owner:self options:nil]lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (_dataArray.count != 0) {
        cell.model = _dataArray[indexPath.row];
    }
    
    
    return cell;
}
//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYKModel * model = _dataArray[indexPath.row];
    NSString * link = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,@"uploadfile",model.fileid];
    [self loadFileDataWithLink:link];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75;
}
-(void)loadFileDataWithLink:(NSString *)link{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = link;
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
        [self presentViewController:self.previewController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.previewController refreshCurrentPreviewItem];
    }else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"下载中...";
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            _hud.labelText = @"加载完成";
            [_hud hide:YES afterDelay:1];
            self.fileURL = filePath;
            [self presentViewController:self.previewController animated:YES completion:nil];
            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
            [self.previewController refreshCurrentPreviewItem];
        }];
        [downloadTask resume];
    }
}
//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}
@end
