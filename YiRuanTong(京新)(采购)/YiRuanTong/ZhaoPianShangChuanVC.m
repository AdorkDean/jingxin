//
//  ZhaoPianShangChuanVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZhaoPianShangChuanVC.h"
#import "ZhaoPianViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "Example2CollectionViewCell.h"
#import "ZLPhoto.h"
#import "ZLPhotoPickerCommon.h"
#import "DataPost.h"
#import "KHmanageModel.h"
#import "CustCell.h"
@interface ZhaoPianShangChuanVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

{
    NSString *_photoID;
    NSString *_backMessage;
    UIView *_keHuPopView;

    NSInteger _page;
    NSMutableArray *_dataArray;
    MBProgressHUD *_hud;
    MBProgressHUD *_hud1;
    UIButton *_CustButton;
    UIPopoverController *_popoverController;
    NSString *_device;
    
    
    UITextField *_custField;
    
    UIButton *_hide_keHuPopViewBut;
}
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;
@property(nonatomic,retain) UITableView *custTableView;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableDictionary *dictM;

@property(nonatomic,retain)UIScrollView *photo;
@end

@implementation ZhaoPianShangChuanVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片上传";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self PageViewDidLoad1];
    UIDevice *device = [[UIDevice alloc] init];
    _device = device.model;
    [self setupUI];
    [self photoTypeRequest];
}

#pragma mark - 页面
-(void)PageViewDidLoad1
{   self.photo = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _photo.contentSize = CGSizeMake(KscreenWidth, KscreenHeight -64 -49);
    _photo.bounces = NO;
    [self.view addSubview:_photo];
    //右侧按钮

   
    UIButton  *shangChuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shangChuanButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    shangChuanButton.showsTouchWhenHighlighted = YES;
    [shangChuanButton setTitle:@"上传" forState:UIControlStateNormal];
    [shangChuanButton addTarget:self action:@selector(ShangChuanAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *right = [[UIBarButtonItem alloc] initWithCustomView:shangChuanButton];
    self.navigationItem.rightBarButtonItem = right;
#pragma mark - 点击后呼出菜单 打开摄像机 查找本地相册
    //下方的图片按钮 点击后呼出菜单 打开摄像机 查找本地相册
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_add" ofType:@"png"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 5, 60, 60);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    //加在视图
    [self.photo addSubview:button];
    //下方类型试图
    UIImageView *huoDongView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 90, 150)];
    huoDongView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.photo addSubview:huoDongView];
    UIView *name1=[[UIView alloc]initWithFrame:CGRectMake(0, 130, KscreenWidth, 1)];
    name1.backgroundColor =[UIColor grayColor];
    [self.photo addSubview:name1];
    UIView *name2 =[[UIView alloc]initWithFrame:CGRectMake(0, 180, KscreenWidth, 1)];
    name2.backgroundColor =[UIColor grayColor];
    [self.photo addSubview:name2];
    UIView *name3 =[[UIView alloc]initWithFrame:CGRectMake(0, 230, KscreenWidth, 1)];
    name3.backgroundColor = [UIColor grayColor];
    [self.photo addSubview:name3];
    UIView *name4 =[[UIView alloc]initWithFrame:CGRectMake(90, 80, 1, 150)];
    name4.backgroundColor =[UIColor grayColor];
    [self.photo addSubview:name4];
    
    UILabel *mingChen = [[UILabel alloc]initWithFrame:CGRectMake(10, 102, 150, 30)];
    mingChen.text = @"客户/活动";
    mingChen.textColor = [UIColor blackColor];
    mingChen.backgroundColor = [UIColor clearColor];
    [self.photo addSubview:mingChen];
    
    _mingChen2 = [[UITextField alloc]initWithFrame:CGRectMake(94, 102, 160, 40)];
    _mingChen2.textColor = [UIColor blackColor];
    [self.photo addSubview:_mingChen2];
    
    //客户的按钮
    _CustButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _CustButton.tag = 1001;
    _CustButton.frame = CGRectMake(KscreenWidth - 80, 92,60, 40);
    [_CustButton setBackgroundImage:[UIImage imageNamed:@"kh_ywy.png"] forState:UIControlStateNormal];
    [_CustButton addTarget:self action:@selector(CustAction) forControlEvents:UIControlEventTouchUpInside];
    [self.photo addSubview:_CustButton];
    
    UILabel *leiXing = [[UILabel alloc]initWithFrame:CGRectMake(10, 152, 150, 30)];
    leiXing.text = @"照片类型";
    leiXing.textColor = [UIColor blackColor];
    leiXing.backgroundColor = [UIColor clearColor];
    [self.photo addSubview:leiXing];
    
    self.leiXingButton = [[UIButton alloc]initWithFrame:CGRectMake(94, 152, 220, 40)];
    [self.leiXingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leiXingButton.tag = 1002;
    [self.leiXingButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    self.leiXingButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentLeft;
    [self.leiXingButton addTarget:self action:@selector(leiXingButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.photo addSubview:self.leiXingButton];
    
    UILabel *miaoShu = [[UILabel alloc]initWithFrame:CGRectMake(10, 202, 150, 30)];
    miaoShu.text = @"照片描述";
    miaoShu.textColor = [UIColor blackColor];
    miaoShu.backgroundColor =[UIColor clearColor];
    [self.photo addSubview:miaoShu];
    
    _miaoShu2 =[[UITextField alloc]initWithFrame:CGRectMake(94, 202, 220, 40)];
     _miaoShu2.textColor =[UIColor blackColor];
    [self.photo addSubview:_miaoShu2];
}

- (void)CustAction{
    
    _CustButton.userInteractionEnabled = NO;
    _keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    _keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //
    _hide_keHuPopViewBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    [_hide_keHuPopViewBut addTarget:self action:@selector(closepop) forControlEvents:UIControlEventTouchUpInside];
    [_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_keHuPopView];
    
    //
    
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 80,KscreenWidth - 180 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
    _custField.borderStyle = UITextBorderStyleRoundedRect;
    _custField.font = [UIFont systemFontOfSize:13];
    [_keHuPopView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, 80, 60, 40);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(getName) forControlEvents:UIControlEventTouchUpInside];
    [_keHuPopView addSubview:btn];
    
    if (self.custTableView == nil) {
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 120,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 10;
    self.custTableView.rowHeight = 60;
    [_keHuPopView addSubview:self.custTableView];
    
    [self nameRequest];
}
- (void)getName{
    
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            KHmanageModel *model = [[KHmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.custTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
}


- (void)nameRequest
{
    //客户名称 的浏览接口
    NSLog(@"页数%zi",_page);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"客户数据%@",dic);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                KHmanageModel *model = [[KHmanageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
        }
        
        [self.custTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户名称加载失败");
    }];
    
}

- (void)upRefresh
{
    _page++;
    [self nameRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
        [self upRefresh];
    }
}

#pragma mark - 照片类型加载方法
- (void)leiXingButtonMethod:(UIButton *)button{
    
    self.leiXingButton.userInteractionEnabled = NO;
    _keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    _keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //
    _hide_keHuPopViewBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    [_hide_keHuPopViewBut addTarget:self action:@selector(closepop) forControlEvents:UIControlEventTouchUpInside];
    [_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_keHuPopView];
    
    UIView *grayview = [[UIView alloc]initWithFrame:CGRectMake(60, 74, KscreenWidth-120, 30)];
    grayview.backgroundColor = [UIColor grayColor];
    [_keHuPopView addSubview:grayview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_keHuPopView.frame.size.width - 100, 74, 40, 20);
    [btn addTarget:self action:@selector(closepop) forControlEvents:UIControlEventTouchUpInside];
    [_keHuPopView addSubview:btn];
    if (self.TypetableView == nil) {
        self.TypetableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 30+74, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.TypetableView.backgroundColor = [UIColor grayColor];
    }
    self.TypetableView.dataSource = self;
    self.TypetableView.delegate = self;
    [_keHuPopView addSubview:self.TypetableView];
    [self photoTypeRequest];

}
- (void)photoTypeRequest{
    

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSDictionary *params = @{@"action":@"getPicTypeInBase"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        _leiXingDataArray = [[NSMutableArray alloc]init];
        _leiXingDataArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"getPicTypeInBase%@",_leiXingDataArray);
        _leiXingName = [[NSMutableArray alloc] init];
        _leiXingID = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in _leiXingDataArray) {
            NSString *str = [dic objectForKey:@"name"];
            NSString *str1 = [dic objectForKey:@"id"];
            [_leiXingName addObject:str];
            [_leiXingID addObject:str1];
        }
        [self.TypetableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录测试11");
            [self selfLogin];
        }else{
            
            [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
//    NSDictionary *parameters = @{@"action":@"getPicTypeInBase"};
//    
//    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        _leiXingDataArray = [[NSMutableArray alloc]init];
//        _leiXingDataArray = responseObject;
//        NSLog(@"%@",_leiXingDataArray);
//        _leiXingName = [[NSMutableArray alloc] init];
//        _leiXingID = [[NSMutableArray alloc] init];
//        for (NSDictionary *dic in responseObject) {
//            NSString *str = [dic objectForKey:@"name"];
//            NSString *str1 = [dic objectForKey:@"id"];
//            [_leiXingName addObject:str];
//            [_leiXingID addObject:str1];
//        }
//        [self.TypetableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败");
//    }];
//


}
- (void)closepop
{
    self.leiXingButton.userInteractionEnabled = YES;
    [_keHuPopView removeFromSuperview];
    [_hide_keHuPopViewBut removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.custTableView) {
        return _dataArray.count;
    } else{
        return _leiXingName.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    CustCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    if (tableView == self.TypetableView) {
        cell.textLabel.text  = _leiXingName[indexPath.row];
        self.nameID = _leiXingID[indexPath.row];
        return cell;

    }else if (tableView == self.custTableView){
        cell2.model = _dataArray[indexPath.row];
        return cell2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.TypetableView){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.leiXingButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.name = cell.textLabel.text;
        self.nameID = _leiXingID[indexPath.row];
        
        self.leiXingButton.userInteractionEnabled = YES;
        [_keHuPopView  removeFromSuperview];
    } else if (tableView == self.custTableView){
        KHmanageModel *model =  _dataArray[indexPath.row];
        _mingChen2.text = model.name;
        _CustButton.userInteractionEnabled = YES;
        [_keHuPopView removeFromSuperview];
    }
    [_keHuPopView removeFromSuperview];
}
#pragma mark - 上传照片的信息
- (void)shangChuan{
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.removeFromSuperViewOnHide = YES;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"mobile=true&action=add&table=wjsc&data={\"table\":\"wjsc\",\"custname\":\"%@\",\"pictypeid\":\"%@\",\"pictype\":\"%@\",\"uploadSite\":\"%@\",\"upLongititudeB\":\"\",\"upLatitudeB\":\"\",\"upLongititudeA\":\"\",\"upLatitudeA\":\"\"}",_mingChen2.text,_nameID,_name,_miaoShu2.text];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        _photoID = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"照片返回ID:%@",_photoID);
        if (_photoID.length != 0) {
            
            
            if (_photoID.length>=2) {
                NSRange range = {1,_photoID.length-2};
                _photoID = [_photoID substringWithRange:range];
            }
            
        }
    }
    
}

- (NSMutableArray *)assets{
    if (!_assets) {
        // CollctionView 可以分组。
        NSMutableArray *section1 = [NSMutableArray array];
                                                                    
        _assets = [NSMutableArray arrayWithObjects:section1, nil];
    }
    return _assets;
}
- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}


- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
    
}

#pragma mark setup UI
- (void)setupCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(70, 5, KscreenWidth - 70, 60) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.assets.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.assets[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Example2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Example2CollectionViewCell" forIndexPath:indexPath];
    
    // 判断类型来获取Image
    ZLPhotoAssets *asset = self.assets[indexPath.section][indexPath.item];
    
    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
        cell.imageView.image = asset.originImage;
    }else if ([asset isKindOfClass:[NSString class]]){
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"pc_circle_placeholder"]];
    }else if([asset isKindOfClass:[UIImage class]]){
        cell.imageView.image = (UIImage *)asset;
    }else if ([asset isKindOfClass:[ZLCamera class]]){
        cell.imageView.image = [asset thumbImage];
    }
    
    return cell;
    
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser show];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return self.assets.count;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.assets[section] count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [self.assets[indexPath.section] objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    // 缩略图
    photo.toView = cell.imageView;
    photo.thumbImage = cell.imageView.image;
    return photo;
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
//#pragma mark 返回自定义View
//- (ZLPhotoPickerCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser{
//    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [customBtn setTitle:@"实现代理自定义ToolBar" forState:UIControlStateNormal];
//    customBtn.frame = CGRectMake(10, 0, 200, 44);
//    return (ZLPhotoPickerCustomToolBarView *)customBtn;
//}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.assets[indexPath.section] count])
        return;
    [self.assets[indexPath.section] removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}

#pragma mark - 选择照片
- (void)selectPhotos{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    cameraVc.maxCount = 6;
    __weak typeof(self) weakSelf = self;
    // 多选相册+相机多拍 回调
    [cameraVc startCameraOrPhotoFileWithViewController:self complate:^(NSArray *object) {
        // 选择完照片、拍照完回调
        [object enumerateObjectsUsingBlock:^(id asset, NSUInteger idx, BOOL *stop) {
            if ([asset isKindOfClass:[ZLCamera class]]) {
                [[weakSelf.assets firstObject] addObject:asset];
            }else{
                [[weakSelf.assets firstObject] addObject:asset];
            }
        }];
        
        [weakSelf.collectionView reloadData];
    }];
    self.cameraVc = cameraVc;
}


#pragma mark -  上传按钮
- (void)ShangChuanAction:(UIButton*)button{
    
    NSString *name = _mingChen2.text;
    NSString *typeName = _leiXingButton.titleLabel.text;
    if (name.length == 0 ||typeName.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"名称或照片类型不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
    [self shangChuan];
    NSLog(@"数据%@",_images);
    NSLog(@"shuju%@",_assets);
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/picture"];
    NSString *name =  _mingChen2.text;
    NSArray *array = _assets[0];
    //取得存储地理位置
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *place = [userDefault objectForKey:@"LocAdress"];
    place = [self convertNull:place];
    NSLog(@"定位位置%@",place);
    
    if (array.count != 0) {
        for (int i = 0;i<array.count;i++) {
            id model = array[i];
            UIImage *image;
            NSDictionary *parameters;
            if ([model isKindOfClass:[ZLCamera class]]) {//相机拍照
                ZLCamera *Camera = model;
                image =  [UIImage imageWithContentsOfFile:Camera.imagePath];
                parameters = @{@"uploadid":_photoID,@"mobile":@"true",@"action":@"uploadPicture",@"filenote":_miaoShu2.text,@"file":Camera.imagePath,@"photoename":name,@"place":place};
            }else if ([model isKindOfClass:[ZLPhotoAssets class]]){//读取相册
                ZLPhotoAssets *Assets = model;
                image =  [UIImage imageWithCGImage:[[Assets.asset defaultRepresentation] fullScreenImage]];
                parameters = @{@"uploadid":_photoID,@"photoename":name,@"place":place,@"mobile":@"true",@"action":@"uploadPicture",@"filenote":_miaoShu2.text,@"file":@" "};
            }
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSLog(@"拍照字典%@,%@",url,parameters);
            [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                NSString *name =  _mingChen2.text;
                NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
                //NSData *imageData = UIImagePNGRepresentation(image);
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                NSLog(@"拍照图片命名%@",fileName);
                
                
                [formData appendPartWithFileData:imageData
                                            name:name
                                        fileName:fileName
                                        mimeType:@"image/png"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"上传返回的字符串%@",str);
                str = [self replaceOthers:str];
                NSLog(@"上传返回%@",str);
                if ([str isEqualToString:@"true"]) {
                    [self showAlert:@"拍照上传成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newPhoto" object:self];
                    
                }else{
                    [self showAlert:@"拍照上传失败"];
                }
                [_hud removeFromSuperview];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [_hud removeFromSuperview];
            }];
            
        }
//        id model = array[0];
//        //相机拍照
//        if ([model isKindOfClass:[ZLCamera class]]) {
//            for (ZLCamera *model in array) {
//                NSLog(@"照片%@",model.imagePath);
//                UIImage *image =  [UIImage imageWithContentsOfFile:model.imagePath];
//                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//                NSDictionary *parameters = @{@"uploadid":_photoID,@"mobile":@"true",@"action":@"uploadPicture",@"filenote":_miaoShu2.text,@"file":model.imagePath,@"photoename":name,@"place":place};
//                NSLog(@"拍照字典%@,%@",url,parameters);
//                [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//                    NSString *name =  _mingChen2.text;
//                    NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
//                    NSData *imageData = UIImagePNGRepresentation(image);
//                    NSLog(@"拍照图片命名%@",fileName);
//
//
//                    [formData appendPartWithFileData:imageData
//                                                name:name
//                                            fileName:fileName
//                                            mimeType:@"image/png"];
//
//                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//
//                    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                    NSLog(@"上传返回的字符串%@",str);
//                    str = [self replaceOthers:str];
//                    NSLog(@"上传返回%@",str);
//                    if ([str isEqualToString:@"true"]) {
//                        [self showAlert:@"拍照上传成功"];
//                        [self.navigationController popViewControllerAnimated:YES];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPhoto" object:self];
//
//                    }else{
//                        [self showAlert:@"拍照上传失败"];
//                    }
//                    [_hud removeFromSuperview];
//
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"Error: %@", error);
//                    [_hud removeFromSuperview];
//                }];
//
//
//
//            }
//            //读取相册
//        }else if([model isKindOfClass:[ZLPhotoAssets class]]){
//
//
//            for (ZLPhotoAssets *model in array) {
//                UIImage *image =  [UIImage imageWithCGImage:[[model.asset defaultRepresentation] fullScreenImage]];
//                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//                NSDictionary *parameters = @{@"uploadid":_photoID,@"photoename":name,@"place":place,@"mobile":@"true",@"action":@"uploadPicture",@"filenote":_miaoShu2.text,@"file":@" "};
//                NSLog(@"相册字典%@%@",url,parameters);
//                [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//                    NSString *name =  _mingChen2.text;
//                    NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
//                    NSData *imageData = UIImagePNGRepresentation(image);
//
//                     NSLog(@"相册图片上传命名%@",fileName);
//                    [formData appendPartWithFileData:imageData
//                                                name:name
//                                            fileName:fileName
//                                            mimeType:@"image/png"];
//
//                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//
//
//                    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                    NSLog(@"上传返回的str%@",str);
//                    str = [self replaceOthers:str];
//                    NSLog(@"上传返回%@",str);
//                    if ([str isEqualToString:@"true"]) {
//                        [self showAlert:@"拍照上传成功"];
//                        [self.navigationController popViewControllerAnimated:YES];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPhoto" object:self];
//                    }else{
//                        [self showAlert:@"拍照上传失败"];
//                    }
//
//                    [_hud removeFromSuperview];
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"Error: %@", error);
//                    [_hud removeFromSuperview];
//                }];
//            }
//        }

    }else if(array.count == 0 ){
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"请添加照片！"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确定", nil];
    
        [tan show];
    }
    }
}



@end
