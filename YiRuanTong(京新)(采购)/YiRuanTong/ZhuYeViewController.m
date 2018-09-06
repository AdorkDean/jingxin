//
//  ZhuYeViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//
#import "FYShenQingListVC.h"
#import "FYBaoXiaoListVC.h"
#import "ZhuYeViewController.h"
#import "CollectionViewCell.h"
#import "MainCollectionHeadView.h"
#import "HeadTitleCollectionView.h"
#import "VideoListVC.h"
#import "DaiBanViewController.h"
#import "KaoQinViewController.h"
#import "KeHuViewController.h"
#import "LoginViewController.h"
#import "KeHuBFViewController.h"
#import "ChaiWuXinXiViewController.h"
#import "DingDanViewController.h"
#import "ZhaoPianViewController.h"
#import "HuoDongLeiBiaoVC.h"
#import "CaiGouKuCunManagerVC.h"
#import "TuiHuoViewController.h"
#import "XinWenViewController.h"
#import "LXRizhiManagerVC.h"
#import "LunTanViewController.h"
#import "KuCunViewController.h"
#import "GongGaoViewController.h"
#import "JingPinViewController.h"
#import "ZhangKuanViewController.h"
#import "BaoBiaoTongJiViewController.h"
#import "SheZhiViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "RCIM.h"
#import "StringTurnToDictionary.h"
#import "ZiDingYiSPViewController.h"
#import "CPLiulanViewController.h"
#import "FeiYongBaoXiaoViewController.h"
#import "FeiYongShenQingViewController.h"
//#import "ShouHouFuWuViewController.h"
#import "CustomerServiceVC.h"
#import "ZiYuanKuViewController.h"
#import "KHweizhiViewController.h"
#import "DataPost.h"
#import "WLXXViewController.h"
#import "CgInformationManageVC.h"
#import "WLXXViewController.h"
#import "ProductPlanViewController.h"
#import "ProductStoreViewController.h"
#import "ProductMaterialViewController.h"
//#import "BMapKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MQChatViewManager.h"
@interface ZhuYeViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UICollectionView * _collectionView;
    UIRefreshControl *_refreshControl;
    NSDictionary *_dic;
    NSString *_versionUrl;
    BMKLocationService *_locService;
    NSString * _msg;
    
}
@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;
@property(nonatomic)NSString * lblLatitude;
@property(nonatomic)NSString * lblLongitude;

@property(nonatomic,retain)NSDictionary *namePhotoDic;
@property(nonatomic,retain)NSMutableArray *HttpArray;// 请求数据中的名字

@end
//cell
static NSString *const MainCollectionViewCellID = @"CollectionViewCell";
static NSString *const MainCollectionHeadViewID = @"MainCollectionHeadView";
static NSString *const HeadTitleCollectionViewID = @"HeadTitleCollectionView";


@implementation ZhuYeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"德州京信药业有限公司";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:UIColorFromRGB(0x222222)}];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"no" userInfo:nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
}
//-(void)reciviceNotice:(NSNotification *)notice{
//    NSLog(@"%@",notice.userInfo);
//    NSDictionary * info = notice.userInfo;
//    NSDictionary * aps = [info objectForKey:@"aps"];
//    NSString * alert = [aps objectForKey:@"alert"];
//
//    DingDanViewController * vc = [[DingDanViewController alloc]init];
//    vc.orderNo = alert;
//    vc.isNotice = @"1";
//    [self.navigationController pushViewController:vc animated:YES];
//}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciviceNotice:) name:@"backNotification" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    //定位
    [self locate];
    //取消返回按钮 添加 logo
    self.navigationItem.leftBarButtonItem = nil;
    
    //设置按钮
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(KscreenWidth - 25, 12, 25, 25);
    [setButton setImage:[UIImage imageNamed:@"icon_shenglue.png"] forState:UIControlStateNormal];
    setButton.showsTouchWhenHighlighted = YES;
    [setButton addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem = right;
    
    
    //开启定位服务
    [self locate];
    //数据请求
    [self DataRequest];
    [self msgRequest];
    [self versionRequest];
    [self setnamePhotoDic];
    [self collectionView];
    //融云登录用户
    [self getToken];
    // 连接融云服务器。
    [RCIM connectWithToken:_dic[@"token"] completion:^(NSString *userId) {
        // 此处处理连接成功。
        NSLog(@"连接成功:%@",userId);
    } error:^(RCConnectErrorCode status) {
        // 此处处理连接错误。
        NSLog(@"连接失败");
    }];
    //设置通讯录信息
    
}

- (void)setnamePhotoDic{
    _namePhotoDic = @{@"ddgl":@"订单管理",@"thgl":@"退货管理",@"zkgl":@"销售账务",@"kccx":@"库存查询",@"bbtj":@"报表统计",@"cpll":@"产品浏览",@"cgxxgl":@"采购管理",@"cgkcgl":@"库存管理",@"cgwlgl":@"物料管理",@"scgl":@"生产计划管理",@"scckgl":@"生产出库管理",@"scllgl":@"生产领料管理",@"zxkfgl":@"在线客服",@"shfwgl":@"售后服务",
                      @"ggll":@"公告浏览",@"xwll":@"新闻浏览",@"spll":@"视频浏览",
                      @"rzsb":@"日志上报",@"kqgl":@"考勤管理",@"zdysp":@"审批",@"pzsc":@"拍照上传",@"zykgl":@"资源库",@"fysq":@"费用申请",@"fybx":@"费用报销",
                      @"khgl":@"客户管理",@"khgz":@"客户拜访",@"khwz":@"客户位置"};
//    _namePhotoDic = @{@"ddgl":@"订单管理",@"thgl":@"退货管理",@"zkgl":@"销售账务",@"kccx":@"库存查询",@"bbtj":@"报表统计",@"cpll":@"产品浏览",@"cgxxgl":@"采购管理",@"cgkcgl":@"库存管理",@"cgwlgl":@"物料管理",@"scgl":@"生产计划管理",
//                      @"ggll":@"公告浏览",@"xwll":@"新闻浏览",@"spll":@"视频浏览",
//                      @"rzsb":@"日志上报",@"kqgl":@"考勤管理",@"zdysp":@"审批",@"pzsc":@"拍照上传",@"zykgl":@"资源库",
//                      @"khgl":@"客户管理",@"khgz":@"客户拜访",@"khwz":@"客户位置"};
}
- (void)getToken
{
    //获取token
    NSString *strAdress = @"/rongcloud";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getToken";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data2 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data2 != nil) {
        NSString *str2 = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
        NSRange range = {1,str2.length-2};
        if (str2.length != 0) {
            NSString *reallyStr = [[str2 substringWithRange:range] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            _dic = [StringTurnToDictionary parseJSONStringToNSDictionary:reallyStr];
            NSLog(@"获取到的用户token:%@",reallyStr);
        }
    }
}

//主页面的接口
- (void)DataRequest{
    //    //数据接口拼接
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/schedule"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getMenu1";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        
        _HttpArray = [[NSMutableArray alloc] init];
        // NSLog(@"主页加载数据%@",dic);
        for (NSDictionary *dic1  in dic) {
            NSString *name = [dic1 objectForKey:@"url"];
            [_HttpArray addObject:name];
        }
        NSLog(@"登陆返回%@",_HttpArray);
        [_collectionView reloadData];
    }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主页面加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }
    
}
//设置按钮点击事件
- (void)setAction:(UIButton *)button{
    
    SheZhiViewController *shezhiVC = [[SheZhiViewController alloc] init];
    [self.navigationController pushViewController:shezhiVC  animated:YES];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
    //    KHweizhiViewController *shezhiVC = [[KHweizhiViewController alloc] init];
    //    [self.navigationController pushViewController:shezhiVC  animated:YES];
    //    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
}
#pragma mark ----------------------------collectionView-------------------------------
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf7f9fa);
        _collectionView.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64 - 49);
        CGFloat wd = (KscreenWidth - 4)/3;
        CGFloat hgt = (KscreenWidth - 4)/3;
        //设置宽高
        layout.itemSize = CGSizeMake(wd, hgt);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectionView.showsVerticalScrollIndicator = NO;
        //注册
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:MainCollectionViewCellID];
        
        [_collectionView registerClass:[MainCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MainCollectionHeadViewID];
        [_collectionView registerClass:[HeadTitleCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadTitleCollectionViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (NSArray *)mainNameSuoXieGather:(NSInteger)intager{
    NSMutableArray *myarr = [[NSMutableArray alloc]init];
    //办公
    NSArray *banGArr;
    switch (intager) {
        case 1:
            banGArr = @[@"ddgl",@"thgl",@"zkgl",@"kccx",@"bbtj",@"cpll"];
            break;
        case 2:
            banGArr = @[@"cgxxgl",@"cgkcgl",@"cgwlgl"];
            break;
        case 3:
            banGArr = @[@"scgl",@"scckgl",@"scllgl"];
            break;
        case 4:
            banGArr = @[@"zxkfgl",@"shfwgl"];
            break;
        case 5:
            banGArr = @[@"ggll",@"xwll",@"spll"];
            break;
        case 6:
            banGArr = @[@"rzsb",@"kqgl",@"zdysp",@"pzsc",@"zykgl",@"fysq",@"fybx"];//
            break;
        case 7:
            banGArr = @[@"khgl",@"khgz",@"khwz"];
            break;
        default:
            break;
    }
    for (NSString *str in _HttpArray) {
        if ([banGArr containsObject:str]) {
            [myarr addObject:str];
        }
    }
    return myarr;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if ([[self mainNameSuoXieGather:section] count]%3) {
        return [[self mainNameSuoXieGather:section] count]/3*3+3;
    }
    return [[self mainNameSuoXieGather:section] count]/3*3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainCollectionViewCellID forIndexPath:indexPath];
    if ([[self mainNameSuoXieGather:indexPath.section] count]>indexPath.row) {
        NSString *suoxie = [self mainNameSuoXieGather:indexPath.section][indexPath.row];
        cell.cv_icomImageView.image = [UIImage imageNamed:[_namePhotoDic objectForKey:suoxie]];
        cell.bt_titleLabel.text = [_namePhotoDic objectForKey:suoxie];
    }else{
        cell.cv_icomImageView.image = [UIImage imageNamed:@"zhuye_back.png"];
        cell.bt_titleLabel.text = @"";
        
    }
    
    gridcell = cell;
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            MainCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MainCollectionHeadViewID forIndexPath:indexPath];
            reusableview = headerView;
        }else{
            NSArray *titleArr = @[@"",@"供应链",@"采购管理",@"生产管理",@"售后管理",@"资讯浏览",@"OA办公",@"客户关系(CRM)"];

            HeadTitleCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadTitleCollectionViewID forIndexPath:indexPath];
            headerView.titleHead.text = titleArr[indexPath.section];
            reusableview = headerView;
            NSLog(@"%ld",[self mainNameSuoXieGather:indexPath.section].count);
            if ([self mainNameSuoXieGather:indexPath.section].count == 0) {
                reusableview.hidden = YES;
            }else{
                reusableview.hidden = NO;
            }
        }
        
    }
    

    return reusableview;
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(KscreenWidth, 180*MYWIDTH); //图片滚动的宽高
    }else{
        if ([self mainNameSuoXieGather:section].count == 0) {
            return CGSizeZero;
        }
        return CGSizeMake(KscreenWidth, 45);  //适合的宽高
    }
    return CGSizeZero;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *suoxie;
    if ([[self mainNameSuoXieGather:indexPath.section] count]>indexPath.row) {
        suoxie = [self mainNameSuoXieGather:indexPath.section][indexPath.row];
    }
    // 1
    if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"考勤管理"]) {
        KaoQinViewController *kaoqinguanliVC = [[KaoQinViewController alloc]init];
        [self.navigationController pushViewController:kaoqinguanliVC animated:YES];
        // 2
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"客户管理"]){
        KeHuViewController *kehuVC = [[KeHuViewController alloc] init];
        [self.navigationController pushViewController:kehuVC animated:YES];
        // 3
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"客户拜访"]){
        KeHuBFViewController *kehuBFVC = [[KeHuBFViewController alloc] init];
        [self.navigationController pushViewController:kehuBFVC animated:YES];
        // 4
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"销售账务"]){
        ZhangKuanViewController *zhangwuVC = [[ZhangKuanViewController alloc] init];
        [self.navigationController pushViewController:zhangwuVC animated:YES];
        // 5
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"财务信息"]){
        ChaiWuXinXiViewController *caiwuVC = [[ChaiWuXinXiViewController alloc] init];
        [self.navigationController pushViewController:caiwuVC animated:YES];
        // 5
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"订单管理"]){
        DingDanViewController *dingdanVC = [[DingDanViewController alloc] init];
        [self.navigationController pushViewController:dingdanVC animated:YES];
        // 6
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"拍照上传"]){
        HuoDongLeiBiaoVC *paizhaoVC = [[HuoDongLeiBiaoVC alloc] init];
        [self.navigationController pushViewController:paizhaoVC animated:YES];
        // 7
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"退货管理"]){
        TuiHuoViewController *tuihuoVC = [[TuiHuoViewController alloc] init];
        [self.navigationController pushViewController:tuihuoVC animated:YES];
        // 8
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"新闻浏览"]){
        XinWenViewController *xinwenVC = [[XinWenViewController alloc] init];
        [self.navigationController pushViewController:xinwenVC animated:YES];
        // 9
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"视频浏览"]){
        VideoListVC *videoVC = [[VideoListVC alloc] init];
        [self.navigationController pushViewController:videoVC animated:YES];
        // 9
    }
    else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"日志上报"]){
        
        LXRizhiManagerVC *rizhiVC = [[LXRizhiManagerVC alloc] init];
        [self.navigationController pushViewController:rizhiVC animated:YES];
        // 10
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"论坛交流"]){
        LunTanViewController *luntanVC = [[LunTanViewController alloc] init];
        [self.navigationController pushViewController:luntanVC animated:YES];
        // 11
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"库存查询"]){
        KuCunViewController *kucunVC = [[KuCunViewController alloc] init];
        [self.navigationController pushViewController:kucunVC animated:YES];
        // 12
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"公告浏览"]){
        GongGaoViewController *gonggaoVC = [[GongGaoViewController alloc] init];
        [self.navigationController pushViewController:gonggaoVC animated:YES];
        // 13
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"报表统计"]){
        BaoBiaoTongJiViewController *baobiaoVC = [[BaoBiaoTongJiViewController alloc] init];
        [self.navigationController pushViewController:baobiaoVC animated:YES];
        
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"竞品管理"]){
        JingPinViewController *jingpingVC = [[JingPinViewController alloc] init];
        [self.navigationController pushViewController:jingpingVC animated:YES];
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"审批"]) {
        ZiDingYiSPViewController *zidingyiVC = [[ZiDingYiSPViewController alloc] init];
        [self.navigationController pushViewController:zidingyiVC animated:YES];
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"费用报销"]){
//        FeiYongBaoXiaoViewController *feiyongVC = [[FeiYongBaoXiaoViewController alloc] init];
//        [self.navigationController pushViewController:feiyongVC animated:YES];
        FYBaoXiaoListVC* vc = [[FYBaoXiaoListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"产品浏览"]){
        CPLiulanViewController *chanpinllVC = [[CPLiulanViewController alloc] init];
        [self.navigationController pushViewController:chanpinllVC animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"费用申请"]){
//        FeiYongShenQingViewController *FYSQVC = [[FeiYongShenQingViewController alloc] init];
//        [self.navigationController pushViewController:FYSQVC animated:YES];
        FYShenQingListVC* vc = [[FYShenQingListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"售后服务"]){
        CustomerServiceVC *SHFWVC = [[CustomerServiceVC alloc] init];
        [self.navigationController pushViewController:SHFWVC animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"在线客服"]){
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
        NSString* name = [[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
        NSDictionary* clientCustomizedAttrs = @{
                                                @"name"        : name
                                                };
        [chatViewManager setClientInfo:clientCustomizedAttrs ];
        [chatViewManager pushMQChatViewControllerInViewController:self];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"资源库"]){
        ZiYuanKuViewController *ZYKVC = [[ZiYuanKuViewController alloc] init];
        [self.navigationController pushViewController:ZYKVC animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"客户位置"]){
        KHweizhiViewController *KHWZ = [[KHweizhiViewController alloc] init];
        [self.navigationController pushViewController:KHWZ animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"采购管理"]){
        CgInformationManageVC *KHWZ = [[CgInformationManageVC alloc] init];
        [self.navigationController pushViewController:KHWZ animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"库存管理"]){
        CaiGouKuCunManagerVC *KHWZ = [[CaiGouKuCunManagerVC alloc] init];
        [self.navigationController pushViewController:KHWZ animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"物料管理"]){
        WLXXViewController *KHWZ = [[WLXXViewController alloc] init];
        [self.navigationController pushViewController:KHWZ animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"生产计划管理"]){
        ProductPlanViewController* vc = [[ProductPlanViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"生产出库管理"]){
        ProductStoreViewController* vc = [[ProductStoreViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[_namePhotoDic objectForKey:suoxie] isEqualToString:@"生产领料管理"]){
        ProductMaterialViewController* vc = [[ProductMaterialViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"yes" userInfo:nil];
}


#pragma mark - 登录后定位首次上传位置

- (void)locate
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //上传经纬度获取
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [self updateLocate];
    [_locService stopUserLocationService];
    [self outputAdd];
}

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (void)outputAdd
{
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake([self.lblLatitude floatValue], [self.lblLongitude floatValue]);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
        //位置信息
        NSLog(@"显示位置:%@",result.address);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:result.address forKey:@"LocAdress"];
        [userDefault synchronize];
    }else{
        NSLog(@"找不到相对应的位置信息");
        
    }
}



- (void)updateLocate{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefault objectForKey:@"account"];
    NSString *imei = [userDefault objectForKey:@"imei"];
    [_locService startUserLocationService];
    //    self.lblLongitude = @"0.00";
    //    self.lblLatitude = @"0.00";
    
    double lon = [self.lblLongitude doubleValue];
    double la = [self.lblLatitude doubleValue];
    if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
        
        NSLog(@"位置信息异常!");
    }else{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location"];
        NSDictionary *params = @{@"mobile":@"true",@"action":@"setSalerLoction",@"data":[NSString stringWithFormat:@"{\"longitude\":\"%@\",\"latitude\":\"%@\",\"account\":\"%@\",\"imei\":\"%@\"}",self.lblLongitude,self.lblLatitude,account,imei]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"登录首次上传位置=%@",str);
            
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"位置信息上传失败");
        }];
    }
    
    
}


#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     京新           applejingxin
     易软通         appleyiruantong
     华抗           applehuakang
     济南智圣医疗    applejnzsyl
     圣地宝         applesdb
     康普善         applekps
     金易销         applejyx
     中抗           applezk
     */
    NSString *project;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    
    if ([appName isEqualToString:@"徒河食品"]) {
        project = @"appletuheshipin";
    }
    if ([appName isEqualToString:@"华抗药业"]) {
        project = @"applehuakang";
    }
    if ([appName isEqualToString:@"京新药业"]) {
        project = @"applejingxin";
    }
    if ([appName isEqualToString:@"中抗药业"]) {
        project = @"applezk";
    }
    if ([appName isEqualToString:@"联祥网络"]) {
        project = @"applelianxiang";
    }
    if ([appName isEqualToString:@"金易销"]) {
        project = @"applejyx";
    }
    //http://182.92.96.58
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version?action=getVersionInfo&project=applejingxin",Ver_Address];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applejingxin"]};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        // NSLog(@"版本信息:%@",dic);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSLog(@"当前版本号%@",appVersion);
        NSString *version = dic[@"app_version"];
        NSString *nessary = dic[@"app_necessary"];
        _versionUrl = dic[@"app_url"];
        //[self showAlert];
        if ([version isEqualToString:appVersion]) {
            
        }else if(![version isEqualToString:appVersion]){
            if ([nessary isEqualToString:@"0"]) {
                
                [self showAlert];
            }else if([nessary isEqualToString:@"1"]){
                
                [self showAlert1];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"更新检测请求失败");
    }];
    
}
//选择更新
- (void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:_msg
                                                   delegate:self
                                          cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10001;
    [alert show];
    
}
//强制更新
- (void)showAlert1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:_msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10002;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (alertView.tag==10001) {
        
        if (buttonIndex==1) {
            NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }else if (alertView.tag == 10002){
        
        if (buttonIndex == 0) {
            
            NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
}
- (void)msgRequest{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"PhoneSearch"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dic = arr[0];
        _msg = dic[@"editnote"];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
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
@end

