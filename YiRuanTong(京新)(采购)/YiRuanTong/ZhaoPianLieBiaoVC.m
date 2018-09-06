//
//  ZhaoPianLieBiaoVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZhaoPianLieBiaoVC.h"
#import "HuoDongLeiBiaoVC.h"
#import "TuPianLieBiaoCell.h"
#import "UIImageView+WebCache.h"
#import "ZhaoPianModel.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
@interface ZhaoPianLieBiaoVC (){

    UITableView *_tuPianTableView;
    UIView *_backView;//图片背景
    UIRefreshControl *_refreshControl;
    NSMutableArray *_dataArray;
    NSInteger _page;
    MBProgressHUD *_HUD;
    BOOL _isSelectFinish;
    NSMutableArray* _delIDArray;
    NSMutableIndexSet *_indexSetToDel;
}

@end

@implementation ZhaoPianLieBiaoVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _delIDArray = [[NSMutableArray alloc]init];
    _indexSetToDel = [[NSMutableIndexSet alloc]init];
    _page = 1;
    self.title = @"照片列表";
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(KscreenWidth - 70, 10, 50, 40);
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNext:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
     [self initTableView];
//     [self DataRequest];
    

}

- (void)initTableView{
    
    _tuPianTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 14) style:UITableViewStylePlain];
    _tuPianTableView.delegate = self;
    _tuPianTableView.dataSource = self;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_tuPianTableView addSubview:_refreshControl];
    [self.view addSubview:_tuPianTableView];
    //     下拉刷新
    _tuPianTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_tuPianTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tuPianTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tuPianTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_tuPianTableView.mj_footer endRefreshing];
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
{   [_dataArray removeAllObjects];
    _page = 1;
//    [self DataRequest];
    [_refreshControl endRefreshing];
}

- (void)upRefresh
{
    _page++;
//    [self DataRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 15) {
//        [self upRefresh];
    }
}

#pragma mark UITable Delegata And DataSource 方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    TuPianLieBiaoCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = (TuPianLieBiaoCell*)[[[NSBundle mainBundle]loadNibNamed:@"TuPianLieBiaoCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count != 0) {
        
       ZhaoPianModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.tuPianName.text = model.srcfilename;
        cell.tuPianLieXing.text = model.pictype;
        //图片加载URl
        NSString *imagestr = [NSString stringWithFormat:@"%@%@%@",PHOTO_ADDRESS,@"/uploadPicture/",model.autofilename];
        
        [cell.lieBiaoImageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"zp3.png"]];
        return cell;
    }
    return cell;
}

//协议中取消选中tableView中某行时被调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tuPianTableView.editing) {
        //把之前选中的行号扔掉
        ZhaoPianModel *model = _dataArray[indexPath.row];
        model.isselect = @"0";
        [_delIDArray removeObject:model];
        [_indexSetToDel removeIndex:indexPath.row];

        if ([model.isselect integerValue] == 1) {
            [_delIDArray addObject:model];
        }
        if (_delIDArray.count == _dataArray.count) {
//            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        }else{
//            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tuPianTableView.editing) {
        //是编辑状态，记录选中的行号做数组下标
        ZhaoPianModel *model = _dataArray[indexPath.row];
        model.isselect = @"1";
        [_delIDArray addObject:model];
        [_indexSetToDel addIndex:indexPath.row];
        if (_delIDArray.count == _dataArray.count) {
//            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        }else{
//            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
    }else{
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
            ZhaoPianModel *model = [_dataArray objectAtIndex:indexPath.row];
            NSString *imageStr = [NSString stringWithFormat:@"%@%@%@",PHOTO_ADDRESS,@"/uploadPicture/",model.autofilename];
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
}

- (void)touchButtonAction:(UIButton*)button{
    [_backView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;//表示多选状态
}

- (void)addNext:(UIButton*)sender{
    _isSelectFinish = !_isSelectFinish;
    if (_isSelectFinish == NO) {
        for (int i= 0 ; i < _dataArray.count; i++) {
            ZhaoPianModel *model = _dataArray[i];
            if ([model.isselect integerValue] == 1) {
                [_delIDArray addObject:model];
            }
        }
        //点击编辑
        if (!IsEmptyValue(_delIDArray)) {
            [self DelProductCollectRequest:sender];
        }
        [_tuPianTableView setEditing:NO animated:YES];
    }else{
        //点击完成
        [sender setTitle:@"删除" forState:UIControlStateNormal];
        [_tuPianTableView reloadData];
        [_tuPianTableView setEditing:YES animated:YES];
    }
}
//删除的接口
- (void)DelProductCollectRequest:(UIButton*)sender{
    /*
     /product/delproductcollect.do
     mobile:true
     data{
     ids:1,2,3
     custid:用户id
     }
     */
    NSMutableString* delestr = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0; i < _delIDArray.count; i++) {
        ZhaoPianModel *model = _delIDArray[i];
        NSString* str = [NSString stringWithFormat:@"%@,",model.Id];
        [delestr appendString:str];
    }
    NSString* idstr = delestr;
    NSRange range = {0,idstr.length - 1};
    idstr = [idstr substringWithRange:range];
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"deleteUpload" forKey:@"action"];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\"}",idstr];
    [params setObject:datastr forKey:@"data"];
    NSLog(@"删除收藏传参数%@",params);
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"删除收藏返回str%@",str);
            if ([str rangeOfString:@"true"].location != NSNotFound) {
                [self showAlert:@"删除收藏成功"];
                [sender setTitle:@"编辑" forState:UIControlStateNormal];
                [_delIDArray removeAllObjects];
                [_dataArray removeAllObjects];
//                [self DataRequest];
            }else{
                [self showAlert:@"删除收藏不成功"];
            }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        sender.enabled = YES;
        [self showAlert:error.localizedDescription];
        NSLog(@"删除收藏失败%@",error.localizedDescription);
    }];

    


}



@end
