//
//  ProductingDetailVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProductingDetailVC.h"
#import "UIViewExt.h"
#import "ProgressingCell.h"
#import "DataPost.h"
#import "ProFinishModel.h"
#import "KHnameModel.h"
#import "piciModel.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface ProductingDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tbView;
@property (nonatomic,strong)UITableView * cangkutableView;
@property (nonatomic,strong)UITableView * picitableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * piciArr;
@property (nonatomic,strong)UITextField * custField;

@end

@implementation ProductingDetailVC
{
    UIView* _headerView;
    UIButton* _hide_keHuPopViewBut;
    MBProgressHUD *_Hud;
    NSInteger _page1;
    NSString * _cangkuid;
    NSString * _ckid;
    NSIndexPath *_indexPathNew;
    NSString *_producedate;
    NSString * _validtime;
    NSString * _needCont;
    NSString * _mtname;
    NSString * _singleprice;
    NSString * _mtnormcount;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生产领料详情";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArr = [[NSMutableArray alloc]init];
    _piciArr = [[NSMutableArray alloc]init];
    _page1 = 1;
    _indexPathNew = [[NSIndexPath alloc]init];
    [self initScrollView];

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
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerView.bottom, KscreenWidth, _resultArr.count*410+1) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = NO;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.dingDanScrollView addSubview:_tbView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView){
        return _resultArr.count;
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

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        return 410;
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
//        if (_dataArr.count == 0) {
            NSLog(@"12");
            ProFinishModel *resmodel = _resultArr[_indexPathNew.row];
            _cangkuid = [NSString stringWithFormat:@"%@",resmodel.Id];
            [self OrderNoDataRequest];
            [self.cangkutableView reloadData];
//        }
        [_Hud removeFromSuperview];
    }];
    [procell setPiciBtnBlock:^{
        _indexPathNew = indexPath;
        [self showPiciTableView];
        NSLog(@"数据个数%zi",_dataArr.count);
        NSLog(@"11");
//        if (_piciArr.count == 0) {
            NSLog(@"12");
            [self PiciDataRequest];
            [self.picitableView reloadData];
//        }
        [_Hud removeFromSuperview];
    }];
//    [procell setDelBtnBlock:^{
//
//        _indexPathNew = indexPath;
//        [_resultArr removeObjectAtIndex:indexPath.row];
//        [_tbView beginUpdates];
//        [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [_tbView endUpdates];
//        [self initBottomView];
//    }];
    if (tableView == _tbView) {
            _indexPathNew = indexPath;
        if (_resultArr.count!=0) {
            procell.model = _resultArr[indexPath.row];
            procell.count = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
            NSLog(@"procell.count%@",procell.count);
            ProFinishModel *resmodel = _resultArr[indexPath.row];
            _needCont = [NSString stringWithFormat:@"%ld",[_model.plancount integerValue]* [resmodel.mtcount integerValue]];
            procell.pici.userInteractionEnabled = NO;
            procell.stockCount.userInteractionEnabled = NO;
            procell.keyongCount.userInteractionEnabled = NO;
            procell.delBtn.userInteractionEnabled = NO;
            procell.needCount.text = [NSString stringWithFormat:@"%@",_needCont];
            [self initBottomView];
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
    if (tableView == _tbView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
        view.backgroundColor = [UIColor clearColor];
        UIButton * surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        surebtn.frame =CGRectMake(30, 10, (KscreenWidth-90)/2, 40);
        [surebtn setTitle:@"确定" forState:UIControlStateNormal];
        [surebtn addTarget:self action:@selector(addOrderAction) forControlEvents:UIControlEventTouchUpInside];
        surebtn.layer.cornerRadius = 5.f;
        surebtn.layer.masksToBounds = YES;
        [surebtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
        [view addSubview:surebtn];
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame =CGRectMake(30+(KscreenWidth-90)/2+30, 10, (KscreenWidth-90)/2, 40);
        cancelBtn.layer.cornerRadius = 5.f;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
        [view addSubview:cancelBtn];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        return view;
    }
    
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
        cell.stockCount.text = [NSString stringWithFormat:@"%@",model.totalcount];
        cell.keyongCount.text = [NSString stringWithFormat:@"%@",model.freecount];
        _producedate = [NSString stringWithFormat:@"%@",model.producedate];
        _validtime = [NSString stringWithFormat:@"%@",model.validtime];
        _singleprice = [NSString stringWithFormat:@"%@",model.singleprice];
        
    }
}

- (void)closePop
{
    _page1 = 1;

    if ([self keyboardDid]) {
        
        [_custField resignFirstResponder];
        
    }else{
        
        
        [self.m_keHuPopView removeFromSuperview];

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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getBatchOfMTinStock",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"mtidEQ\":\"%@\",\"storageidEQ\":\"%@\",\"nameLike\":\"\"}",_cangkuid,_ckid]};
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
    _tbView.frame = CGRectMake(0, _headerView.bottom, KscreenWidth, 410*_resultArr.count+60);
    self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, _headerView.bottom+410*_resultArr.count+60);
    //        [self bgupdateUI];
    
}
-(void)addOrderAction{
    //tp://192.168.1.199:8080/jingxin/servlet/pickinglist?action=addStockOut
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString* bomno = [NSString stringWithFormat:@"%@",_model.bomno];
    NSString* planNo = [NSString stringWithFormat:@"%@",_model.planno];
    NSString* proName = [NSString stringWithFormat:@"%@",_model.proname];
    NSString* proid = [NSString stringWithFormat:@"%@",_model.proid];
    NSString* prospe = [NSString stringWithFormat:@"%@",_model.specification];
    NSString* procount = [NSString stringWithFormat:@"%@",_model.plancount];
    NSString* danwei = [NSString stringWithFormat:@"%@",_model.mainunitname];
    NSString* note = [NSString stringWithFormat:@"%@",_model.note];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"action=addStockOut&table=scck&data={\"table\":\"scck\",\"bomno\":\"%@\",\"planno\":\"%@\",\"proname\":\"%@\",\"proid\":\"%@\",\"specification\":\"%@\",\"plancount\":\"%@\",\"mainunitname\":\"%@\",\"note\":\"%@\"}",bomno,planNo,proName,proid,prospe,procount,danwei,note];
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"scckList\":[]"];
    
    for (int i = 0; i < _resultArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ProgressingCell *cell = [_tbView cellForRowAtIndexPath:indexPath];
        ProFinishModel *model = _resultArr[i];
        NSString * mtid = [NSString stringWithFormat:@"%@",model.Id];//model.mtid;
        NSString *producedate = _producedate;
        NSString * validtime = _validtime;
        NSString *mtname = model.name;
        NSString *mtsize = model.mtsize;
        NSString *mtunitname = model.mtunitname;
        NSString *mtunitid = model.mtunitid;
        NSString *singleprice = _singleprice;
        NSString *mtnormcount = model.mtcount;
        NSString *storagename = cell.cangku.titleLabel.text;
        NSString *storageid = _ckid;
        NSString *mtbatch = cell.pici.titleLabel.text;
        NSString *mtstockcount = [NSString stringWithFormat:@"%@",cell.stockCount.text];
        NSString *mtfreecount = cell.keyongCount.text;
        NSString *mtneedcount = cell.needCount.text;
        [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"scckmx\",\"mtid\":\"%@\",\"producedate\":\"%@\",\"validtime\":\"%@\",\"mtname\":\"%@\",\"mtsize\":\"%@\",\"mtunitname\":\"%@\",\"mtunitid\":\"%@\",\"singleprice\":\"%@\",\"mtnormcount\":\"%@\",\"storagename\":\"%@\",\"storageid\":\"%@\",\"mtbatch\":\"%@\",\"mtstockcount\":\"%@\",\"mtfreecount\":\"%@\",\"mtneedcount\":\"%@\"},",mtid,producedate,validtime,mtname,mtsize,mtunitname,mtunitid,singleprice,mtnormcount,storagename,storageid,mtbatch,mtstockcount,mtfreecount,mtneedcount] atIndex:chanpinStr.length - 1];
        if ([cell.cangku.titleLabel.text isEqualToString:@"仓库"]) {
             [self showAlert:@"请选择仓库"];
            return;
        }
        if ([cell.pici.titleLabel.text isEqualToString:@"批次"]) {
            [self showAlert:@"请选择批次"];
            return;
        }
        if (IsEmptyValue(mtneedcount)) {
            [self showAlert:@"需求数量不能为空"];
            return;
        }
        if ([mtneedcount integerValue]>[mtfreecount integerValue]) {
            [self showAlert:@"需求数量不能大于库存数量"];
            return;
        }
    }
    NSUInteger length = chanpinStr.length;
    [chanpinStr deleteCharactersInRange:NSMakeRange(length-2, 1)];
    [str insertString:[NSString stringWithFormat:@",%@",chanpinStr] atIndex:str.length-1];
    NSLog(@"添加订单字符串:%@",str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"添加订单返回信息:%@",str1);
    
    NSRange range = {1,str1.length-2};
    if (str1.length != 0) {
        NSString *reallystr = [str1 substringWithRange:range];
        if ([reallystr isEqualToString:@"true"]) {
            
            [self showAlert:@"添加订单成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newprofinish" object:self];
        } else {
            
            [self showAlert:[NSString stringWithFormat:@"添加订单失败,%@",str1]];
            
        }
    }
}
-(void)cancleAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
