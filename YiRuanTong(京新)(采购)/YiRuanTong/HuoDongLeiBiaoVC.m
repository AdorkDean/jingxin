//
//  HuoDongLeiBiaoVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "HuoDongLeiBiaoVC.h"
#import "ZhaoPianViewController.h"
#import "HuoDongCell.h"
#import "ZhaoPianLieBiaoVC.h"
#import "HuoDongLieBiaoModel.h"
#import "DataPost.h"
#import "DWandLXModel.h"
#import "MBProgressHUD.h"
#import "ZhaoPianShangChuanVC.h"
#import "ZhaoPianModel.h"
@interface HuoDongLeiBiaoVC ()<UITextFieldDelegate>{
    
    UITableView *_huoDongTableView;
    UIRefreshControl *_refreshControl;
    NSMutableArray *_dataArray;
    NSMutableArray *_typeArray;
    NSMutableArray * _photoArr;
    NSInteger _page;
    NSInteger _ppage;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    //
    UIView *_searchView;
    UIView *_backView;
    UIView *_backViews;
    UIButton* _barHideBtn;
    UITextField *_custField;
    UIButton *_typeButton;
    UIView *_keHuPopView;
    NSString * _pictureTypeid;
    MBProgressHUD *_HUD;
    NSString * _tempString;
    UIButton *_hide_keHuPopViewBut;
}
@property(nonatomic,retain)UITableView *TypetableView;
@end

@implementation HuoDongLeiBiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    _ppage = 1;
    _searchFlag = 0;
    _searchPage = 1;
    _searchDateArray = [[NSMutableArray alloc]init];
    _photoArr = [[NSMutableArray alloc]init];
    self.title = @"照片列表";
    self.navigationItem.rightBarButtonItem = nil;
    [self showBarWithName:@"拍照" addBarWithName:@"搜索"];
    
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    [self initTableView];
    [self searchView];
    [self photoRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"newPhoto" object:nil];
    
}
#pragma mark - 搜索页面
- (void)searchView{
    _barHideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _barHideBtn.frame = CGRectMake(0, 0, KscreenWidth, 64);
    _barHideBtn.backgroundColor = [UIColor clearColor];
    _barHideBtn.hidden = YES;
    [_barHideBtn addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_barHideBtn];
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
    
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _searchView.frame.size.width/3, 45)];
    Label1.text = @"客户名称";
    Label1.backgroundColor = COLOR(231, 231, 231, 1);
    Label1.font = [UIFont systemFontOfSize:14];
    Label1.textAlignment = NSTextAlignmentCenter;
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(_searchView.frame.size.width/3, 0, _searchView.frame.size.width/3*2, 45)];
    _custField.font = [UIFont systemFontOfSize:14];
    _custField.delegate = self;
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, _searchView.frame.size.width, 1)];
    nameView.backgroundColor = [UIColor lightGrayColor];
    [_searchView addSubview:Label1];
    [_searchView addSubview:_custField];
    [_searchView addSubview:nameView];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, _searchView.frame.size.width/3, 45)];
    label2.text = @"照片类型";
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.font = [UIFont systemFontOfSize:14];
    label2.textAlignment = NSTextAlignmentCenter;
    [_searchView addSubview:label2];
    _typeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _typeButton.frame = CGRectMake(_searchView.frame.size.width/3, 46, _searchView.frame.size.width/3*2, 45);
    [_typeButton setTintColor:[UIColor blackColor]];
    _typeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_typeButton addTarget:self action:@selector(picTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:_typeButton];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 91, _searchView.frame.size.width, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [_searchView addSubview:view1];
    
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(20, 91 +30, 60, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    chongZhi.frame = CGRectMake(120, 91 + 30, 60, 30);
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    [_searchView addSubview:searchBtn];
    [_searchView addSubview:chongZhi];
    [self.view  addSubview:_searchView];
    _searchView.hidden = YES;
    
}
#pragma mark -搜索页面方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
    
}

- (void)picTypeAction{
    
    _typeButton.userInteractionEnabled = NO;
    
    _keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    _keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //
    _hide_keHuPopViewBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    [_hide_keHuPopViewBut addTarget:self action:@selector(closepop) forControlEvents:UIControlEventTouchUpInside];
    [_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_keHuPopView];
    
    UIView *grayview = [[UIView alloc]initWithFrame:CGRectMake(60, 74, KscreenWidth-120, 30)];
    grayview.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_keHuPopView addSubview:grayview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_keHuPopView.frame.size.width - 100, 74, 40, 30);
    [btn addTarget:self action:@selector(closepop) forControlEvents:UIControlEventTouchUpInside];
    [_keHuPopView addSubview:btn];
    if (self.TypetableView == nil) {
        self.TypetableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 30+74, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.TypetableView.backgroundColor = [UIColor whiteColor];
    }
    self.TypetableView.dataSource = self;
    self.TypetableView.delegate = self;
    [_keHuPopView addSubview:self.TypetableView];
    [self picTypeRequest];
    
}


- (void)picTypeRequest{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSDictionary *params = @{@"action":@"getPicTypeInBase"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        _typeArray = [NSMutableArray array];
        
        for (NSDictionary *dic  in array) {
            DWandLXModel *model = [[DWandLXModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_typeArray addObject:model];
        }
        [self.TypetableView reloadData];
        NSLog(@"照片类型%@",array);
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
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
- (void)closepop
{
    
    if ([self keyboardDid]) {
        [_custField resignFirstResponder];
    }else{
        _typeButton.userInteractionEnabled = YES;
        [_keHuPopView removeFromSuperview];
        [_hide_keHuPopViewBut removeFromSuperview];
    }
}
- (void)addNext{
    
    ZhaoPianShangChuanVC *shangbaoVC = [[ZhaoPianShangChuanVC alloc] init];
    [self.navigationController pushViewController:shangbaoVC animated:YES];
    
}
- (void)searchAction{
   
    if ([_searchView isHidden]) {
        _searchView.hidden = NO;
        _backView.hidden = NO;
        _barHideBtn.hidden = NO;
    }
    else if (![_searchView isHidden])
    {
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
    }

}


#pragma mark - 搜索点击方法
- (void)search
{
    _searchFlag = 1;
    _searchPage = 1;
    [self searchData];
}

- (void)searchData
{
    /*
     action:"customerBenQIYingShou"
     page:"1"
     rows:"20"
     
     params:"{"custidEQ":"2004","danjuhaoEQ":"","createtimeGE":"","createtimeLE":""}"
     */
    
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    NSString *picType = _typeButton.titleLabel.text;
    picType = [self convertNull:picType];
    _pictureTypeid = [self convertNull:_pictureTypeid];
    
    
    if ([custName isEqualToString:@""]&&[picType isEqualToString:@""]&&[_pictureTypeid isEqualToString:@""]) {
        _searchFlag = 0;
        [self photoRequest];
        return;
    }
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSDictionary *params = @{@"action":@"getPicOfCusts",@"mobile":@"true",@"rows":@"20",@"table":@"wjsc",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"params":[NSString stringWithFormat:@"{\"pictypeidEQ\":\"%@\",\"custnameLIKE\":\"%@\"}",_pictureTypeid,custName]};
   
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
//    NSDictionary *params = @{@"action":@"getCusts",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"rows":@"20",@"table":@"wjlb",@"mobile":@"true",@"pictypeidEQ":[NSString stringWithFormat:@"%@",_pictureTypeid],@"custnameLIKE":[NSString stringWithFormat:@"%@",custName]};
    NSLog(@"上传数据%@",params);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"照片列表搜索数据%@",dic);
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            ZhaoPianModel *model = [[ZhaoPianModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_searchDateArray addObject:model];
        }
        [_huoDongTableView reloadData];
        [_HUD hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"照片数据加载失败");
        [_HUD hide:YES];
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
}

- (void)chongZhi
{
    _custField.text = @" ";
    [_typeButton setTitle:@" " forState:UIControlStateNormal];
}



#pragma mark - 页面
- (void)initTableView{
    
    _huoDongTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    _huoDongTableView.delegate = self;
    _huoDongTableView.dataSource = self;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_huoDongTableView addSubview:_refreshControl];
    [self.view addSubview:_huoDongTableView];
    //     下拉刷新
    _huoDongTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_huoDongTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _huoDongTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _huoDongTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_huoDongTableView.mj_footer endRefreshing];
    }];
}
- (void)photoRequest
{/*
  picture？
  idEQ    32
  mobile  true
  action  getPicOfCusts
  page    1
  rows    10
  table   wjsc*/
    //获取列表的图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSDictionary *params = @{@"action":@"getPicOfCusts",@"mobile":@"true",@"rows":@"20",@"table":@"wjsc",@"page":[NSString stringWithFormat:@"%zi",_page]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"照片列表返回数据:%@",array);
        for (NSDictionary *dic in array) {
            ZhaoPianModel *model = [[ZhaoPianModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [_huoDongTableView reloadData];
        [_HUD removeFromSuperview];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"图片详情加载失败");
        NSLog(@"加载失败");
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
//-(void)DataRequest
//{/*
//  http://182.92.96.58:8005/yrt/servlet/picture
//  pictypeidEQ     164
//  mobile  true
//  action  getCusts
//  page    1
//  rows    10
//  table   wjlb
//  */
//
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
//    NSDictionary *params = @{@"action":@"getCusts",@"page":[NSString stringWithFormat:@"%zi",_page],@"rows":@"20",@"table":@"wjlb",@"mobile":@"true",@"pictypeLIKE":@"",@"custName":@""};
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"照片列表数据%@",dic);
//        NSArray *array = dic[@"rows"];
//        for (NSDictionary *dic in array) {
//            HuoDongLieBiaoModel *model = [[HuoDongLieBiaoModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:model];
//        }
////        [_huoDongTableView reloadData];
//        [_HUD hide:YES];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"照片数据加载失败");
//        [_HUD hide:YES];
//        NSInteger errorCode = error.code;
//        NSLog(@"错误信息%@",error);
//        if (errorCode == 3840 ) {
//            NSLog(@"自动登录");
//            [self selfLogin];
//        }else{
//
//            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
//        }
//
//    }];
//
//}

- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
        [self searchData];
    }else{
        [_HUD show:YES];
        _page++;
        [self photoRequest];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//        [self upRefresh];
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
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        [self searchData];
        [_refreshControl endRefreshing];
    }else{
        [_dataArray removeAllObjects];
        _page = 1;
        [self photoRequest];
        [_refreshControl endRefreshing];
    }


}

#pragma mark UITableView Delegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _huoDongTableView) {
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray.count;
        }
    }else if (tableView == self.TypetableView){
        return _typeArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    HuoDongCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = (HuoDongCell*)[[[NSBundle mainBundle]loadNibNamed:@"HuoDongCell" owner:self options:nil]firstObject];
        
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (tableView == _huoDongTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {

                ZhaoPianModel *zpModel = [_searchDateArray objectAtIndex:indexPath.row];
                cell.model = zpModel;
          
            }
        }else{
            if (_dataArray.count != 0) {
                ZhaoPianModel *zpModel = [_dataArray objectAtIndex:indexPath.row];
                cell.model = zpModel;
            }
        }
        return cell;
    }else if (tableView == self.TypetableView){
        
        DWandLXModel *model = _typeArray[indexPath.row];
        cell1.textLabel.text = model.name;
        
        return cell1;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView  == _huoDongTableView) {
        _backViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
        _backViews.backgroundColor = [UIColor grayColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(KscreenWidth - 60, KscreenHeight - 64 -40, 50, 30);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,KscreenHeight - 64 -40)];
        showImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (_searchFlag == 0) {
            if (_dataArray.count != 0) {
                ZhaoPianModel *model = [_dataArray objectAtIndex:indexPath.row];
                NSString *imageStr = [NSString stringWithFormat:@"%@%@%@",PHOTO_ADDRESS,@"/uploadPicture/",model.autofilename];
                NSURL *imageURL = [NSURL URLWithString:imageStr];
                [showImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"zp3.png"]];
                [_backViews addSubview:showImageView];
                [_backViews addSubview:button];
                [self.view addSubview:_backViews];
            }
        }else{
            if (_searchDateArray.count != 0) {
                ZhaoPianModel *model = [_searchDateArray objectAtIndex:indexPath.row];
                NSString *imageStr = [NSString stringWithFormat:@"%@%@%@",PHOTO_ADDRESS,@"/uploadPicture/",model.autofilename];
                NSURL *imageURL = [NSURL URLWithString:imageStr];
                [showImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"zp3.png"]];
                [_backViews addSubview:showImageView];
                [_backViews addSubview:button];
                [self.view addSubview:_backViews];
            }
        }
        //添加一个轻点手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchButtonAction:)];
        singleTap.numberOfTouchesRequired = 1;
        [ _backViews addGestureRecognizer:singleTap];

    }else if (tableView == self.TypetableView){
        
        _typeButton.userInteractionEnabled = YES;
        [_keHuPopView removeFromSuperview];
        DWandLXModel *model = _typeArray[indexPath.row];
        [_typeButton setTitle:model.name forState:UIControlStateNormal];
        _pictureTypeid = model.Id;
        _tempString = model.Id;
    }
    
}
- (void)touchButtonAction:(UIButton*)button{
    [_backViews removeFromSuperview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhaoPianModel * _zmodel;
    if (_searchFlag == 0) {
        
        if (tableView == self.TypetableView) {
            return 45;
        }else{
            if (_dataArray.count) {
                _zmodel  = _dataArray[indexPath.row];
            }
            if (_zmodel.filenote.length <13) {
                return 93;
            }
            return 110;
        }
    }else{
        
        if (tableView == self.TypetableView) {
            return 45;
        }else{
            if (_searchDateArray.count) {
                _zmodel  = _searchDateArray[indexPath.row];
            }
            if (_zmodel.filenote.length <13) {
                return 93;
            }
            return 110;
        }
    }
    
    
}
//- (NSString *)description
//
//{
//    
//    return [NSString stringWithFormat:@"<%@ : %p,\"%@ %@\">",[selfclass],self,_name,_work];
//    
//}

@end
