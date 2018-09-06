//
//  THPictureView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/11/3.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "THPictureView.h"
#import "THPicCell.h"
#import "THPicModel.h"
#import "DataPost.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface THPictureView ()<UITableViewDataSource,UITableViewDelegate>{
    
    UIRefreshControl *_refreshControl;
    UITableView *_picTableView;
    NSMutableArray *_dataArray;
    MBProgressHUD *_HUD;
    UIView *_backView;
}

@end

@implementation THPictureView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"退货图片详情";
    
    [self initTableView];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    [self dataRequset];
    
    
}

- (void)initTableView{
    _picTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64 - 49)];
    _picTableView.delegate = self;
    _picTableView.dataSource = self;
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(picRefreshData) forControlEvents:UIControlEventValueChanged];
//    [_picTableView addSubview:_refreshControl];
    _picTableView.rowHeight = 80;
    [self.view addSubview:_picTableView];
    //     下拉刷新
    _picTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self picRefreshDown];
        // 结束刷新
        [_picTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _picTableView.mj_header.automaticallyChangeAlpha = YES;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_1";
    THPicCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (THPicCell *)[[[NSBundle mainBundle] loadNibNamed:@"THPicCell" owner:self options:nil]lastObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (_dataArray.count != 0) {
        cell.model = _dataArray[indexPath.row];

        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _backView.backgroundColor = [UIColor grayColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(KscreenWidth - 60, KscreenHeight - 64 -40, 50, 30);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,KscreenHeight - 64 -40)];
    showImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (_dataArray.count != 0) {
        THPicModel *model = [_dataArray objectAtIndex:indexPath.row];
        NSString *imageStr = [NSString stringWithFormat:@"%@%@%@",PHOTO_ADDRESS,@"/uploadfile/",model.fileid];
        NSURL *imageURL = [NSURL URLWithString:imageStr];
        [showImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"zp3.png"]];
        [_backView addSubview:showImageView];
        [_backView addSubview:button];
        [self.view addSubview:_backView];
    }
    
    //添加一个轻点手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchButtonAction:)];
    singleTap.numberOfTouchesRequired = 1;
    [ _backView addGestureRecognizer:singleTap];

}


- (void)touchButtonAction:(UIButton*)button{
    [_backView removeFromSuperview];
}




#pragma mark - 数据加载

- (void)dataRequset{
    /*
     Upload
     action=getFiles
     tableName=sto_goods_return
     isenable=1
     tableId= 111
     */
    _dataArray = [NSMutableArray array];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/Upload?action=getFiles&tableName=sto_goods_return"];
    NSDictionary *params = @{@"action":@"getFiles",@"tableName":@"sto_goods_return",@"tableId":[NSString stringWithFormat:@"%@",_tHIId]};
    
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"退货图片详情:%@",array);
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    THPicModel *model = [[THPicModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                
                [_picTableView reloadData];
            }else if (array.count == 0){
            
                [self showAlert:@"暂无图片！"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
        [_HUD hide:YES];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //  [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];

}

- (void)picRefreshData
{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(picRefreshDown) userInfo:nil repeats:NO];
}

- (void)picRefreshDown
{   [_dataArray removeAllObjects];
    
    [self dataRequset];
    [_refreshControl endRefreshing];
}


@end
