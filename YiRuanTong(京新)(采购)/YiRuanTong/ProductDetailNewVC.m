//
//  ProductDetailNewVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProductDetailNewVC.h"
#import "UIViewExt.h"
#import "ProgressingCell.h"
#import "DataPost.h"
#import "ProFinishModel.h"
#import "KHnameModel.h"
#import "piciModel.h"

@interface ProductDetailNewVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tbView;
@property (nonatomic,strong)UITableView * cangkutableView;
@property (nonatomic,strong)UITableView * picitableView;
@property (nonatomic,strong)NSMutableArray * resultData;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * piciArr;
@property (nonatomic,strong)UITextField * custField;

@end

@implementation ProductDetailNewVC

{
    UIView* _headerView;
    UIButton* _hide_keHuPopViewBut;
    MBProgressHUD *_Hud;
    NSInteger _page1;
    NSString * _cangkuid;
    NSString * _ckid;
    NSIndexPath *_indexPathNew;
    NSMutableIndexSet *_indexSetToDel;//NSIndexSet表示（数组的）下标集合， NSMutableIndexSet是其可变版，这里用indexSetToDel
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生产领料详情";
    self.navigationItem.rightBarButtonItem = nil;
    _resultData = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    _piciArr = [[NSMutableArray alloc]init];
    _page1 = 1;
    _indexPathNew = [[NSIndexPath alloc]init];
    _indexSetToDel = [[NSMutableIndexSet alloc]init];
    [self initScrollView];
    [self requestIsSpstatus];
}
- (void)initScrollView {
    self.dingDanScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    self.dingDanScrollView.showsVerticalScrollIndicator = NO;
    self.dingDanScrollView.bounces = NO;
    self.dingDanScrollView.backgroundColor =COLOR(229, 228, 239, 1);
    self.dingDanScrollView.delegate =self;
    [self.view addSubview:self.dingDanScrollView];
    [self creatUI];
}
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing linecolor:(UIColor *)linecolor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:linecolor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
- (void)creatUI{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KscreenWidth, 45*7+10)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.dingDanScrollView addSubview:_headerView];
    NSArray* titleArray = @[@"BOM单号",@"生产计划单号",@"产品名称",@"规格",@"数量",@"单位",@"备注"];
    NSString* bomNo = [NSString stringWithFormat:@"%@",_model.bomno];
    NSString* planNo = [NSString stringWithFormat:@"%@",_model.planno];
    NSString* proName = [NSString stringWithFormat:@"%@",_model.proname];
    NSString* prospe = [NSString stringWithFormat:@"%@",_model.specification];
    NSString* procount = [NSString stringWithFormat:@"%@",_model.plancount];
    NSString* danwei = [NSString stringWithFormat:@"%@",_model.mainunitname];
    NSString* note = [NSString stringWithFormat:@"%@",_model.note];
    
    NSArray* detailArray = @[bomNo,planNo,proName,prospe,procount,danwei,note];
    
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+45*i, 80, 44)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_headerView addSubview:titleLabel];
        UITextField* detailLabel = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, _headerView.width - titleLabel.width - 20, titleLabel.height)];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.tag = 100+i;
        if (i<detailArray.count) {
            detailLabel.text = detailArray[i];
        }
        if (detailLabel.tag != 106) {
            detailLabel.userInteractionEnabled = NO;
        }
        [_headerView addSubview:detailLabel];
        
        if (i == titleArray.count - 1) {
            titleLabel.textColor = UIColorFromRGB(0x3cbaff);
            detailLabel.textColor = UIColorFromRGB(0x3cbaff);
        }
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, KscreenWidth - 20, 0.5)];
        [self drawDashLine:line lineLength:1 lineSpacing:1 linecolor:COLOR(188, 188, 188, 1)];
        [_headerView addSubview:line];
        
    }
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerView.bottom, KscreenWidth, 1) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = NO;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.dingDanScrollView addSubview:_tbView];
    
}
-(void)bgupdateUI{
    
}
-(void)requestIsSpstatus{
    //调用一个接口判断该单子是否审批url：/pickinglist?action=isSpstatus  参数：bomno  如果返回的数据count等于0，加载物料信息的接口url为：/pickinglist?action=getDetailByMTid 参数：idEQ。否则：加载物料信息的接口url为：/pickinglist?action=getPartByMtId 参数：idEQ":"' '","bomnoEQ":"'   '","plancountEQ":"'  '"
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"isSpstatus",@"params":[NSString stringWithFormat:@"{\"bomno\":\"%@\"}",self.model.bomno]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * resultData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (resultData.count == 0) {
            [self dataCountIsEqual0Request];
        }else{
            [self dataCountIsNotEqual0Request];
        }
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
-(void)dataCountIsEqual0Request{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getDetailByMTid",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",self.model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in  arr) {
            ProFinishModel *model = [[ProFinishModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_resultData addObject:model];
        }
        [self initBottomView];
        [_tbView reloadData];
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
-(void)dataCountIsNotEqual0Request{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getPartByMtId",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"bomnoEQ\":\"%@\",\"plancountEQ\":\"%@\"}",self.model.Id,self.model.bomno,self.model.plancount]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in  arr) {
            ProFinishModel *model = [[ProFinishModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_resultData addObject:model];
        }
        [self initBottomView];
        [_tbView reloadData];
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView){
        return _resultData.count;
    }
    else if(tableView == self.cangkutableView){
        return _dataArr.count;
    }
    else if (tableView == self.picitableView){
        return _piciArr.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    if (tableView == _tbView) {
    //        return _dataArray.count;
    //    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        return 360;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 10;
    }
    return 0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPathNew = indexPath;
    
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    ProgressingCell* procell = [tableView dequeueReusableCellWithIdentifier:@"ProgressingCell"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"ProgressingCell" owner:self options:nil]firstObject];
    }
    [procell setCangkuBtnBlock:^{
        _indexPathNew = indexPath;
        [self showOrderNoTableView];
        NSLog(@"数据个数%zi",_dataArr.count);
        NSLog(@"11");
        if (_dataArr.count == 0) {
            NSLog(@"12");
            [self OrderNoDataRequest];
            [self.cangkutableView reloadData];
        }
        [_Hud removeFromSuperview];
    }];
    [procell setPiciBtnBlock:^{
        _indexPathNew = indexPath;
        [self showPiciTableView];
        NSLog(@"数据个数%zi",_dataArr.count);
        NSLog(@"11");
        if (_piciArr.count == 0) {
            NSLog(@"12");
            [self PiciDataRequest];
            [self.picitableView reloadData];
        }
        [_Hud removeFromSuperview];
    }];
    [procell setDelBtnBlock:^{
        //        _indexSetToDel
        _indexPathNew = indexPath;
        [_indexSetToDel removeIndex:indexPath.row];
        //        NSArray* array = _resultData;
        //        NSIndexPath* inx = indexPath;
        [_resultData removeObjectsAtIndexes:_indexSetToDel];
        //        [_resultData removeObjectAtIndex:_indexSetToDel];
        [_indexSetToDel removeAllIndexes];//清空集合
        [_tbView beginUpdates];
        [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tbView endUpdates];
        [self initBottomView];
    }];
    if (tableView == _tbView) {
        if (_resultData.count!=0) {
            procell.model = _resultData[indexPath.row];
            procell.count = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
            NSLog(@"procell.count%@",procell.count);
            procell.pici.userInteractionEnabled = NO;
        }
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        return procell;
    }
    else if (tableView == self.cangkutableView){
        KHnameModel *model = _dataArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        return cell;
        
    }
    else if (tableView == self.picitableView){
        piciModel *model = _piciArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        
        return cell;
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
    view.backgroundColor = [UIColor clearColor];
    UIButton * surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame =CGRectMake(30, 10, (KscreenWidth-90)/2, 40);
    [surebtn setTitle:@"确定" forState:UIControlStateNormal];
    surebtn.layer.cornerRadius = 5.f;
    surebtn.layer.masksToBounds = YES;
    [surebtn setBackgroundColor:[UIColor redColor]];
    [view addSubview:surebtn];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame =CGRectMake(30+(KscreenWidth-90)/2+30, 10, (KscreenWidth-90)/2, 40);
    cancelBtn.layer.cornerRadius = 5.f;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(addShitAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"添加" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor cyanColor]];
    [view addSubview:cancelBtn];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgressingCell *cell= [_tbView cellForRowAtIndexPath:_indexPathNew];
    
    [self.m_keHuPopView removeFromSuperview];
    if(tableView == self.cangkutableView) {
        KHnameModel *model = _dataArr[indexPath.row];
        [cell.cangku setTitle:model.name forState:UIControlStateNormal];
        _ckid = [NSString stringWithFormat:@"%@",model.Id];
        cell.pici.userInteractionEnabled = YES;
    }
    else if (tableView == self.picitableView){
        
        piciModel *model = _piciArr[indexPath.row];
        [cell.pici setTitle:model.name forState:UIControlStateNormal];
        cell.stockCount.text = [NSString stringWithFormat:@"%@",model.freecount];
        cell.needCount.text = [NSString stringWithFormat:@"%@",model.totalcount];
    }
}
-(void)addShitAction{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger row = _resultData.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    ProFinishModel *model = [[ProFinishModel alloc] init];
    [indexPaths addObject: indexPath];
    [_indexSetToDel addIndex:indexPath.row];
    //必须向tableView的数据源数组中相应的添加一条数据
    model.mtname = @"";
    model.mtsize = @"";
    model.mtunitname = @"";
    model.mtnormcount = @"";
    [_resultData addObject:model];
    [_tbView beginUpdates];
    [_tbView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [_tbView endUpdates];
    [self initBottomView];
}
- (void)closePop
{
    _page1 = 1;
    //    _page = 1;
    if ([self keyboardDid]) {
        
        [_custField resignFirstResponder];
        
    }else{
        
        
        [self.m_keHuPopView removeFromSuperview];
        //        [self.tableView removeFromSuperview];
    }
}
- (void)showOrderNoTableView{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
    _custField.borderStyle = UITextBorderStyleRoundedRect;
    _custField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, 40, 60, 40);
    
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(OrderNoDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.cangkutableView == nil) {
        self.cangkutableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.cangkutableView.backgroundColor = [UIColor whiteColor];
    }
    self.cangkutableView.dataSource = self;
    self.cangkutableView.delegate = self;
    self.cangkutableView.tag = 20;
    self.cangkutableView.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.cangkutableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.cangkutableView reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.cangkutableView animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)OrderNoDataRequest{
    ///pickinglist?action=getMTStock 参数：idEQ
    
    for (ProFinishModel *model in _resultData) {
        _cangkuid = [NSString stringWithFormat:@"%@",model.Id];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getMTStock",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",_cangkuid]};
    NSLog(@"%@",params);
    [_dataArr removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",dic);
            [_dataArr removeAllObjects];
            
            for (NSDictionary *dic in array) {
                KHnameModel *model = [[KHnameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            [self.cangkutableView reloadData];
            
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
        }
        
    }];
}
- (void)showPiciTableView{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
    _custField.borderStyle = UITextBorderStyleRoundedRect;
    _custField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, 40, 60, 40);
    
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(OrderNoDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.picitableView == nil) {
        self.picitableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.picitableView.backgroundColor = [UIColor whiteColor];
    }
    self.picitableView.dataSource = self;
    self.picitableView.delegate = self;
    self.picitableView.tag = 20;
    self.picitableView.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.picitableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.picitableView reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.picitableView animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)PiciDataRequest{
    ///pickinglist?action=getBatchOfMTinStock 参数：mtidEQ  ，storageidEQ
    
    //    for (ProFinishModel *model in _resultData) {
    //        _cangkuid = [NSString stringWithFormat:@"%@",model.Id];
    //    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getBatchOfMTinStock",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"mtidEQ\":\"%@\",\"storageidEQ\":\"%@\"}",_cangkuid,_ckid]};
    NSLog(@"%@",params);
    [_piciArr removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",dic);
            [_piciArr removeAllObjects];
            
            for (NSDictionary *dic in array) {
                piciModel *model = [[piciModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_piciArr addObject:model];
            }
            [self.picitableView reloadData];
            
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
        }
        
    }];
}
-(void)initBottomView{
    _tbView.frame = CGRectMake(0, _headerView.bottom, KscreenWidth, 360*_resultData.count+60);
    self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, _headerView.bottom+360*_resultData.count+60);
    //        [self bgupdateUI];
    
}



@end
