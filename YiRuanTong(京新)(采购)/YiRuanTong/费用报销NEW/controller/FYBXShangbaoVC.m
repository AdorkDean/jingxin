//
//  FYBXShangbaoVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "FYBXShangbaoVC.h"
#import "UIViewExt.h"
#import "FYBaoXiaoDetailCell.h"
#import "DataPost.h"
#import "CommonModel.h"
#import "FYBXDetailModel.h"
#import "LXUploadPhotoCell.h"
#import "MKMessagePhotoView.h"
#define lineColor COLOR(240, 240, 240, 1);

@interface FYBXShangbaoVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MKMessagePhotoViewDelegate>
@property (nonatomic,strong)UITableView * tbView;
@property (nonatomic,strong)UITableView * cangkutableView;
@property (nonatomic,strong)NSMutableArray * typeArray;
@property (nonatomic,strong)UITextField * custField;
@property (nonatomic,strong)MKMessagePhotoView* photosView;
@end

@implementation FYBXShangbaoVC

{
    UIButton* _hide_keHuPopViewBut;
    MBProgressHUD *_Hud;
    NSIndexPath *_indexPathNew;
    NSString* _typeid;
    NSInteger _imageInteger;
    MBProgressHUD* _hud;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"费用上报";
    self.navigationItem.rightBarButtonItem = nil;
    _resultArr = [[NSMutableArray alloc]init];
    _typeArray = [[NSMutableArray alloc]init];
    _indexPathNew = [[NSIndexPath alloc]init];
    _imageInteger = 0;
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setTitle:@"上报" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(addbaoxiao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
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
    [self addOrderAction];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = YES;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KscreenWidth, 45*5+10)];
    view.backgroundColor = [UIColor whiteColor];
    NSArray* titleArray = @[@"上报人",@"发票合计",@"金额合计",@"实际报销金额",@"备注"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSArray* detailArray = @[name,@"",@"",@"",@""];
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+45*i, 80, 44)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:titleLabel];
        UITextField* detailLabel = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, view.width - titleLabel.width - 20, titleLabel.height)];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.tag = 100+i;
        if (i<detailArray.count) {
            detailLabel.text = detailArray[i];
        }
        detailLabel.userInteractionEnabled = NO;
        [view addSubview:detailLabel];
        
        if (i == titleArray.count - 1) {
            titleLabel.textColor = UIColorFromRGB(0x3cbaff);
            detailLabel.textColor = UIColorFromRGB(0x3cbaff);
        }
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, KscreenWidth - 20, 0.5)];
        [self drawDashLine:line lineLength:1 lineSpacing:1 linecolor:COLOR(188, 188, 188, 1)];
        [view addSubview:line];
    }
        _tbView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
    view1.backgroundColor = [UIColor clearColor];
    UIButton * surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame =CGRectMake(KscreenWidth - 90, 10, 70, 40);
    [surebtn setTitle:@"继续添加" forState:UIControlStateNormal];
    surebtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [surebtn addTarget:self action:@selector(addOrderAction) forControlEvents:UIControlEventTouchUpInside];
    surebtn.layer.cornerRadius = 5.f;
    surebtn.layer.masksToBounds = YES;
    [surebtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [view1 addSubview:surebtn];
//    _tbView.tableFooterView = view1;
    
}
//给headerView赋值

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView){
        if (section == 0) {
            return _resultArr.count;
        }else if(section == 1){
           return 1;
        }
    }
    else if(tableView == self.cangkutableView){
        return _typeArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tbView) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (indexPath.section == 0) {
            return 200;
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                if (self.photosView){
                    return 100;
                }
            }
            return 40;
        }
    }
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tbView) {
//        if (section == 0) {
//            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KscreenWidth, 45*5+10)];
//            view.backgroundColor = [UIColor whiteColor];
//            NSArray* titleArray = @[@"上报人",@"发票合计",@"金额合计",@"实际报销金额",@"备注"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            NSString *name = [userDefaults objectForKey:@"name"];
//            NSArray* detailArray = @[name,@"",@"",@"",@""];
//            for (int i = 0; i < titleArray.count; i ++) {
//                UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+45*i, 80, 44)];
//                titleLabel.text = titleArray[i];
//                titleLabel.font = [UIFont systemFontOfSize:12];
//                [view addSubview:titleLabel];
//                UITextField* detailLabel = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, view.width - titleLabel.width - 20, titleLabel.height)];
//                detailLabel.textColor = [UIColor grayColor];
//                detailLabel.textAlignment = NSTextAlignmentRight;
//                detailLabel.font = [UIFont systemFontOfSize:12];
//                detailLabel.tag = 100+i;
//                if (i<detailArray.count) {
//                    detailLabel.text = detailArray[i];
//                }
//                detailLabel.userInteractionEnabled = NO;
//                [view addSubview:detailLabel];
//
//                if (i == titleArray.count - 1) {
//                    titleLabel.textColor = UIColorFromRGB(0x3cbaff);
//                    detailLabel.textColor = UIColorFromRGB(0x3cbaff);
//                }
//
//                UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, KscreenWidth - 20, 0.5)];
//                [self drawDashLine:line lineLength:1 lineSpacing:1 linecolor:COLOR(188, 188, 188, 1)];
//                [view addSubview:line];
//
//            }
//            return view;
//        }

    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
//        if (section == 0) {
//            return 45*5+10;
//        }
        if (section == 1) {
            return 5;
        }
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
    
    FYBaoXiaoDetailCell* procell = [tableView dequeueReusableCellWithIdentifier:@"FYBaoXiaoDetailCellID"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"FYBaoXiaoDetailCell" owner:self options:nil]firstObject];
    }
    //点击了删除
    [procell setDelBtnBlock:^{
        _indexPathNew = indexPath;
        [_resultArr removeObjectAtIndex:indexPath.row];
        //点击了详情中的发票数量
        NSInteger count = 0;
        for (FYBXDetailModel* model in _resultArr) {
            count = [model.singelnum integerValue]+count;
        }
        UITextField* field = (UITextField*)[self.view viewWithTag:101];
        field.text = [NSString stringWithFormat:@"%li",(long)count];
        //点击了详情中的报销金额
        CGFloat price = 0;
        for (FYBXDetailModel* model in _resultArr) {
            price = [model.applymon floatValue]+price;
        }
        UITextField* field1 = (UITextField*)[self.view viewWithTag:102];
        field1.text = [NSString stringWithFormat:@"%.2f",price];
        UITextField* shijiField = (UITextField*)[self.view viewWithTag:103];
        shijiField.text = [NSString stringWithFormat:@"%.2f",price];
        [_tbView reloadData];
        [self initBottomView];
    }];
    [procell setTypeBtnBlock:^{
        _indexPathNew = indexPath;
        [self showOrderNoTableView];
    }];
    
    if (tableView == _tbView) {
        if (indexPath.section == 0) {
            _indexPathNew = indexPath;
            procell.countField.tag = indexPath.row+11000;
            procell.countField.delegate = self;
            procell.priceField.tag = indexPath.row+12000;
            procell.priceField.delegate = self;
            procell.countField.keyboardType = UIKeyboardTypeNumberPad;
            procell.priceField.keyboardType = UIKeyboardTypeNumberPad;
            if (_resultArr.count!=0) {
                procell.model = _resultArr[indexPath.row];
                [self initBottomView];
            }
            procell.selectionStyle = UITableViewCellSelectionStyleNone;
            return procell;
        }else if(indexPath.section == 1){
            static NSString *cellID =@"LXUploadPhotoCell";
            LXUploadPhotoCell *photocell =[tableView dequeueReusableCellWithIdentifier:cellID];
            if (photocell ==nil)
            {
                photocell =(LXUploadPhotoCell*)[[[NSBundle mainBundle]loadNibNamed:@"LXUploadPhotoCell" owner:self options:nil]firstObject];
            }
            __weak typeof(photocell) weakCell = photocell;
            [photocell setSelectPhotoBlock:^{
                if (!self.photosView)
                {
                    //设置图片展示区域
                    self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(10*MYWIDTH,40,UIScreenW-20*MYWIDTH, 60)];
                    //self.photosView.backgroundColor = [UIColor redColor];
                    [weakCell addSubview:self.photosView];
                    self.photosView.backgroundColor = [UIColor whiteColor];
                    self.photosView.delegate = self;
                    self.photosView.ViewController = self;
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    [_tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                
                [self.photosView clickAddPhotos:nil];
            }];
            [photocell addSubview:self.photosView];
            photocell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return photocell;
        }
    }
    else if (tableView == self.cangkutableView){
        CommonModel *model = _typeArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        return cell;
        
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _tbView) {
        if (section == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
            view.backgroundColor = [UIColor clearColor];
            UIButton * surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            surebtn.frame =CGRectMake(KscreenWidth - 90, 10, 70, 40);
            [surebtn setTitle:@"继续添加" forState:UIControlStateNormal];
            surebtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [surebtn addTarget:self action:@selector(addOrderAction) forControlEvents:UIControlEventTouchUpInside];
            surebtn.layer.cornerRadius = 5.f;
            surebtn.layer.masksToBounds = YES;
            [surebtn setBackgroundColor:UIColorFromRGB(0x3cbaff)];
            [view addSubview:surebtn];
            return view;
        }

    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _tbView) {
        if (section == 0) {
            return 60;
        }
        if (section == 1) {
            return 5;
        }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYBaoXiaoDetailCell *cell= [_tbView cellForRowAtIndexPath:_indexPathNew];
    
    [self.m_keHuPopView removeFromSuperview];
    if(tableView == self.cangkutableView) {
        
        CommonModel *model = _typeArray[indexPath.row];
        [cell.typeBtn setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
        _typeid = [NSString stringWithFormat:@"%@",model.Id];
        FYBXDetailModel* cellmodel = _resultArr[_indexPathNew.row];
        cellmodel.costtype = [NSString stringWithFormat:@"%@",model.name];
        cellmodel.costtypeid = [NSString stringWithFormat:@"%@",_typeid];
    }
}


- (void)closePop
{
    
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
    [self OrderNoDataRequest];
}
-(void)OrderNoDataRequest{
    ///pickinglist?action=getMTStock 参数：idEQ
    _Hud = [MBProgressHUD showHUDAddedTo:self.cangkutableView animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase?action=getSelectType&type=costtype"];
    [DataPost  requestAFWithUrl:urlStr params:nil finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            [_typeArray removeAllObjects];
            
            for (NSDictionary *dic in array) {
                CommonModel *model = [[CommonModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_typeArray addObject:model];
            }
            [self.cangkutableView reloadData];
            
        }
        [_Hud hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
        }
        [_Hud hide:YES];
    }];
}

-(void)initBottomView{
//    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, _resultArr.count*200+1+44+(45*5+10)) style:UITableViewStylePlain];
}
-(void)addOrderAction{
    FYBXDetailModel* model = [[FYBXDetailModel alloc]init];
    model.costtype = @"";
    model.costcause = @"";
    model.singelnum = @"";
    model.applymon = @"";
    [_resultArr addObject:model];
    [_tbView reloadData];
    [self initBottomView];
}
-(void)cancleAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag>=11000&&textField.tag<12000) {
        FYBXDetailModel* model = _resultArr[textField.tag - 11000];
        model.singelnum = [NSString stringWithFormat:@"%@",textField.text];
        //点击了详情中的发票数量
        NSInteger count = 0;
        for (FYBXDetailModel* model in _resultArr) {
            count = [model.singelnum integerValue]+count;
        }
        UITextField* field = (UITextField*)[self.view viewWithTag:101];
        field.text = [NSString stringWithFormat:@"%li",(long)count];
    }
    if (textField.tag>=12000) {
        FYBXDetailModel* model = _resultArr[textField.tag - 12000];
        model.applymon = [NSString stringWithFormat:@"%@",textField.text];
        //点击了详情中的报销金额
        CGFloat price = 0;
        for (FYBXDetailModel* model in _resultArr) {
            price = [model.applymon floatValue]+price;
        }
        UITextField* field = (UITextField*)[self.view viewWithTag:102];
        field.text = [NSString stringWithFormat:@"%.2f",price];
        UITextField* shijiField = (UITextField*)[self.view viewWithTag:103];
        shijiField.text = [NSString stringWithFormat:@"%.2f",price];
    }
}

- (void)addbaoxiao
{
    if ( _resultArr.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加费用详情!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
         NSInteger totalcount = 0;
        for (FYBXDetailModel* model in _resultArr) {
            NSString* type = [NSString stringWithFormat:@"%@",model.costtype];
            NSString* money = [NSString stringWithFormat:@"%@",model.applymon];
            NSString* count = [NSString stringWithFormat:@"%@",model.singelnum];
            if (type.length == 0 || count.length == 0 || money.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"类型、数量、金额能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                totalcount = totalcount+1;
            }
        }
        if (totalcount == _resultArr.count&&!IsEmptyValue(_resultArr)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否添加此申请?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1001;
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            [self shangBao];
        }
        
    }
    
}

- (void)shangBao{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=addReim&table=fybx&SP=true"];
    NSURL *url =[NSURL URLWithString:urlStr];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    UITextField *shangaboren = [self.view viewWithTag:100];
    UITextField *fapiaoheji = [self.view viewWithTag:101];
    UITextField *jineheji = [self.view viewWithTag:102];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *IDStr = [userDefault objectForKey:@"id"];
    NSMutableString *cpStr = [NSMutableString stringWithFormat:@"data={\"applyerid\":\"%@\",\"applyer\":\"%@\",\"totalnum\":\"%@\",\"applymoney\":\"%@\",\"refundids\":\"\",\"refundmoney\":0,\"table\":\"fybx\",\"note\":\"\",}",IDStr,shangaboren.text,fapiaoheji.text,jineheji.text];

    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"fybxmxList\":[]"];

    for (int i = 0; i < _resultArr.count; i++) {
        FYBXDetailModel* model = _resultArr[i];
        model.costtype = [self convertNull:model.costtype];
        model.costtypeid = [self convertNull:model.costtypeid];
        model.applymon = [self convertNull:model.applymon];
        model.singelnum = [self convertNull:model.singelnum];
        model.costcause = [self convertNull:model.costcause];
        [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"cost_reimbursement_apply_detail\",\"costtypeid\":\"%@\",\"costtype\":\"%@\",\"singelnum\":\"%@\",\"applyMon\":\"%@\",\"costcause\":\"%@\"},",model.costtypeid,model.costtype,model.singelnum,model.applymon,model.costcause] atIndex:chanpinStr.length - 1];
    }

    [chanpinStr deleteCharactersInRange:NSMakeRange(chanpinStr.length - 2, 1)];

    [cpStr insertString:[NSString stringWithFormat:@"%@",chanpinStr] atIndex:cpStr.length-1];

    NSLog(@"添加费用字符串:%@",cpStr);

    NSData *data = [cpStr dataUsingEncoding:NSUTF8StringEncoding];

    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"添加费用返回字符串:%@",str1);
    if (str1.length != 0) {
        NSRange range = {1,str1.length-2};
        NSString *reallystr = [str1 substringWithRange:range];
        
        if ([self isNum:reallystr]) {
                if (_imageInteger != 0) {
                NSDictionary * dic =@{@"reallystr":reallystr};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"upImageWithDatabaoxiao" object:self userInfo:dic];
                }else{
                    [self showAlert:@"添加成功!"];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newCostapply" object:self];
        } else {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"添加失败";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            [_hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_hud removeFromSuperview];
            }];
        }
    }

}
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}



//实现代理方法，相册
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

//相机📷
-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}
- (void)upDataUIImageArr:(NSInteger)integer{
    _imageInteger = integer;
}
- (NSString *)replace:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    return returnString;
}


@end
