//
//  ChangeOrderVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/9/12.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "UIViewExt.h"
#import "OrderModel.h"
#import "CommonModel.h"
#import "OrderViewCell.h"
#import "MBProgressHUD.h"
#import "KHmanageModel.h"
#import "CustCell.h"
#import "CPINfoModel.h"
#import "CPInfoCell.h"
#import "UnitModel.h"
#import "DataPost.h"
#import "ProMsgModel.h"

#define lineColor  COLOR(240, 240, 240, 1);
#import "ChangeOrderVC.h"

@interface ChangeOrderVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    MBProgressHUD *_HUD;
    UIScrollView *_mainScollView;
    UITableView *_orderTableView;
    NSMutableArray *_orderArray;
    UIButton *_delBtn;
    NSInteger _delSelect;   //删除的产品


    //客户信息
    UIView *_custView;

    UIButton *_nameButton;
    NSString *_custid;
    UITextField *_yuEField;
    UIButton *_payTypeButton;
    NSMutableArray *_dataArray; //客户信息

    UITextField *_custField;
    NSInteger _page;
    //付款方式
    NSMutableArray *_payArray;
    NSString *_payTypeId;



    //客户详情信息
    UIView *_detailView;
    UIButton *_wuLiuButton;
    NSString *_wuLiuID;
    UITextField *_receiver;
    UITextField *_receiveTel;
    UILabel *_receiveAdd;
    UIButton *_wuLiuDaiShou;
    UITextField *_daiShouJinE;
    NSString *_daiShouId;
    UITextField *_note;
    NSString *_saler;
    NSString *_salerId;
    //物流
    NSMutableArray *_logArray;

    //销售类型
    NSMutableArray *_saleTypeArray;

    //产品信息
    UITextField *_proField;
    NSInteger _proSelect;
    NSInteger _page1;
    NSMutableArray *_proArray;
    NSMutableArray *_UNITArray;
    NSMutableArray *_UnitPriceArray;
    NSInteger _unitSelect;

    //存储选择销售类型的数据
    NSString *_singlePrice;
    //    NSString *_totalMoney;
    //    NSString *_salePrice;
    //    NSString *_saleMoney;

    NSString *_currentDateStr;
    NSInteger _nullFlag;

    NSMutableArray *_YNArray;

}
@property(nonatomic,retain)UIView *listBack;

@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *payTypeTableView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *saleTypetableView;
@property(nonatomic,retain)UITableView *unitTableView;
@property(nonatomic,retain)UITableView *logtableView;
@property(nonatomic,retain)UITableView *daiShouTableView;
@end

@implementation ChangeOrderVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _page1 = 1;
    _YNArray = [NSMutableArray array];
    _UNITArray = [NSMutableArray array];
    _UnitPriceArray = [NSMutableArray array];
    _saleTypeArray = [NSMutableArray array];
    _proArray = [NSMutableArray array];
    _payArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _orderArray = [NSMutableArray array];
    OrderModel *model = [[OrderModel alloc]init];
//    [_orderArray addObject:model];
    [_orderArray addObjectsFromArray:_ProArray];
//    ProMsgModel *model = [[ProMsgModel alloc] init];
//    [model setValuesForKeysWithDictionary:dic];
//    [_dataArray addObject:model];

    
    //是否
    CommonModel *model1 = [[CommonModel alloc]init];
    CommonModel *model2 = [[CommonModel alloc]init];
    [model1 setValue:@"是" forKey:@"name"];
    [model1 setValue:@"1" forKey:@"Id"];
    [model2 setValue:@"否" forKey:@"name"];
    [model2 setValue:@"0" forKey:@"Id"];
    [_YNArray addObject:model1];
    [_YNArray addObject:model2];
    self.title = @"下订单";
    [self showBarWithName:@"提交" addBarWithName:nil];
    //UI
    [self initView];
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    
    
    // [self initCustDetailView];
    [_HUD hide:YES];
    
    
    //
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    
}
- (void)initView{
    _mainScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    [self.view addSubview:_mainScollView];
    
    _custView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 138)];
    //_custView.backgroundColor = [UIColor redColor];
    
    UILabel *custlabel =  [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 45)];
    custlabel.font = [UIFont systemFontOfSize:14];
    custlabel.text = @"客户名称*";
    [_custView addSubview:custlabel];
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame = CGRectMake(85, 0, KscreenWidth - 90, 45);
    [_nameButton setTintColor:[UIColor blackColor]];
    _nameButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_nameButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_custView addSubview:_nameButton];
    _custid = [NSString stringWithFormat:@"%@",_model.custid];
    _saler = [NSString stringWithFormat:@"%@",_model.saler];
    _salerId = [NSString stringWithFormat:@"%@",_model.salerid];
    NSString* namestr = [NSString stringWithFormat:@"%@",_model.custname];
    namestr = [self convertNull:namestr];
    [_nameButton setTitle:namestr forState:UIControlStateNormal];
    _nameButton.userInteractionEnabled = NO;
    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [_custView addSubview:line1];
    //
    UILabel *yuelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 46, 80, 45)];
    yuelabel.font = [UIFont systemFontOfSize:14];
    yuelabel.text = @"客户余额";
    [_custView addSubview:yuelabel];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [_custView addSubview:line2];
    _yuEField = [[UITextField alloc] initWithFrame:CGRectMake(85, 46, KscreenWidth - 90, 45)];
    _yuEField.delegate = self;
    _yuEField.font = [UIFont systemFontOfSize:14];
    _yuEField.userInteractionEnabled = NO;
    [_custView addSubview:_yuEField];
    NSString* yuestr = [NSString stringWithFormat:@"%@",_model.creditline];
    yuestr = [self convertNull:yuestr];
    _yuEField.text =yuestr;
    //
    UILabel  *paylabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 92, 80, 45)];
    paylabel.font = [UIFont systemFontOfSize:14];
    paylabel.text = @"付款方式";
    [_custView addSubview:paylabel];
    _payTypeButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _payTypeButton.frame = CGRectMake(85, 92, KscreenWidth - 90, 45);
    [_payTypeButton setTintColor:[UIColor grayColor]];
    _payTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _payTypeId = [NSString stringWithFormat:@"%@",_model.paidtypeid];
    NSString* paidtype = [NSString stringWithFormat:@"%@",_model.paidtype];
    paidtype = [self convertNull:paidtype];
    [_payTypeButton setTitle:paidtype forState:UIControlStateNormal];
    [_payTypeButton addTarget:self action:@selector(payTypeAction) forControlEvents:UIControlEventTouchUpInside];
    _payTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_custView addSubview:_payTypeButton];
#pragma mark 添加产品的TabbleView
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 325)];
    
    //
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"物流名称";
    label1.font =[UIFont systemFontOfSize:14];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [_detailView addSubview:view1];
    [_detailView addSubview:label1];
    _wuLiuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _wuLiuButton.frame = CGRectMake(100, 0, KscreenWidth - 110, 45);
    [_wuLiuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _wuLiuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_wuLiuButton addTarget:self action:@selector(wuLiuAction) forControlEvents:UIControlEventTouchUpInside];
    [_detailView addSubview:_wuLiuButton];
    _wuLiuID = [NSString stringWithFormat:@"%@",_model.logisticsid];
    NSString* logisticsname = [NSString stringWithFormat:@"%@",_model.logisticsname];
    logisticsname = [self convertNull:logisticsname];
    [_wuLiuButton setTitle:logisticsname forState:UIControlStateNormal];
    _wuLiuButton.userInteractionEnabled = NO;
    //
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"收货人";
    label2.font =[UIFont systemFontOfSize:14];
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    _receiver =[[UITextField alloc]initWithFrame:CGRectMake(100, label2.top, KscreenWidth - 110, 45)];
    _receiver.font =[UIFont systemFontOfSize:14];
    _receiver.textAlignment = NSTextAlignmentLeft;
    _receiver.enabled= NO;
    _receiver.delegate = self;
    [_detailView addSubview:label2];
    [_detailView addSubview:view2];
    [_detailView addSubview:_receiver];
    NSString* receiver = [NSString stringWithFormat:@"%@",_model.receiver];
    receiver = [self convertNull:receiver];
    _receiver.text = receiver;
    _receiver.userInteractionEnabled = NO;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"收货人电话";
    label3.font = [UIFont systemFontOfSize:14];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    _receiveTel = [[UITextField alloc] initWithFrame:CGRectMake(100, label3.top, KscreenWidth - 110, 45)];
    _receiveTel.delegate  = self;
    _receiveTel.font = [UIFont systemFontOfSize:14];
    _receiveTel.textAlignment = NSTextAlignmentLeft;
    _receiveTel.enabled = NO;
    [_detailView addSubview:label3];
    [_detailView addSubview:view3];
    [_detailView addSubview:_receiveTel];
    NSString* receivertel = [NSString stringWithFormat:@"%@",_model.receivertel];
    receivertel = [self convertNull:receivertel];
    _receiveTel.text = receivertel;
    _receiveTel.userInteractionEnabled = NO;
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"收货人地址";
    label4.font = [UIFont systemFontOfSize:14];
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    _receiveAdd =[[UILabel alloc]initWithFrame:CGRectMake(100, label4.top, KscreenWidth - 110, 45)];
    _receiveAdd.font =[UIFont systemFontOfSize:14];
    _receiveAdd.textAlignment = NSTextAlignmentLeft;
    _receiveAdd.numberOfLines = 0;
    [_detailView addSubview:label4];
    [_detailView addSubview:view4];
    [_detailView addSubview:_receiveAdd];
    NSString* receiveaddr = [NSString stringWithFormat:@"%@",_model.receiveaddr];
    receiveaddr = [self convertNull:receiveaddr];
    _receiveAdd.text = receiveaddr;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"物流代收";
    label5.font = [UIFont systemFontOfSize:14];
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    _wuLiuDaiShou = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _wuLiuDaiShou.frame = CGRectMake(100, label5.top, KscreenWidth - 110, 45);
    [_wuLiuDaiShou setTintColor:[UIColor grayColor]];
    _wuLiuDaiShou.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_wuLiuDaiShou addTarget:self action:@selector(YORN) forControlEvents:UIControlEventTouchUpInside];
    [_wuLiuDaiShou setTitle:@"否" forState:UIControlStateNormal];
    [_detailView addSubview:label5];
    [_detailView addSubview:view5];
    [_detailView addSubview:_wuLiuDaiShou];
    _wuLiuDaiShou.userInteractionEnabled = NO;
    NSString* daidai = [NSString stringWithFormat:@"%@",_model.daidai];
    if (!IsEmptyValue(daidai)) {
        if ([daidai integerValue] == 0) {
            [_wuLiuDaiShou setTitle:@"否" forState:UIControlStateNormal];
        }else if ([daidai integerValue] == 1){
            [_wuLiuDaiShou setTitle:@"是" forState:UIControlStateNormal];
        }
    }
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"代收金额";
    label6.font =[UIFont systemFontOfSize:14];
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    _daiShouJinE = [[UITextField alloc] initWithFrame:CGRectMake(100, label6.top, KscreenWidth - 110, 45)];
    _daiShouJinE.delegate = self;
    _daiShouJinE.font = [UIFont systemFontOfSize:14];
    _daiShouJinE.textAlignment = NSTextAlignmentLeft;
    [_detailView addSubview:label6];
    [_detailView addSubview:view6];
    [_detailView addSubview:_daiShouJinE];
    NSString *daishou = _wuLiuDaiShou.titleLabel.text;
    if ([daishou isEqualToString:@"否"]) {
        _daiShouJinE.userInteractionEnabled = NO;
    }else{
        _daiShouJinE.userInteractionEnabled = YES;
    }
    _daiShouJinE.userInteractionEnabled = NO;
    NSString* daishoumoney = [NSString stringWithFormat:@"%@",_model.daishoumoney];
    daishoumoney = [self convertNull:daishoumoney];
    _daiShouJinE.text = daishoumoney;
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"备注";
    label7.font =[UIFont systemFontOfSize:14];
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [_detailView addSubview:label7];
    [_detailView addSubview:view7];
    _note = [[UITextField alloc] initWithFrame:CGRectMake(100, label7.top, KscreenWidth - 110, 45)];
    _note.font = [UIFont systemFontOfSize:14];
    _note.textAlignment = NSTextAlignmentLeft;
    _note.delegate = self;
    [_detailView addSubview:_note];
    _note.text = [self convertNull:[NSString stringWithFormat:@"%@",_model.note]];
    
    
    
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 , KscreenWidth, KscreenHeight - 64 - 49)];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.scrollEnabled = NO;
    _orderTableView.rowHeight = 540 ;
    [_mainScollView addSubview:_orderTableView];
    
    // _orderTableView.tableHeaderView = _custView;
    _orderTableView.frame = CGRectMake(0, 0, KscreenWidth, 540*_orderArray.count + 138 + 400);
    _mainScollView.contentSize = CGSizeMake(0, 585*_orderArray.count + 138 + 350 );
    
    
    
}



#pragma mark  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _orderTableView) {
        return 3;
    }else{
        return 1;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _orderTableView) {
        if (section == 0) {
            return 1;
        }else if(section == 2){
            return 1;
        }else{
            return _orderArray.count;
        }
    }else if (tableView == _custTableView){
        return _dataArray.count;
    }else if (tableView == _payTypeTableView){
        return _payArray.count;
    }else if (tableView == _proTableView){
        return _proArray.count;
    }else if (tableView == _unitTableView){
        return _UnitPriceArray.count;
    }else if (tableView == _saleTypetableView){
        return _saleTypeArray.count;
    }else if (tableView == _logtableView){
        return _logArray.count;
    }else if (tableView == _daiShouTableView){
        return _YNArray.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_order";
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (OrderViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"OrderViewCell" owner:self options:nil]firstObject] ;
    }
    UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    
    CustCell *cell2 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]firstObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    
    static NSString *iden1 = @"cell_pro";
    CPInfoCell *cell3 =  [tableView dequeueReusableCellWithIdentifier:iden1];
    if (cell3 == nil) {
        cell3 = (CPInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"CPInfoCell" owner:self options:nil]firstObject];
        cell3.backgroundColor = [UIColor whiteColor];
        
    }
    
#pragma mark - order
    if (tableView == _orderTableView) {
        
        if (indexPath.section == 0) {
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell1.contentView addSubview:_custView];
            return cell1;
        }else if (indexPath.section == 2){
            
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //[self initCustDetailView];
            [cell1.contentView addSubview:_detailView];
            return cell1;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSInteger count = indexPath.row;
            cell.titleLabel.text = [NSString stringWithFormat:@"产品信息(%zi)",count+1];
            
            cell.model = _orderArray[indexPath.row];
            OrderModel *model = _orderArray[indexPath.row];
            
            //产品选择的按钮
            UIButton *proBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, cell.titleLabel.bottom, KscreenWidth - 110, 45)];
            proBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            proBtn.tag = indexPath.row;
            [proBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [proBtn.titleLabel  setFont:[UIFont systemFontOfSize:14]];
            [proBtn addTarget:self action:@selector(proAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView  addSubview:proBtn];
            
            NSString *proname = model.proname;
            proname = [self convertNull:proname];
            if (proname.length == 0) {
                [proBtn setTitle:@"请选择产品" forState:UIControlStateNormal];
            }else{
                [proBtn setTitle:proname forState:UIControlStateNormal];
            }
            
            //单位
            UIButton *unitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            unitBtn.frame = CGRectMake(100, cell.specLabel.bottom + 1, KscreenWidth - 110, 45);
            unitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [unitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            unitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            //unitBtn.userInteractionEnabled = NO;
            [unitBtn addTarget:self action:@selector(unitAction:) forControlEvents:UIControlEventTouchUpInside];
            unitBtn.tag = indexPath.row;
            [cell.contentView addSubview:unitBtn];
            
            NSString *proUnit = model.prounitname;
            proUnit = [self convertNull:proUnit];
            [unitBtn setTitle:proUnit forState:UIControlStateNormal];
            
            //折后单价
            UITextField *salePrice =[[UITextField alloc] initWithFrame:CGRectMake(100, cell.priceLabel.bottom + 1, KscreenWidth - 110, 45)];
            salePrice.font =[UIFont systemFontOfSize:14];
            salePrice.textAlignment = NSTextAlignmentLeft;;
            salePrice.textColor = [UIColor grayColor];
            salePrice.delegate = self;
            salePrice.tag = indexPath.row;
            [cell.contentView addSubview:salePrice];
            [salePrice addTarget:self action:@selector(priceAction:) forControlEvents:UIControlEventEditingChanged];
            
            NSString *saleprice = model.saledprice;
            saleprice = [self convertNull:saleprice];
            salePrice.text = saleprice;
            //销售类型
            
            UIButton *saleType = [UIButton buttonWithType:UIButtonTypeCustom];
            saleType.frame = CGRectMake(100, salePrice.bottom + 1, KscreenWidth - 110, 45);
            saleType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [saleType setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [saleType addTarget:self action:@selector(saleTypeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            saleType.titleLabel.font = [UIFont systemFontOfSize:14];
            saleType.tag = indexPath.row;
            [cell.contentView addSubview:saleType];
            
            NSString *saletypeName = model.saletypename;
            saletypeName = [self convertNull:saletypeName];
            if (saletypeName.length == 0) {
                [saleType setTitle:@"请选择销售类型" forState:UIControlStateNormal];
            }else{
                [saleType setTitle:saletypeName forState:UIControlStateNormal];
            }
            //返利率
            UITextField *rate =[[UITextField alloc] initWithFrame:CGRectMake(100, saleType.bottom + 1, KscreenWidth - 110, 45)];
            rate.font =[UIFont systemFontOfSize:14];
            rate.textAlignment = NSTextAlignmentLeft;;
            rate.textColor = [UIColor grayColor];
            rate.delegate = self;
            rate.tag = indexPath.row;
            [cell.contentView addSubview:rate];
            [rate addTarget:self action:@selector(rateAction:) forControlEvents:UIControlEventEditingChanged];
            
            NSString *returnrate = [NSString stringWithFormat:@"%@",model.returnrate];
            NSLog(@"ddddddd= %@  %zi",returnrate,returnrate.length);
            returnrate = [self convertNull:returnrate];
            rate.text = returnrate;
            //数量
            UITextField *proCount =[[UITextField alloc] initWithFrame:CGRectMake(100, rate.bottom + 1, KscreenWidth - 110, 45)];
            proCount.font =[UIFont systemFontOfSize:14];
            proCount.textAlignment = NSTextAlignmentLeft;;
            proCount.textColor = [UIColor grayColor];
            proCount.text = @"0";
            proCount.delegate = self;
            proCount.tag = indexPath.row;
            [cell.contentView addSubview:proCount];
            [proCount addTarget:self action:@selector(countAction:) forControlEvents:UIControlEventEditingChanged];
            
            NSString *maincount = [NSString stringWithFormat:@"%@",model.maincount];
            maincount = [self convertNull:maincount];
            proCount.text = maincount;
            
            
            //删除按钮
//            if (indexPath.row != 0) {
                _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _delBtn.frame = CGRectMake(KscreenWidth - 70, 0, 60, 45);
                _delBtn.tag = indexPath.row;
                [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
                [_delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_delBtn];
//            }
            if (indexPath.row == _orderArray.count - 1) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.rateMoneyLabel.bottom, KscreenWidth, 45)];
                view.backgroundColor = lineColor ;
                [cell.contentView addSubview:view];
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(KscreenWidth - 90, 0, 80, 45);
                addBtn.tag = indexPath.row;
                [addBtn setTitle:@"继续添加  " forState:UIControlStateNormal];
                [addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:addBtn];
            }
            
            return cell;
            
            
        }
        
    }else if (tableView == _custTableView){
        if (_dataArray.count != 0) {
            cell2.model = _dataArray[indexPath.row];
        }
        return cell2;
    }else if (tableView == _payTypeTableView){
        if (_payArray.count != 0) {
            CommonModel *model = _payArray[indexPath.row];
            cell1.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        }
        return cell1;
    }else if (tableView == _proTableView){
        if (_proArray.count != 0) {
            cell3.model = _proArray[indexPath.row];
        }
        return cell3;
    }else if (tableView == _unitTableView){
        
        if (_UnitPriceArray.count != 0) {
            CommonModel *model = _UnitPriceArray[indexPath.row];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }else if (tableView == _saleTypetableView){
        if (_saleTypeArray.count != 0) {
            CommonModel *model = _saleTypeArray[indexPath.row];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }else if (tableView == _logtableView){
        if (_logArray.count != 0) {
            CommonModel *model = _logArray[indexPath.row];
            cell1.textLabel.text = model.logname;
        }
        return cell1;
    }else if (tableView == _daiShouTableView){
        if (_YNArray.count != 0) {
            CommonModel *model = _YNArray[indexPath.row];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _custTableView) {
        [self.listBack removeFromSuperview];
        _nameButton.userInteractionEnabled = YES;
        KHmanageModel *model = [_dataArray objectAtIndex:indexPath.row];
        [_nameButton setTitle:model.name forState:UIControlStateNormal];
        _custid = model.Id;
        [self getCustInfo];
        [self getSalerInfo];
        [self getCPInfo];
        [self saleTypeRequest]; // 销售方式
    }
    if (tableView == _payTypeTableView) {
        [self.listBack removeFromSuperview];
        _payTypeButton.userInteractionEnabled = YES;
        CommonModel *model = _payArray[indexPath.row];
        [_payTypeButton setTitle:model.name forState:UIControlStateNormal];
        _payTypeId = model.Id;
        
    }
    if (tableView == self.proTableView) {
        
        [self.listBack removeFromSuperview];
        //产品信息
        CPINfoModel *model = _proArray[indexPath.row];
        //对产品信息的单位信息处理
        NSArray *array = _UNITArray[indexPath.row];
        _UnitPriceArray = [NSMutableArray array];
        for (NSDictionary *dic  in array) {
            UnitModel *model = [[UnitModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_UnitPriceArray addObject:model];
        }
        NSString *proprice;
        NSString *unit;
        NSString *unitId;
        
        for (UnitModel *model1 in _UnitPriceArray) {
            NSLog(@"ismain %@ ",model1.ismain);
            NSString *ismain = [NSString stringWithFormat:@"%@",model1.ismain];
            if ([ismain isEqualToString:@"1"]) {
                proprice = [NSString stringWithFormat:@"%@",model1.proprice];
                unitId = [NSString stringWithFormat:@"%@",model1.Id];
                unit = model1.name;
            }
        }
        //获得销售方式
        CommonModel *saleModel = [[CommonModel alloc]init];
        if (_saleTypeArray.count != 0) {
            saleModel = _saleTypeArray[0];
        }
        
        //取得要修改或添加的model
        OrderModel *orderModel = _orderArray[_proSelect];
        orderModel.proname = model.proname;
        orderModel.proid = model.Id;
        orderModel.prono = model.prono;
        orderModel.specification = model.specification;
        orderModel.returnrate = model.returnrate;
        orderModel.singleprice = proprice;
        orderModel.saledprice = proprice;
        orderModel.prounitname = unit;
        orderModel.prounitid = unitId;
        orderModel.stockcount = model.freecount;
        orderModel.maincount = @"0";
        orderModel.remaincount = @"0";
        orderModel.totalmoney = @"0";
        orderModel.saledmoney = @"0";
        orderModel.saletype  = saleModel.Id;
        orderModel.saletypename = saleModel.name;
        orderModel.prounitType = @"1";
        _singlePrice = proprice;
        [_orderTableView reloadData];
    }
    if (tableView == _unitTableView) {
        [self.listBack removeFromSuperview];
        //单位
        UnitModel *model = _UnitPriceArray[indexPath.row];
        //赋值
        OrderModel *orderModel = _orderArray[_proSelect];
        double price = [model.proprice doubleValue];
        double count = [orderModel.maincount doubleValue];
        double rate = [orderModel.returnrate doubleValue];
        NSString *totalmoney= [NSString stringWithFormat:@"%.2f",count *price];
        NSString *saleprice = [NSString stringWithFormat:@"%.2f",(1.00-rate) *price];
        NSString *salemoney= [NSString stringWithFormat:@"%.2f",count *price*(1.00-rate)];
        orderModel.prounitType = model.ismain;
        orderModel.prounitname = [NSString stringWithFormat:@"%@",model.name];
        orderModel.prounitid = [NSString stringWithFormat:@"%@",model.Id];
        orderModel.singleprice = [NSString stringWithFormat:@"%@",model.proprice];
        orderModel.totalmoney = totalmoney;
        orderModel.saledprice = saleprice;
        orderModel.saledmoney = salemoney;
        _singlePrice = model.proprice;
        
        [_orderTableView reloadData];
    }
    if (tableView == _saleTypetableView) {
        
        [self.listBack removeFromSuperview];
        CommonModel *model = _saleTypeArray[indexPath.row];
        NSString *name = model.name;
        OrderModel *orderModel = _orderArray[_proSelect];
        orderModel.saletypename = model.name;
        orderModel.saletype = model.Id;
        NSLog(@"ssss==%@",_singlePrice);
        double price = [_singlePrice doubleValue];
        double count = [orderModel.maincount doubleValue];
        double rate = [orderModel.returnrate doubleValue];
        NSString *totalmoney= [NSString stringWithFormat:@"%.2f",count *price];
        NSString *saleprice = [NSString stringWithFormat:@"%.2f",(1-rate) *price];
        NSString *salemoney= [NSString stringWithFormat:@"%.2f",count *price*(1-rate)];
        
        if ([name isEqualToString:@"赠品"]) {
            orderModel.saledprice = @"0.00";
            orderModel.singleprice = @"0.00";
            orderModel.totalmoney = @"0.00";
            orderModel.saledmoney = @"0.00";
        }else{
            
            orderModel.singleprice = _singlePrice;
            orderModel.totalmoney = totalmoney;
            orderModel.saledprice = saleprice;
            orderModel.saledmoney = salemoney;
        }
        [_orderTableView reloadData];
    }
    if (tableView == _logtableView) {
        [self.listBack removeFromSuperview];
        CommonModel *model = _logArray[indexPath.row];
        [_wuLiuButton setTitle:model.logname forState:UIControlStateNormal];
        _wuLiuID = model.Id;
        
    }
    else if(tableView == self.daiShouTableView){
        
        [self.listBack removeFromSuperview];
        CommonModel *model = _YNArray[indexPath.row];
        [_wuLiuDaiShou setTitle:model.name forState:UIControlStateNormal];
        _daiShouId = model.Id;
        //对代收金额输入限制
        NSString *daishou = model.name;
        if ([daishou isEqualToString:@"否"]) {
            _daiShouJinE.userInteractionEnabled = NO;
        }else{
            _daiShouJinE.userInteractionEnabled = YES;
        }
        
    }
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _orderTableView) {
        if (indexPath.section == 0) {
            return 140;
        }else if (indexPath.section == 1){
            if (indexPath.row == _orderArray.count -1) {
                return 540+ 45;
            }else{
                return 540;
            }
        }else{
            return 450;
        }
        
    }else if (tableView == _custTableView ){
        return 50;
    }else if (tableView == _payTypeTableView || tableView == _unitTableView||tableView == _saleTypetableView ||tableView == _logtableView||tableView == _daiShouTableView){
        return 45;
    }else if (tableView == _proTableView ){
        return 80;
    }else{
        
        return 0;
    }
    
}
- (void)priceAction:(UITextField *)textField{
    
    
    OrderModel *orderModel = _orderArray[textField.tag];
    
    double saleprice = [textField.text doubleValue];
    double price = [orderModel.singleprice doubleValue];
    double count = [orderModel.maincount doubleValue];
    double rate = (price - saleprice)/price;
    //输入折后单价 计算返利率 折后金额
    NSString *returnrate= [NSString stringWithFormat:@"%.2f",rate];
    NSString *salePrice = [NSString stringWithFormat:@"%.2f",saleprice];
    NSString *salemoney= [NSString stringWithFormat:@"%.2f",count *saleprice];
    
    orderModel.returnrate = returnrate;
    orderModel.saledprice = salePrice;
    orderModel.saledmoney = salemoney;
    
}
- (void)rateAction:(UITextField *)textField{
    NSLog(@"sssss= %zi",textField.tag);
    OrderModel *orderModel = _orderArray[textField.tag];
    
    double rate = [textField.text doubleValue];
    double price = [orderModel.singleprice doubleValue];
    double count = [orderModel.maincount doubleValue];
    double saleprice = price *(1.00-rate);
    //输入返利率 计算折后金额 折后单价
    NSString *returnrate= [NSString stringWithFormat:@"%.2f",rate];
    NSString *salePrice = [NSString stringWithFormat:@"%.2f",saleprice];
    NSString *salemoney= [NSString stringWithFormat:@"%.2f",count *saleprice];
    
    orderModel.returnrate = returnrate;
    orderModel.saledprice = salePrice;
    orderModel.saledmoney = salemoney;
    
}

- (void)countAction:(UITextField *)textField{
    
    OrderModel *orderModel = _orderArray[textField.tag];
    
    double count = [textField.text doubleValue];
    double price = [orderModel.singleprice doubleValue];
    double rate = [orderModel.returnrate doubleValue];
    double saleprice = price *(1.00 - rate);
    //输入数量 计算金额 折后金额
    NSString *salemoney= [NSString stringWithFormat:@"%.2f",count *saleprice];
    NSString *totalmoney = [NSString stringWithFormat:@"%.2f",count *price];
    
    orderModel.maincount = [NSString stringWithFormat:@"%.2f",count];
    orderModel.totalmoney = totalmoney;
    orderModel.saledmoney = salemoney;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_orderTableView reloadData];
    //    [_orderTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    CGPoint position = CGPointMake(0, _orderTableView.bottom - 700);
    
    [_mainScollView setContentOffset:position animated:YES];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_orderArray.count - 1 inSection:1];
    //    [_orderTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//删除添加时 刷新view的方法
- (void)refreshView{
    [_orderTableView reloadData];
    
    _orderTableView.frame = CGRectMake(0, 0, KscreenWidth,_orderArray.count * 540 + 45 + 138 + 325 );
    
    
    _mainScollView.contentSize = CGSizeMake(0, 138 + _orderArray.count * 540 + 400);
    [_HUD hide:YES];
    
}

#pragma mark - 产品选项删除的方法
- (void)delAction:(UIButton *)btn{
    _delSelect = btn.tag;
    //删除所选的数据
    if (_orderArray.count == 1) {
        [self showAlert:@"最后一个产品不能删除"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否删除此产品?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 1001;
        [alert show];
    }
}
#pragma mark - 产品选项添加的方法
- (void)addAction{
    //添加一个空的产品选项
    [_HUD show:YES];
    OrderModel *model = [[OrderModel alloc]init];
    [_orderArray addObject:model];
    //
    [self refreshView];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        
        if (buttonIndex == 1) {
            [_HUD show:YES];
            //删除所选的数据
            if (_orderArray.count>_delSelect) {
                [_orderArray removeObjectAtIndex:_delSelect];
            }
            if (_UNITArray.count>_delSelect) {
                [_UNITArray removeObjectAtIndex:_delSelect];
            }
            [self refreshView];
        }
    }
    
    if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            [self updateOrder];
            
        }
    }
    
}


#pragma mark - 客户信息
//名字按钮点击方法
- (void)nameAction
{
    
    [self showCustTableView];
    
    if (_dataArray.count == 0) {
        
        [self nameRequest];
        [self.custTableView reloadData];
        
    }
    
}



- (void)showCustTableView{
    
    self.listBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight- 64)];
    self.listBack.backgroundColor = COLOR(83, 83, 83, .5);
    //白色背景
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(30, 20, KscreenWidth - 60, KscreenHeight - 64-40)];
    [back.layer setCornerRadius:5];
    back.clipsToBounds = YES;
    back.backgroundColor = [UIColor whiteColor];
    [self.listBack addSubview:back];
    //输入
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(50, 40,KscreenWidth - 100 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
    _custField.borderStyle = UITextBorderStyleRoundedRect;
    _custField.font = [UIFont systemFontOfSize:13];
    [self.listBack addSubview:_custField];
    //搜索
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(_custField.right- 60, _custField.top, 60, 40);
    [btn addTarget:self action:@selector(getName) forControlEvents:UIControlEventTouchUpInside];
    [self.listBack addSubview:btn];
    
    if (self.custTableView == nil) {
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 80,KscreenWidth-60, KscreenHeight-200) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.rowHeight = 50;
    [self.listBack addSubview:self.custTableView];
    [self.view addSubview:self.listBack];
    [self.custTableView reloadData];
    
    
    
}
- (void)getName{
    
    NSString *custName = _custField.text;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lontitude = [userDefault objectForKey:@"longitude"];
    NSString *latitude = [userDefault objectForKey:@"latitude"];
    //NSLog(@"%@%@",lontitude,latitude);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"sortCustLocation",@"table":@"khxx",@"data":[NSString stringWithFormat:@"{\"long1\":\"%@\",\"lat1\":\"%@\",\"custname\":\"%@\"}",lontitude,latitude,custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@"客户名称数据%@",dic);
        NSArray *array = dic[@"rows"];
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            KHmanageModel *model = [[KHmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.custTableView reloadData];
        
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


- (void)nameRequest
{
    //客户名称 的浏览接口
    /*
     location
     "action":"sortCustLocation"
     "table": "khxx"
     mobile true
     page 1
     rows 20
     */
    //从userdefault 中取出数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lontitude = [userDefault objectForKey:@"longitude"];
    NSString *latitude = [userDefault objectForKey:@"latitude"];
    //NSLog(@"%@%@",lontitude,latitude);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"sortCustLocation",@"table":@"khxx",@"data":[NSString stringWithFormat:@"{\"long1\":\"%@\",\"lat1\":\"%@\"}",lontitude,latitude]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"客户名称数据%@",dic);
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            KHmanageModel *model = [[KHmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.custTableView reloadData];
        
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

- (void)closePop{
    _nameButton.userInteractionEnabled = YES;
    _payTypeButton.userInteractionEnabled = YES;
    _wuLiuButton.userInteractionEnabled = YES;
    [self.listBack removeFromSuperview];
}
#pragma mark -   付款方式
-(void)payTypeAction
{
    _payTypeButton.userInteractionEnabled = NO;
    
    self.listBack = [[UIView alloc]initWithFrame:self.view.bounds];
    self.listBack.backgroundColor = [UIColor clearColor];
    //灰色背景
    UIView* bgview = [[UIView alloc]initWithFrame:self.listBack.bounds];
    bgview.backgroundColor = COLOR(83, 83, 83, .5);
    [self.listBack addSubview:bgview];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePop)];
    tap.numberOfTapsRequired = 1;
    [bgview addGestureRecognizer:tap];
    
    //白色底层
    UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, KscreenWidth - 60, KscreenHeight - 84 - 30)];
    windowView.backgroundColor = [UIColor whiteColor];
    windowView.layer.cornerRadius = 10.0;
    windowView.layer.masksToBounds = YES;
    windowView.userInteractionEnabled = YES;
    [self.listBack addSubview:windowView];
    //
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, windowView.width, 30)];
    title.textColor = [UIColor lightGrayColor];
    title.text = @"   付款方式";
    [windowView addSubview:title];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(title.width - 60, 0, 60, 40);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [windowView addSubview:btn];
    if (self.payTypeTableView == nil) {
        self.payTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, windowView.width, windowView.height - 60) style:UITableViewStylePlain];
        
    }
    self.payTypeTableView.dataSource = self;
    self.payTypeTableView.delegate = self;
    [windowView addSubview:self.payTypeTableView];
    [self.view addSubview:self.listBack];
    
    [self payTypeReqyest];
    
    
}
#pragma mark - 付款方式请求方法
- (void)payTypeReqyest{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSDictionary *params = @{@"action":@"getSelectType",@"type":@"seal",@"table":@"base"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        
        _payArray = [NSMutableArray array];
        for (NSDictionary *dic in array ) {
            CommonModel *model = [[CommonModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_payArray addObject:model];
        }
        if (_payArray.count != 0 ) {
            CommonModel *model = _payArray[0];
            [_payTypeButton setTitle:model.name forState:UIControlStateNormal];
            _payTypeId = model.Id;
        }
        [self.payTypeTableView reloadData];
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

//物流名称  的点击方法
- (void)wuLiuAction
{
    /*
     物流名称
     customer
     action	getSelectLog
     table	wlxx
     */
    //物流名称－－的接口
    self.listBack = [[UIView alloc]initWithFrame:self.view.bounds];
    self.listBack.backgroundColor = [UIColor clearColor];
    //灰色背景
    UIView* bgview = [[UIView alloc]initWithFrame:self.listBack.bounds];
    bgview.backgroundColor = COLOR(83, 83, 83, .5);
    [self.listBack addSubview:bgview];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePop)];
    tap.numberOfTapsRequired = 1;
    [bgview addGestureRecognizer:tap];
    
    //白色底层
    UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, KscreenWidth - 60, KscreenHeight - 84 - 30)];
    windowView.backgroundColor = [UIColor whiteColor];
    windowView.layer.cornerRadius = 10.0;
    windowView.layer.masksToBounds = YES;
    windowView.userInteractionEnabled = YES;
    [self.listBack addSubview:windowView];
    //
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, windowView.width, 30)];
    title.textColor = [UIColor lightGrayColor];
    title.text = @"   物流名称";
    [windowView addSubview:title];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(title.width - 60, 0, 60, 40);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [windowView addSubview:btn];
    //
    if (self.logtableView == nil) {
        self.logtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, windowView.width, windowView.height) style:UITableViewStylePlain];
        
    }
    self.logtableView.dataSource = self;
    self.logtableView.delegate = self;
    
    [windowView addSubview:self.logtableView];
    [self.view addSubview:self.listBack];
    [self wuLiuRequest];
}
#pragma mark - 物流请求方法
- (void)wuLiuRequest{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectLog",@"table":@"wlxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        _logArray = [NSMutableArray array];
        for (NSDictionary *dic in  array) {
            CommonModel *model = [[CommonModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_logArray addObject:model];
        }
        if (array.count != 0 ) {
            NSString *wuliu = array[0][@"logname"];
            [_wuLiuButton setTitle:wuliu forState:UIControlStateNormal];
            _wuLiuID = array[0][@"id"];
        }
        [self.logtableView reloadData];
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

#pragma mark -代收
- (void)YORN{
    
    self.listBack = [[UIView alloc]initWithFrame:self.view.bounds];
    self.listBack.backgroundColor = [UIColor clearColor];
    //灰色背景
    UIView* bgview = [[UIView alloc]initWithFrame:self.listBack.bounds];
    bgview.backgroundColor = COLOR(83, 83, 83, .5);
    [self.listBack addSubview:bgview];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePop)];
    tap.numberOfTapsRequired = 1;
    [bgview addGestureRecognizer:tap];
    
    //白色底层
    UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, KscreenWidth - 120,  230)];
    windowView.backgroundColor = [UIColor whiteColor];
    windowView.layer.cornerRadius = 10.0;
    windowView.layer.masksToBounds = YES;
    windowView.userInteractionEnabled = YES;
    [self.listBack addSubview:windowView];
    //
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, windowView.width, 30)];
    title.textColor = [UIColor lightGrayColor];
    title.text = @"   物流代收";
    [windowView addSubview:title];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.frame = CGRectMake(title.width - 60, 0, 60, 40);
    [button addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [windowView addSubview:button];
    
    
    if (self.daiShouTableView == nil) {
        self.daiShouTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, windowView.width, windowView.height - 60) style:UITableViewStylePlain];
        
    }
    self.daiShouTableView.dataSource = self;
    self.daiShouTableView.delegate = self;
    
    [windowView addSubview:self.daiShouTableView];
    [self.view addSubview:self.listBack];
    [self.daiShouTableView reloadData];
    
}




- (void)getCustInfo
{
    //数据地址拼接
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getCustInfo",@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_custid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        // NSLog(@"客户详情%@",array);
        if (array.count != 0) {
            
            NSDictionary *dic = array[0];
            _yuEField.text =  [NSString stringWithFormat:@"%@",dic[@"creditline"]];
            _receiver.text =  dic[@"receiver"];
            _receiveTel.text = dic[@"receivertel"];
            _receiveAdd.text = dic[@"receiveaddr"];
            //物流
            NSString *log = dic[@"logisticsname"];
            [_wuLiuButton setTitle:log forState:UIControlStateNormal];
            _wuLiuID = dic[@"logisticsid"];
            //支付方式
            NSString *paidType = dic[@"paidtype"];
            [_payTypeButton setTitle:paidType forState:UIControlStateNormal];
            _payTypeId = dic[@"paidtypeid"];
            //无物流加载默认物流
            NSLog(@"物流%zi",log.length);
            if (log.length == 0) {
                // [self wuLiuRequest];
            }else if(paidType.length == 0){
                [self payTypeReqyest];
            }
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

#pragma mark 产品信息
- (void)proAction:(UIButton *)btn
{
    /*
     产品名称
     order
     action	fuzzyQuery
     mobile	true
     page	1
     params	{"proname":"","custid":"137"}  id = 1357;
     rows	10
     table	cpxx
     */
    
    //记录选择的产品
    _proSelect = btn.tag;
    NSString *cust = _nameButton.titleLabel.text;
    
    if ([cust isEqualToString:@"请选择客户"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户再操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        self.listBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight- 64)];
        self.listBack.backgroundColor = COLOR(83, 83, 83, .5);
        //白色背景
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(30, 20, KscreenWidth - 60, KscreenHeight - 64-40)];
        [back.layer setCornerRadius:5];
        back.clipsToBounds = YES;
        back.backgroundColor = [UIColor whiteColor];
        [self.listBack addSubview:back];
        //
        _proField = [[UITextField alloc] initWithFrame:CGRectMake(50, 40,KscreenWidth - 100 , 40)];
        _proField.backgroundColor = [UIColor whiteColor];
        _proField.delegate = self;
        _proField.tag =  102;
        _proField.placeholder = @"名称关键字";
        _proField.borderStyle = UITextBorderStyleRoundedRect;
        _proField.font = [UIFont systemFontOfSize:13];
        [self.listBack addSubview:_proField];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(_proField.right- 60, _proField.top, 60, 40);
        [btn addTarget:self action:@selector(getPro) forControlEvents:UIControlEventTouchUpInside];
        [self.listBack addSubview:btn];
        
        
        if (self.proTableView == nil) {
            self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 80,KscreenWidth-100, KscreenHeight-200) style:UITableViewStylePlain];
            self.proTableView.backgroundColor = [UIColor whiteColor];
        }
        self.proTableView.dataSource = self;
        self.proTableView.delegate = self;
        self.proTableView.rowHeight = 80;
        [self.listBack addSubview:self.proTableView];
        [self.view addSubview:self.listBack];
        
        if (_proArray.count == 0) {
            [self getCPInfo];
        }else{
            [self.proTableView reloadData];
        }
        
    }
}
//产品名称搜索方法
- (void)getPro{
    
    /*
     /product
     action=fuzzyQuery
     
     params= {"pronameLIKE":"sdfsdfs","custid":"111"}
     
     */
    
    if (_custid == nil) {
        
        [self showAlert:@"请先选择客户"];
    }else{
        
        
        NSString *proName = _proField.text;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
        NSDictionary *params = @{@"action":@"getMBProduct",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\",\"custid\":\"%@\"}",proName,_custid]};
        NSLog(@"上传数组%@",params);
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"产品信息搜索返回:%@",dic);
            [_proArray removeAllObjects];
            [_UNITArray removeAllObjects];
            for (NSDictionary *dic1 in dic) {
                CPINfoModel *model = [[CPINfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic1];
                [_proArray addObject:model];
                NSArray *array = dic1[@"unitlist"];
                [_UNITArray addObject:array];
            }
            [self.proTableView reloadData];
            
            
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
    
}


- (void)getCPInfo
{
    if (_custid == nil) {
        
        [self showAlert:@"请先选择客户"];
    }else{
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
        NSDictionary *params = @{@"action":@"getMBProduct",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"proname\":\"\",\"custid\":\"%@\"}",_custid]};
        
        [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",array);
            for (NSDictionary *dic in array) {
                CPINfoModel *model = [[CPINfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_proArray addObject:model];
                NSArray *array = dic[@"unitlist"];
                [_UNITArray addObject:array];
            }
            
            
            
            [self.proTableView reloadData];
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
    
}
#pragma mark -单位
- (void)unitAction:(UIButton *)btn
{
    
    NSArray *array = _UNITArray[btn.tag];
    _UnitPriceArray = [NSMutableArray array];
    for (NSDictionary *dic  in array) {
        UnitModel *model = [[UnitModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_UnitPriceArray addObject:model];
    }
    self.listBack = [[UIView alloc]initWithFrame:self.view.bounds];
    self.listBack.backgroundColor = [UIColor clearColor];
    //灰色背景
    UIView* bgview = [[UIView alloc]initWithFrame:self.listBack.bounds];
    bgview.backgroundColor = COLOR(83, 83, 83, .5);
    [self.listBack addSubview:bgview];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePop)];
    tap.numberOfTapsRequired = 1;
    [bgview addGestureRecognizer:tap];
    
    //白色底层
    UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, KscreenWidth - 120,  230)];
    windowView.backgroundColor = [UIColor whiteColor];
    windowView.layer.cornerRadius = 10.0;
    windowView.layer.masksToBounds = YES;
    windowView.userInteractionEnabled = YES;
    [self.listBack addSubview:windowView];
    //
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, windowView.width, 30)];
    title.textColor = [UIColor lightGrayColor];
    title.text = @"   产品单位";
    [windowView addSubview:title];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.frame = CGRectMake(title.width - 60, 0, 60, 40);
    [button addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [windowView addSubview:button];
    
    
    if (self.unitTableView == nil) {
        self.unitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, windowView.width, windowView.height - 60) style:UITableViewStylePlain];
        
    }
    self.unitTableView.dataSource = self;
    self.unitTableView.delegate = self;
    [windowView addSubview:self.unitTableView];
    [self.view addSubview:self.listBack];
    [self.unitTableView reloadData];
    
}
#pragma mark -  业务员信息
- (void)getSalerInfo
{
    //数据地址拼接
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipalByCust",@"params":[NSString stringWithFormat:@"{\"custidEQ\":\"%@\"}",_custid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        
        if (array.count != 0) {
            _saler = array[0][@"name"];
            _salerId = array[0][@"id"];
        }
        NSLog(@"客户业务员信息返回:%@",array);
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

#pragma mark - 销售类型请求
- (void)saleTypeAction:(UIButton *)btn
{
    _proSelect = btn.tag;
    self.listBack = [[UIView alloc]initWithFrame:self.view.bounds];
    self.listBack.backgroundColor = [UIColor clearColor];
    //灰色背景
    UIView* bgview = [[UIView alloc]initWithFrame:self.listBack.bounds];
    bgview.backgroundColor = COLOR(83, 83, 83, .5);
    [self.listBack addSubview:bgview];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePop)];
    tap.numberOfTapsRequired = 1;
    [bgview addGestureRecognizer:tap];
    
    //白色底层
    UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, KscreenWidth - 120, 230)];
    windowView.backgroundColor = [UIColor whiteColor];
    windowView.layer.cornerRadius = 10.0;
    windowView.layer.masksToBounds = YES;
    windowView.userInteractionEnabled = YES;
    [self.listBack addSubview:windowView];
    //
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, windowView.width, 30)];
    title.textColor = [UIColor lightGrayColor];
    title.text = @"   销售类型";
    [windowView addSubview:title];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.frame = CGRectMake(title.width - 60, 0, 60, 40);
    [button addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [windowView addSubview:button];
    //
    if (self.saleTypetableView == nil) {
        self.saleTypetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, windowView.width, windowView.height - 30) style:UITableViewStylePlain];
        
    }
    self.saleTypetableView.dataSource = self;
    self.saleTypetableView.delegate = self;
    
    [windowView addSubview:self.saleTypetableView];
    [self.view addSubview:self.listBack];
    [self saleTypeRequest];
    
}
- (void)saleTypeRequest{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSDictionary *params = @{@"action":@"getSelectType",@"type":@"saletype",@"table":@"base"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if (returnStr.length != 0) {
            returnStr = [self replaceOthers:returnStr];
            if ([returnStr isEqualToString:@"sessionoutofdate"]) {
                //掉线自动登录
                [self selfLogin];
            }else{
                NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
                _saleTypeArray = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_saleTypeArray addObject:model];
                }
                [self.saleTypetableView reloadData];
                NSLog(@"销售类型:%@",array);
            }
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"error =%@",error);
    }];
    
    
}



#pragma mark 提交点击按钮
- (void)addNext{
    NSString* saletypeEmpty;
    NSString* prounitidEmpty;
    NSString* maincountEmpty;
    for (int i = 0; i < _orderArray.count; i++) {
        OrderModel *model = _orderArray[i];
        if (IsEmptyValue(model.saletype)) {
            saletypeEmpty = @"1";
        }
        if (IsEmptyValue(model.prounitid)) {
            prounitidEmpty = @"1";
        }
        if (IsEmptyValue(model.maincount)||[[NSString stringWithFormat:@"%@",model.maincount] integerValue] == 0){
            maincountEmpty = @"1";
        }
    }
    if ([saletypeEmpty isEqualToString:@"1"]) {
        [self showAlert:@"请选择销售方式"];
    }else{
        if ([prounitidEmpty isEqualToString:@"1"]) {
            [self showAlert:@"请选择单位"];
        }else{
            if ([maincountEmpty isEqualToString:@"1"]) {
                [self showAlert:@"请填写数量"];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"是否修改此订单?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                alert.tag = 1002;
                [alert show];
                
            }
            
        }
    }

    
}

- (void)updateOrder{
    
    
    
    
    
    //计算总金额
    double totalmoney = 0;
    double totalzhehou = 0;
    NSInteger totalshumu = 0;
    
    
    NSString *_totalZheHou;
    NSString *_totalJinE;
    NSString *_totalCount;
    NSString *_proStr = @"";
    
    for (int i = 0; i < _orderArray.count; i++) {
        OrderModel *model = _orderArray[i];
        model.totalmoney = [NSString stringWithFormat:@"%@",model.totalmoney];
        model.maincount = [NSString stringWithFormat:@"%@",model.maincount];
        model.saledmoney = [NSString stringWithFormat:@"%@",model.saledmoney];
        double jinE = [model.totalmoney doubleValue];
        NSInteger count = [model.maincount integerValue];
        double zhehoujine = [model.saledmoney doubleValue];
        
        totalmoney = totalmoney + jinE;
        totalzhehou = totalzhehou + zhehoujine;
        totalshumu = totalshumu + count;
        //监测产品名称 和 数量不为空
        NSString *proName = [NSString stringWithFormat:@"%@",model.proname];
        proName = [self convertNull:proName];
        NSString *proCount = [NSString stringWithFormat:@"%@",model.maincount];
        proCount = [self convertNull:proCount];
        if (proCount.length == 0 || proName.length == 0) {
            _nullFlag = 0;
        }else{
            _nullFlag = 1;
        }
        model.saletype = [self convertNull:model.saletype];
        model.prounitid = [self convertNull:model.prounitid];
        //拼接上传的产品信息
        _proStr = [NSString stringWithFormat:@"%@{\"table\":\"pro_orderDetail\",\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"type\":\"%@\",\"saletype\":\"%@\",\"singleprice\":\"%@\",\"maincount\":\"%@\",\"remaincount\":\"%@\",\"returnrate\":\"%@\",\"saledprice\":\"%@\",\"totalmoney\":\"%@\",\"saledmoney\":\"%@\",\"fk\":\"orderid\",\"mainTable\":\"pro_order\"},",_proStr,model.proid,model.proname,model.prono,model.specification,model.prounitid,model.prounitname,model.prounitid,model.saletype,model.singleprice,model.maincount,model.remaincount,model.returnrate,model.saledprice,model.totalmoney,model.saledmoney];
        
    }
    
    _totalZheHou = [NSString stringWithFormat:@"%.2f",totalzhehou];
    _totalJinE = [NSString stringWithFormat:@"%.2f",totalmoney];
    _totalCount = [NSString stringWithFormat:@"%zi",totalshumu];
    //产品Str
    if (_proStr.length != 0) {
        NSRange range = {0,_proStr.length -1};
        _proStr = [_proStr substringWithRange:range];
    }
    
    
    
    
    
    
    //代收
    NSString *daishouStr  = _wuLiuDaiShou.titleLabel.text;
    NSLog(@"－－－－－长度%zi",daishouStr.length);
    NSString *daiShou;
    daiShou = [self convertNull:daiShou];
    NSString *daiShouMoney;
    daiShouMoney = [self convertNull:daiShouMoney];
    
    if ([daishouStr isEqualToString:@"是"]) {
        daiShou = @"1";
        daiShouMoney = _daiShouJinE.text;
        
    }else if([daishouStr isEqualToString:@"否"]){
        daiShou = @"0";
        daiShouMoney = @"0";
        daiShouMoney = [self convertNull:daiShouMoney];
    }
    
    //联系人
    NSString *reciever = _receiver.text;
    reciever = [self convertNull:reciever];
    
    NSString *recieveTel = _receiveTel.text;
    recieveTel = [self convertNull:recieveTel];
    
    NSString *recieveAdd = _receiveAdd.text;
    recieveAdd = [self convertNull:recieveAdd];
    
    NSString *wuliu = _wuLiuButton.titleLabel.text;
    wuliu = [self convertNull:wuliu];
    
    NSString *wuliuId = _wuLiuID;
    wuliuId = [self convertNull:wuliuId];
    
    NSString *name = _nameButton.titleLabel.text;
    name = [self convertNull:name];
    _saler = [self convertNull:_saler];
    _salerId = [self convertNull:_salerId];
    NSString *creditline = _yuEField.text;
    creditline = [self convertNull:creditline];
    NSString *paidtype = _payTypeButton.titleLabel.text;
    paidtype = [self convertNull:paidtype];
    _payTypeId = [self convertNull:_payTypeId];
    _note.text = [self convertNull:_note.text];
    
    if (_nullFlag == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"销售类型、单位和数量不可为空"delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSDictionary* params = @{@"action":@"modOrder",@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"orderno\":\"%@\",\"orderstatus\":\"%@\",\"spstatus\":\"%@\",\"custid\":\"%@\",\"custname\":\"%@\",\"salerid\":\"%@\",\"saler\":\"%@\",\"daidai\":\"%@\",\"paidtypeid\":\"%@\",\"paidtype\":\"%@\",\"ordertime\":\"%@\",\"logisticsid\":\"%@\",\"logisticsname\":\"%@\",\"receiver\":\"%@\",\"receivertel\":\"%@\",\"receiveaddr\":\"%@\",\"ordernote\":\"%@\",\"ordercount\":\"%@\",\"ordermoney\":\"%@\",\"returnordermoney\":\"%@\",\"addType\":\"%@\",\"fk\":\"orderid\",\"mainTable\":\"pro_order\",\"table\":\"pro_order\",\"xxxxList\":[%@]}",_model.Id,_model.orderno,_model.orderstatus,_model.spstatus,_custid,name,_salerId,_saler,daiShou,_payTypeId,paidtype,_model.ordertime,wuliuId,wuliu,reciever,recieveTel,recieveAdd,_note.text,_totalCount,_totalJinE,_totalZheHou,_model.addtype,_proStr]};
        
        
        //URl
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *retStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"修改订单返回值%@",retStr);
            if ([retStr rangeOfString:@"true"].location!=NSNotFound) {
                [self showAlert:@"订单修改成功!"];
                if (self.navigationController.viewControllers.count>2) {
                    NSInteger count = self.navigationController.viewControllers.count - 3;
                    UIViewController *viewCtl = self.navigationController.viewControllers[count];
                    [self.navigationController popToViewController:viewCtl animated:YES];
                }

                
            }else{
                [self showAlert:@"订单修改失败!"];
            }
            UIButton* btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
            btn.enabled = YES;
            
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            UIButton* btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
            btn.enabled = YES;
        }];
        
        
    }
    
    
}







@end



