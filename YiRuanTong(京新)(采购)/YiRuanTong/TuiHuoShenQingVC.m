//
//  TuiHuoShenQingVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "TuiHuoShenQingVC.h"
#import "TuiHuoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "KHnameModel.h"
#import "CPInfoCell.h"
#import "CPINfoModel.h"
#import "THCpInfoCell.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "THCPModel.h"
#import "DataPost.h"
#import "CustCell.h"
#import "DWandLXModel.h"
#import "ZLPhoto.h"
#import "ZLPhotoPickerCommon.h"
#import "Example2CollectionViewCell.h"


#define lineColor COLOR(240, 240, 240, 1);
@interface TuiHuoShenQingVC ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>

{
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSInteger _page1;
    NSMutableArray *_CPdataArray;
    UIAlertView *_showOrder;    //订单添加提示
    
    NSString *_salerId;
    NSString *_saler;
    NSString *_custId;
    NSString *_cust;
    NSString * proname;
    NSString *_returnrate;
    NSString *_returnmoney;
    NSString *_saledprice;
    NSString *_proid;  //产品ID
    NSString *_totalmoney;
    NSString *_saledmoney;
    NSString *_prounitId;
    MBProgressHUD *_hud;
    
    NSInteger _flag;
    NSInteger _nullFlag;
    NSInteger _chanpinOKFlag;
    
    NSMutableArray *_CPNameBtnArray;
    NSMutableArray *_CPIdArray;
    NSMutableArray *_FHBianMaArray;
    NSMutableArray *_CPGuigeArray;
    NSMutableArray *_CPDanWeiBtnArray;//单位
    NSMutableArray *_CPDanWeiIDArray;
    NSMutableArray *_DanjiaArray;
    NSMutableArray *_CPPiHaoArray;
    NSMutableArray *_FHShuliangArray;
    NSMutableArray *_THShuliangrray;
    NSMutableArray *_THJineArray;
    NSMutableArray *_returnRateArray;
    NSMutableArray *_chanpinViewArray;
    NSMutableArray *_salerdmoneyArray;
    
    UITextField  *_custField;
    UITextField *_proField;
    //
    UIButton *_custNamebButton;
    NSMutableArray *_unitArray;
    
    UIButton *_photoButton;
    NSString *_photoID;
    UIAlertView *_showApply;    //退货申请
    UIButton* _hide_keHuPopViewBut;
}
@property (strong, nonatomic) UIScrollView *tuiHuoAddScrolview;

@property(nonatomic,retain)UITableView *nameTableView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *UnitTableView;

@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;
@property(nonatomic,retain) UITableView *custTableView;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableDictionary *dictM;

@end

@implementation TuiHuoShenQingVC
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"退货申请";
    _dataArray = [[NSMutableArray alloc] init];
     _CPdataArray = [NSMutableArray array];
    _CPNameBtnArray = [[NSMutableArray alloc] init];
    _CPIdArray = [NSMutableArray array];
    _FHBianMaArray = [[NSMutableArray alloc] init];
    _CPGuigeArray = [[NSMutableArray alloc] init];
    _CPDanWeiBtnArray = [[NSMutableArray alloc] init];
    _CPDanWeiIDArray = [NSMutableArray array];
    _DanjiaArray = [[NSMutableArray alloc] init];
    _CPPiHaoArray = [[NSMutableArray alloc] init];
    _FHShuliangArray = [[NSMutableArray alloc] init];
    _THShuliangrray = [[NSMutableArray alloc] init];
    _THJineArray = [[NSMutableArray alloc] init];
    _returnRateArray = [[NSMutableArray alloc] init];
    
    _salerdmoneyArray = [[NSMutableArray alloc] init];
    _chanpinViewArray = [[NSMutableArray alloc] init];
    
    _page = 1;
    _page1 = 1;
    [self showBarWithName:@"提交" addBarWithName:nil];
    [self initScrollView];
    //拍照
    [self setupUI];
    [self addProducts];
    
    

}




#pragma mark  页面设置
- (void)initScrollView
{   //
    _tuiHuoAddScrolview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    _tuiHuoAddScrolview.bounces = NO;
    _tuiHuoAddScrolview.backgroundColor = [UIColor whiteColor];
    _tuiHuoAddScrolview.delegate = self;
    [self.view addSubview:_tuiHuoAddScrolview];
    
    UILabel * keHuName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 45)];
    keHuName.text = @"客户名称*";
    keHuName.font =[UIFont systemFontOfSize:14];
    UIView *keHuNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    keHuNameView.backgroundColor = lineColor;
    [self.tuiHuoAddScrolview addSubview:keHuNameView];
    [self.tuiHuoAddScrolview addSubview:keHuName];
    _custNamebButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, KscreenWidth - 100, 45)];
    _custNamebButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_custNamebButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_custNamebButton.titleLabel  setFont:[UIFont systemFontOfSize:14]];
    [_custNamebButton setTitle:@"请选择客户" forState:UIControlStateNormal];
    _custNamebButton.backgroundColor = [UIColor whiteColor];
    [_custNamebButton addTarget:self action:@selector(m_keHuNameButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.tuiHuoAddScrolview addSubview:_custNamebButton];
    
    UILabel * yeWuYuan = [[UILabel alloc] initWithFrame:CGRectMake(10, keHuName.bottom + 1, 80, 45)];
    yeWuYuan.text = @"业务员";
    yeWuYuan.font =[UIFont systemFontOfSize:14];
    UIView *yeWuYuanView =[[UIView alloc] initWithFrame:CGRectMake(0, yeWuYuan.bottom , KscreenWidth, 1)];
    yeWuYuanView.backgroundColor = lineColor;
    [self.tuiHuoAddScrolview addSubview:yeWuYuanView];
    [self.tuiHuoAddScrolview addSubview:yeWuYuan];
    self.m_yeWuYuan = [[UILabel alloc]initWithFrame:CGRectMake(90, keHuName.bottom + 1, KscreenWidth - 100, 45)];
    self.m_yeWuYuan.font = [UIFont systemFontOfSize:14];
    self.m_yeWuYuan.textAlignment = NSTextAlignmentLeft;
    [self.tuiHuoAddScrolview addSubview:self.m_yeWuYuan];
    
    UILabel * tuiHuoYuanYin = [[UILabel alloc] initWithFrame:CGRectMake(10, yeWuYuan.bottom + 1, 80, 45)];
    tuiHuoYuanYin.text = @"退货原因*";
    tuiHuoYuanYin.font = [UIFont systemFontOfSize:14];
    UIView *tuiHuoYuanYinView = [[UIView alloc] initWithFrame:CGRectMake(0, tuiHuoYuanYin.bottom, KscreenWidth, 1)];
    tuiHuoYuanYinView.backgroundColor = lineColor;
    [self.tuiHuoAddScrolview addSubview:tuiHuoYuanYinView];
    [self.tuiHuoAddScrolview addSubview:tuiHuoYuanYin];
    
    self.tuiHuoYuanYin1 = [[UITextField alloc] initWithFrame:CGRectMake(90, yeWuYuan.bottom + 1, KscreenWidth - 100, 45)];
    self.tuiHuoYuanYin1.placeholder = @"请输入原因（必填）";
    self.tuiHuoYuanYin1.font = [UIFont systemFontOfSize:14];
    self.tuiHuoYuanYin1.textAlignment = NSTextAlignmentLeft;
    [self.tuiHuoAddScrolview addSubview:self.tuiHuoYuanYin1];
    
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, tuiHuoYuanYin.bottom + 1, 80, 45)];
    label1.text = @"退货详情";
    label1.font = [UIFont systemFontOfSize:14];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, label1.bottom, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [self.tuiHuoAddScrolview addSubview:view1];
    [self.tuiHuoAddScrolview addSubview:label1];
    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_add" ofType:@"png"]];
    [_photoButton setImage:image forState:UIControlStateNormal];
    _photoButton.frame = CGRectMake(90, tuiHuoYuanYin.bottom + 1, 45, 45);
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_photoButton addTarget:self action:@selector(selectPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self.tuiHuoAddScrolview addSubview:_photoButton];

    
}


#pragma mark - 产品信息
- (void)addProducts
{
    NSString *proname;
    for (int i = 0; i < _flag; i++) {
        
        UIButton *btn = [_CPNameBtnArray objectAtIndex:i];
        proname = btn.titleLabel.text;
        proname = [self replaceChar:proname];
    }
    if ([proname isEqualToString:@"请选择产品"]) {
        [self showAlert:@"请选择产品后再继续添加"];
        return;
    }
    
    _chanpinOKFlag = 1;
    _flag = _flag + 1;
    
    self.tuiHuoAddScrolview.contentSize = CGSizeMake(KscreenWidth, 147 + 420 * _flag + 140);
    UIView *chanpinView = [[UIView alloc] initWithFrame:CGRectMake(0, 186 + (_flag-1) * 420, KscreenWidth,460 )];
    chanpinView.backgroundColor = [UIColor whiteColor];
    
    UILabel *chanPinXinXi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
    chanPinXinXi.text = [NSString stringWithFormat:@"产品信息(%zi)",_flag];
    chanPinXinXi.backgroundColor = COLOR(220, 220, 220, 1);
    chanPinXinXi.textColor = [UIColor blackColor];
    chanPinXinXi.font = [UIFont systemFontOfSize:18];
    chanPinXinXi.textAlignment = NSTextAlignmentCenter;
    [chanpinView addSubview:chanPinXinXi];
//    if (_flag > 1) {
//        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancel.frame = CGRectMake(KscreenWidth - 50, 5, 40, 30);
//        [cancel setTitle:@"删除" forState:UIControlStateNormal];
//        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [cancel addTarget:self action:@selector(closeChanpinView) forControlEvents:UIControlEventTouchUpInside];
//        [chanpinView addSubview:cancel];
//    }
    
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    line0.backgroundColor = lineColor;
    [chanpinView addSubview:line0];
    //产品名称
    UILabel *chanPinName = [[UILabel alloc] initWithFrame:CGRectMake(10,line0.bottom +1, 80, 45)];
    chanPinName.text = @"产品名称";
    chanPinName.font = [UIFont systemFontOfSize:14];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, line0.bottom + 46, KscreenWidth, 1)];
    line1.backgroundColor = lineColor;
    [chanpinView addSubview:chanPinName];
    [chanpinView addSubview:line1];
    
    UIButton *CPNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, line0.bottom + 1, KscreenWidth - 100, 45)];
    CPNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [CPNameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    CPNameBtn.backgroundColor = [UIColor whiteColor];
    [CPNameBtn addTarget:self action:@selector(m_chanPinMingChenButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
     [CPNameBtn setTitle:@"请选择产品" forState:UIControlStateNormal];
    CPNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [chanpinView addSubview:CPNameBtn];
    [_CPNameBtnArray addObject:CPNameBtn];
    
    UILabel *cpID = [[UILabel alloc] initWithFrame:CGRectMake(90, line0.bottom + 1, KscreenWidth - 100, 45)];
    [_CPIdArray addObject:cpID];
    
    //发货单号
    UILabel *chanPinBianMa = [[UILabel alloc] initWithFrame:CGRectMake( 10, chanPinName.bottom + 1, 80, 45)];
    chanPinBianMa.text = @"产品编码";
    chanPinBianMa.font = [UIFont systemFontOfSize:14];
    UIView *line2 =[[UIView alloc] initWithFrame:CGRectMake(0,chanPinName.bottom + 1 + 45 , KscreenWidth, 1)];
    line2.backgroundColor = lineColor;
    [chanpinView addSubview:line2];
    [chanpinView addSubview:chanPinBianMa];
    UILabel *CPBianMa = [[UILabel alloc] initWithFrame:CGRectMake(90, chanPinName.bottom + 1, KscreenWidth - 100, 45)];
    CPBianMa.font = [UIFont systemFontOfSize:14];
    CPBianMa.textAlignment = NSTextAlignmentLeft;
    [chanpinView addSubview:CPBianMa];
    [_FHBianMaArray addObject:CPBianMa];
    
    //产品规格
    UILabel *chanPinGuiGe =[[UILabel alloc] initWithFrame:CGRectMake(10, CPBianMa.bottom + 1, 80, 45)];
    chanPinGuiGe.text = @"产品规格";
    chanPinGuiGe.font = [UIFont systemFontOfSize:14];
    UIView *line3 =[[UIView alloc] initWithFrame:CGRectMake(0, CPBianMa.bottom + 1 + 45, KscreenWidth, 1)];
    line3.backgroundColor = lineColor;
    [chanpinView addSubview:line3];
    [chanpinView addSubview:chanPinGuiGe];
    UILabel *CPGuige = [[UILabel alloc] initWithFrame:CGRectMake(90, CPBianMa.bottom + 1, KscreenWidth - 100, 45)];
    CPGuige.font =[UIFont systemFontOfSize:14];
    CPGuige.textAlignment = NSTextAlignmentLeft;
    [chanpinView addSubview:CPGuige];
    [_CPGuigeArray addObject:CPGuige];
    
    //产品单位
    UILabel *chanPinDanWei = [[UILabel alloc] initWithFrame:CGRectMake(10, CPGuige.bottom + 1, 80, 45)];
    chanPinDanWei.text = @"产品单位";
    chanPinDanWei.font = [UIFont systemFontOfSize:14];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CPGuige.bottom + 1 + 45, KscreenWidth, 1)];
    line4.backgroundColor =  lineColor;
    [chanpinView addSubview:line4];
    [chanpinView addSubview:chanPinDanWei];
    UIButton *CPDanwei = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CPDanwei.frame = CGRectMake(90, CPGuige.bottom + 1, KscreenWidth - 100, 45);
    CPDanwei.titleLabel.font = [UIFont systemFontOfSize:14];
    [CPDanwei setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CPDanwei.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [CPDanwei addTarget:self action:@selector(UnitAction) forControlEvents:UIControlEventTouchUpInside];
    [chanpinView addSubview:CPDanwei];
    [_CPDanWeiBtnArray addObject:CPDanwei];
    //单位ID
    UILabel *danweiID = [[UILabel alloc] initWithFrame:CGRectMake(90, CPGuige.bottom + 1, KscreenWidth - 100, 45)];
    [_CPDanWeiIDArray addObject:danweiID];
    //单价
    UILabel *danJia = [[UILabel alloc] initWithFrame:CGRectMake(10, CPDanwei.bottom + 1, 80, 45)];
    danJia.text = @"单价";
    danJia.font =[UIFont systemFontOfSize:14];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, CPDanwei.bottom + 1 + 45, KscreenWidth, 1)];
    line5.backgroundColor = lineColor;
    [chanpinView addSubview:line5];
    [chanpinView addSubview:danJia];
    UITextField *Danjia = [[UITextField alloc]initWithFrame:CGRectMake(90, CPDanwei.bottom + 1, KscreenWidth - 100, 45)];
    Danjia.font = [UIFont systemFontOfSize:14];
    Danjia.delegate = self;
    Danjia.tag = 1000;
    Danjia.textAlignment = NSTextAlignmentLeft;
    [chanpinView addSubview:Danjia];
    [_DanjiaArray addObject:Danjia];
    
    //产品批号
    UILabel *chanPinPiHao = [[UILabel alloc]initWithFrame:CGRectMake(10, Danjia.bottom + 1, 80, 45)];
    chanPinPiHao.text = @"产品批号";
    chanPinPiHao.font =[UIFont systemFontOfSize:14];
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, Danjia.bottom + 1 + 45, KscreenWidth, 1)];
    line6.backgroundColor = lineColor;
    [chanpinView addSubview:line6];
    [chanpinView addSubview:chanPinPiHao];
    
    UITextField *CPPihao = [[UITextField alloc]initWithFrame:CGRectMake(90, Danjia.bottom + 1, KscreenWidth - 100, 45)];
    CPPihao.font = [UIFont systemFontOfSize:14];
    CPPihao.placeholder = @"请输入产品批号";
    CPPihao.textAlignment = NSTextAlignmentLeft;
    //CPPihao.userInteractionEnabled = NO;
    [chanpinView addSubview:CPPihao];
    [_CPPiHaoArray addObject:CPPihao];
    
    //退货数量
    UILabel *tuiHuoShuLiang = [[UILabel alloc]initWithFrame:CGRectMake(10, CPPihao.bottom + 1, 80, 45)];
    tuiHuoShuLiang.text = @"退货数量";
    tuiHuoShuLiang.font =[UIFont systemFontOfSize:14];
    UIView *line8 = [[UIView alloc]initWithFrame:CGRectMake(0, CPPihao.bottom + 1 + 45, KscreenWidth, 1)];
    line8.backgroundColor =  lineColor;
    [chanpinView addSubview:line8];
    [chanpinView addSubview:tuiHuoShuLiang];
    
    UITextField *THshuliang = [[UITextField alloc] initWithFrame:CGRectMake(90,CPPihao.bottom + 1, KscreenWidth - 100, 45)];
    THshuliang.font =[UIFont systemFontOfSize:14];
    THshuliang.placeholder = @"请输入数量(必填)";
    THshuliang.delegate = self;
    THshuliang.tag = 1001;
    THshuliang.textAlignment = NSTextAlignmentLeft;
    THshuliang.keyboardType = UIKeyboardTypeDecimalPad;
    [chanpinView addSubview:THshuliang];
    [_THShuliangrray addObject:THshuliang];
    
    //退货金额
    UILabel *tuiHuoJinE = [[UILabel alloc]initWithFrame:CGRectMake(10, THshuliang.bottom + 1, 80, 45)];
    tuiHuoJinE.text = @"退货金额";
    tuiHuoJinE.font = [UIFont systemFontOfSize:14];
    UIView *line9 = [[UIView alloc]initWithFrame:CGRectMake(0, THshuliang.bottom + 1 + 45, KscreenWidth, 1)];
    line9.backgroundColor = lineColor;
    [chanpinView addSubview:line9];
    [chanpinView addSubview:tuiHuoJinE];
    UILabel *THJine = [[UILabel alloc]initWithFrame:CGRectMake(90,THshuliang.bottom + 1, KscreenWidth - 100, 45)];
    THJine.font = [UIFont systemFontOfSize:14];
    THJine.textAlignment = NSTextAlignmentLeft;
    [chanpinView addSubview:THJine];
    [_THJineArray addObject:THJine];
    
    
    //
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, THJine.bottom + 1, KscreenWidth, 45)];
    addView.backgroundColor = COLOR(220, 220, 220, 1);
    [chanpinView addSubview:addView];
    //添加产品
    UIButton *tianJiaButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth - 90, 2, 80, 40)];
    [tianJiaButton setTitle:@"添加产品" forState:UIControlStateNormal];
    [tianJiaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [tianJiaButton addTarget:self action:@selector(addProducts) forControlEvents:UIControlEventTouchUpInside];
    tianJiaButton.titleLabel.font = [ UIFont systemFontOfSize:18];
    [addView addSubview:tianJiaButton];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(KscreenWidth - 180, 0, 80, 45);
    [cancel setTitle:@"删除产品" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(closeChanpinView) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:cancel];
    
    [self.tuiHuoAddScrolview addSubview:chanpinView];
    [_chanpinViewArray addObject:chanpinView];
}

- (void)closeChanpinView
{
    if (_flag == 1) {
        [self showAlert:@"至少保留一条物料信息"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除本条信息吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            
            [_CPNameBtnArray removeObjectAtIndex:_flag - 1];
            [_FHBianMaArray removeObjectAtIndex:_flag - 1];
            [_CPGuigeArray removeObjectAtIndex:_flag - 1];
            [_CPDanWeiBtnArray removeObjectAtIndex:_flag - 1];
            [_DanjiaArray removeObjectAtIndex:_flag - 1];
            [_CPPiHaoArray removeObjectAtIndex:_flag - 1];
            //[_FHShuliangArray removeObjectAtIndex:_flag - 1];
            [_THShuliangrray removeObjectAtIndex:_flag - 1];
            [_THJineArray removeObjectAtIndex:_flag - 1];
            
            UIView *view = [_chanpinViewArray objectAtIndex:_flag - 1];
            [view removeFromSuperview];
            [_chanpinViewArray removeObjectAtIndex:_flag - 1];
            self.tuiHuoAddScrolview.contentSize = CGSizeMake(KscreenWidth, self.tuiHuoAddScrolview.contentSize.height - 375 );
            _flag -= 1;
        }

    }else if (alertView.tag == 1002){
        //点击确定提交申请
        if (buttonIndex == 1) {
            [self shenQinShangChuan];
            
            
            _showApply.userInteractionEnabled = NO;
        }
    }
   
}

//输入金额 计算总金额
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag != 102) {
         //计算金额
//        UITextField *danjia = [_DanjiaArray objectAtIndex:_flag - 1];
//        UITextField *shuliang = [_THShuliangrray objectAtIndex:_flag - 1];
//
//        double danJia = [danjia.text doubleValue];
//        double shumu = [shuliang.text doubleValue];
//        double jine = danJia * shumu;
//        NSString *tuiHuoJinE = [NSString stringWithFormat:@"%.2f",jine];
//        UILabel *tuihuojine = [_THJineArray objectAtIndex:_flag - 1];
//
//        tuihuojine.text = tuiHuoJinE;
//        _returnmoney = tuiHuoJinE;
        
        for (int i = 0; i < _flag; i++) {
            UITextField *danjia = [_DanjiaArray objectAtIndex:i];
            UITextField *shuliang = [_THShuliangrray objectAtIndex:_flag - 1];
            
            double danJia = [danjia.text doubleValue];
            double shumu = [shuliang.text doubleValue];
            double jine = danJia * shumu;
            NSString *tuiHuoJinE = [NSString stringWithFormat:@"%.2f",jine];
            UILabel *tuihuojine = [_THJineArray objectAtIndex:_flag - 1];
            
            tuihuojine.text = tuiHuoJinE;
            _returnmoney = tuiHuoJinE;
        }
        
    }
   
    
}


#pragma mark - 客户名称点击方法
- (void)m_keHuNameButtonClickMethod
{
    
        //客户名称 的浏览接口
    // NSURL *url =[NSURL URLWithString:@"http://182.92.96.58:8005/yrt/servlet/customer"];
    
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
    _custField.tag = 102;
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
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(getTHName) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.nameTableView == nil) {
        self.nameTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.nameTableView.backgroundColor = [UIColor whiteColor];
    }
    self.nameTableView.dataSource = self;
    self.nameTableView.delegate = self;
    self.nameTableView.tag = 101;
    self.nameTableView.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.nameTableView];
//    [self.view addSubview:self.m_keHuPopView];
    
    [self getTHName];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    
}
- (void)getTHName{

    NSString *custName = _custField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        if(array.count != 0){
            for (NSDictionary *dic in array) {
                KHnameModel *model = [[KHnameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.nameTableView reloadData];
        }

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [self showAlert:@"搜索客户名称加载失败"];
    }];
    
}

#pragma mark - 客户名称请求方法
- (void)nameRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        if(array.count != 0){
            for (NSDictionary *dic in array) {
                KHnameModel *model = [[KHnameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.nameTableView reloadData];
        }

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [self showAlert:@"客户名称加载失败"];
    }];
    
    
}

- (void)upRefresh
{
    _page++;
    [self nameRequest];
    
}
- (void)upRefresh1{
    _page1++;
    [self proRequest];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.tag == 101) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh];
        }
    }else if (scrollView.tag == 102){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh1];
        }
    }
    
}

- (void)closePop
{
    [self.m_keHuPopView removeFromSuperview];

}
#pragma mark  业务员
- (void)salerRequest{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipalByCust",@"params":[NSString stringWithFormat:@"{\"custidEQ\":\"%@\"}",self.keHuID]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if (array.count != 0) {
            self.m_yeWuYuan.text = array[0][@"name"];
            _saler = array[0][@"name"];
            _salerId = array[0][@"id"];
        }

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
}

#pragma mark - 产品单位
- (void)UnitAction{
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.UnitTableView == nil) {
        self.UnitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.UnitTableView.backgroundColor = [UIColor grayColor];
    }
    self.UnitTableView.dataSource = self;
    self.UnitTableView.delegate = self;
    self.UnitTableView.rowHeight = 45;
    [bgView addSubview:self.UnitTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.UnitTableView reloadData];
    

}


#pragma mark - 产品信息请求
- (void)m_chanPinMingChenButtonClickMethod
{
    
    /*
     退货申请  产品名称
     http://182.92.96.58:8005/yrt/servlet/goodsreturn
     rows	10
     mobile	true
     page	1
     action	getShipments
     params	{"custidEQ":"1357","shipnoEQ":"","pronameLIKE":""}
     table	fhxx
     */
    //产品名称－－的接口
    NSString *cust = _custNamebButton.titleLabel.text;
    if ([cust isEqualToString:@"请选择客户"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户再操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
//        self.m_keHuPopView.backgroundColor = [UIColor grayColor];
        self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        //
        _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
        _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
        [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
        [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
        _proField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
        _proField.backgroundColor = [UIColor whiteColor];
        _proField.delegate = self;
        
        _proField.placeholder = @"名称关键字";
        _proField.borderStyle = UITextBorderStyleRoundedRect;
        _proField.font = [UIFont systemFontOfSize:13];
        [self.m_keHuPopView addSubview:_proField];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"搜索" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        btn.frame = CGRectMake(_proField.right, 40, 60, 40);
        [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [btn.layer setBorderWidth:0.5]; //边框宽度
        [btn addTarget:self action:@selector(getPro) forControlEvents:UIControlEventTouchUpInside];
        [self.m_keHuPopView addSubview:btn];
        
        if (self.proTableView == nil) {
            self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
            self.proTableView.backgroundColor = [UIColor whiteColor];
        }
        self.proTableView.dataSource = self;
        self.proTableView.delegate = self;
        self.proTableView.tag = 102;
        self.proTableView.rowHeight = 80;
        [self.m_keHuPopView addSubview:self.proTableView];
//        [self.view addSubview:self.m_keHuPopView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
        [self proRequest];
    }
}
- (void)getPro{
    /*
     easyui
     action=proComboGrid
    params:{\"proname\":\"\"}");
     
     order
     action=fuzzyQuery
     table=cpxx
     page=1
     rows=100
     isgoodreturn=true
     params:{"proname":"j"}
     */
    
    NSString *proName = _proField.text;
    proName = [self convertNull:proName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/easyui?action=proComboGrid"];
    NSDictionary *params = @{@"action":@"proComboGrid",@"table":@"fhxx",@"q":[NSString stringWithFormat:@"%@",proName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"搜索上传%@",params);
        NSLog(@"产品信息搜索返回:%@",dic);
        [_CPdataArray removeAllObjects];
        for (NSDictionary *dic1 in dic) {
            THCPModel *model = [[THCPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [_CPdataArray addObject:model];
        }
        [self.proTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
          NSLog(@"产品搜索加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
    
}
- (void)proRequest{
    //退货产品接口
    /*
     /easyui
     action=proComboGrid
     table=fhxx
     page=1
     rows=20
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/easyui?action=proComboGrid"];
    NSDictionary *params = @{@"action":@"proComboGrid",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page1],@"table":@"fhxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"退货的产品名称%@",dic);
       
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                THCPModel *model = [[THCPModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_CPdataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
        

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"产品加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];

}
#pragma mark - 单位价格
- (void)getPriceOFUnit
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary  *params = @{@"action":@"getPriceByUnit",@"params":[NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"unitid\":\"%@\"}",_custId,_proid,_prounitId]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"单位加载%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            NSString *price = [NSString stringWithFormat:@"%@",dic[@"saleprice"]];
            UILabel *danjiaLabel = [_DanjiaArray objectAtIndex:_flag-1];
            danjiaLabel.text = price;
            
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.nameTableView) {
        return _dataArray.count;
    } else if(tableView == self.proTableView){
        return _CPdataArray.count;
    }else if (tableView == self.UnitTableView){
        return _unitArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    THCpInfoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = (THCpInfoCell *)[[[NSBundle mainBundle]loadNibNamed:@"THCpInfoCell" owner:self options:nil]firstObject] ;
        cell1.backgroundColor = [UIColor whiteColor];
    }
    CustCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    if (tableView == self.nameTableView ) {
        
        cell2.model = _dataArray[indexPath.row];
        return cell2;
    } else if(tableView == self.proTableView){
        
        if (_CPdataArray.count != 0) {
            cell1.model = _CPdataArray[indexPath.row];
        }
        
        return cell1;
    }else if (tableView == self.UnitTableView){
        
        DWandLXModel *model = _unitArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
        
    }
    return cell;
}
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.nameTableView) {
        
        
        [self.m_keHuPopView removeFromSuperview];
        _custNamebButton.userInteractionEnabled = YES;
        KHnameModel *model = _dataArray[indexPath.row];
        [_custNamebButton setTitle:model.name forState:UIControlStateNormal];
        self.keHuID = model.Id;
        _custId = model.Id;
        _cust = model.name;
        [self salerRequest];
        [self proRequest];
        
    } else if(tableView == self.proTableView) {
        [self.m_keHuPopView removeFromSuperview];
        UITextField *shuliang = [_THShuliangrray objectAtIndex:_flag - 1];
        UIButton *cpname = [_CPNameBtnArray objectAtIndex:_flag - 1];
        UILabel *chanpinbianma = [_FHBianMaArray objectAtIndex:_flag - 1];
        UILabel *chanpinguige = [_CPGuigeArray objectAtIndex:_flag - 1];
        UIButton *chanpindanwei = [_CPDanWeiBtnArray objectAtIndex:_flag - 1];
        UITextField *danjia = [_DanjiaArray objectAtIndex:_flag - 1];
       // UITextField *pihao = [_CPPiHaoArray objectAtIndex:_flag - 1];
        UILabel *cpID = [_CPIdArray objectAtIndex:_flag -1];
        UILabel *cpdanweiId = [_CPDanWeiIDArray objectAtIndex:_flag - 1];
        UILabel *jinE = [_THJineArray objectAtIndex:_flag - 1];
//        cpname.titleLabel.font = [UIFont systemFontOfSize:14];
        
        //
        
        THCPModel *model = _CPdataArray[indexPath.row];
        _unitArray = [NSMutableArray array];
        DWandLXModel *model1 = [[DWandLXModel alloc] init]; //主单位
        DWandLXModel *model2 = [[DWandLXModel alloc] init]; //副单位E
        model1.name = model.mainunitname;
        model1.Id = model.mainunit;
        model2.name = model.secondunitname;
        model2.Id = model.secondunit;
        [_unitArray addObject:model1];
        [_unitArray addObject:model2];
        
         [cpname setTitle:model.proname forState:UIControlStateNormal];
        chanpinbianma.text = [NSString stringWithFormat:@"%@",model.prono];
        NSLog(@"产品编码%@",model.prono);
        chanpinguige.text = model.specification;
        [chanpindanwei setTitle:model.mainunitname forState:UIControlStateNormal];
        danjia.text = [NSString stringWithFormat:@"%@",model.saleprice];
        cpID.text = [NSString stringWithFormat:@"%@",model.Id];
        cpdanweiId.text  = [NSString stringWithFormat:@"%@",model.mainunit];
        _proid = model.Id;
        
        double count = [shuliang.text doubleValue];
        double price = [danjia.text doubleValue];
        double money = price*count;
        jinE.text = [NSString stringWithFormat:@"%.2f",money];
        
    }else if (tableView == self.UnitTableView){
        [self.m_keHuPopView removeFromSuperview];
        DWandLXModel *model = _unitArray[indexPath.row];
        UIButton *btn = _CPDanWeiBtnArray[_flag - 1];
        [btn setTitle:model.name forState:UIControlStateNormal];
        UILabel *danweiID = _CPDanWeiIDArray[_flag - 1];
        danweiID.text = [NSString stringWithFormat:@"%@",model.Id];
        _prounitId = model.Id;
        NSLog(@"单位ID%@",model.Id);
        [self getPriceOFUnit];
    
    }
}

- (void)addNext{

//    http://182.92.96.58:8005/yrt/servlet/goodsreturn
//    SP	true
//    table:"thxx"
//    action	addReturnByCust
//data:"{"table":"thxx","salesmoney":"57","custid":"1705","custname":"导入客户测试","salerid":"129","saler":"苏雷","returnreason":"测试退货原因","thmxList":[{"table":"thmx","proid":"46","proname":"阿莫西林","procount":"2","specification":"25kg/桶","prono":"P201410280003","prounitname":"箱","prounitid":"176","singleprice":"12","goodsmoney":"24","probatch":"111222"},{"table":"thmx","proid":"45","proname":"氨苄青霉素","procount":"3","specification":"10片/袋","prono":"P201410280002","prounitname":"箱","prounitid":"176","singleprice":"11","goodsmoney":"33","probatch":"222111"}]}"
//  退货申请
    
    if (_custNamebButton.titleLabel.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户之后再操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *reason = _tuiHuoYuanYin1.text;
    if(reason.length == 0){
        
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退货原因未填写!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [tan show];
        return;
    }
    if (_chanpinOKFlag == 1) {
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_CPNameBtnArray objectAtIndex:i];
            proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
            UITextField * piciTF = [_CPPiHaoArray objectAtIndex:i];
            NSString * pici = piciTF.text;
            pici = [self replaceChar:pici];
            UITextField * ctTf = [_THShuliangrray objectAtIndex:i];
            NSString * count = ctTf.text;
            count = [self replaceChar:count];
            if ([proname isEqualToString:@"请选择产品"]) {
                [self showAlert:@"请选择产品"];
                return;
            }
            if ([pici isEqualToString:@""]) {
                [self showAlert:@"请填写批次"];
                return;
            }
            if ([count isEqualToString:@""]){
                [self showAlert:@"数量不可为空"];
                return;
            }
            
        }
        
    }
    
    

    _showOrder.userInteractionEnabled = NO; //禁止点击事件防止多次点击
    
    _showApply  = [[UIAlertView alloc] initWithTitle:@"提示"
                                             message:@"是否提交此退货申请"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                                   otherButtonTitles:@"确定", nil];
    _showApply.tag = 1002;
    [_showApply show];
    

}

- (void)shenQinShangChuan{

   
    
   [self sureComit];
    
    

}
-(void)sureComit{
    //计算总金额
    NSString *salesmoney;
    double n = 0;
    for (UILabel *label in _THJineArray) {
        NSString *m = label.text;
        
        n  = n + [m doubleValue];
    }
    salesmoney = [NSString stringWithFormat:@"%.2f",n];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn"];
    NSURL *url =[NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *cpStr = [NSMutableString stringWithFormat:@"SP=true&action=addReturnByCust&table=sto_goods_return&data={\"table\":\"thxx\",\"salesmoney\":\"%@\",\"custid\":\"%@\",\"custname\":\"%@\",\"salerid\":\"%@\",\"saler\":\"%@\",\"returnreason\":\"%@\",}",salesmoney,_custId,_cust,_salerId,_saler,_tuiHuoYuanYin1.text];
    
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"thmxList\":[]"];
    
    for (int i = 0; i < _flag; i++) {
        
        UIButton *cpname = [_CPNameBtnArray objectAtIndex:i]; //名称
        UILabel *chanpinbianma = [_FHBianMaArray objectAtIndex:i];//产品编码
        UILabel *chanpinguige = [_CPGuigeArray objectAtIndex:i]; //规格
        UIButton *chanpindanwei = [_CPDanWeiBtnArray objectAtIndex:i];//单位
        UITextField *danjia = [_DanjiaArray objectAtIndex:i];// 单价
        UILabel *chanpinpihao = [_CPPiHaoArray objectAtIndex:i];// 批号
        
        UILabel *tuihuojine = [_THJineArray objectAtIndex:i];// 退货金额
        UITextField *tuihuoshuliang = [_THShuliangrray objectAtIndex:i];// 数量
        UILabel *danweiId = [_CPDanWeiIDArray objectAtIndex:i];
        UILabel *cpID = [_CPIdArray objectAtIndex:i];// 产品ID
        NSString *proname = cpname.titleLabel.text;
        proname = [self replaceChar:proname];
        
        [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"thmx\",\"proid\":\"%@\",\"proname\":\"%@\",\"procount\":\"%@\",\"specification\":\"%@\",\"prono\":\"%@\",\"prounitname\":\"%@\",\"prounitid\":\"%@\",\"singleprice\":\"%@\",\"goodsmoney\":\"%@\",\"probatch\":\"%@\"},",cpID.text,proname,tuihuoshuliang.text,chanpinguige.text,chanpinbianma.text,chanpindanwei.titleLabel.text,danweiId.text,danjia.text,tuihuojine.text,chanpinpihao.text] atIndex:chanpinStr.length - 1];
    }
    
    [chanpinStr deleteCharactersInRange:NSMakeRange(chanpinStr.length - 2, 1)];
    
    [cpStr insertString:[NSString stringWithFormat:@"%@",chanpinStr] atIndex:cpStr.length-1];
    
    NSLog(@"添加退货字符串:%@",cpStr);
    
    NSData *data = [cpStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"添加退货返回字符串:%@",str1);
    
    if (str1.length != 0) {
        //判断是否掉线
        if ([str1 isEqualToString:@"sessionoutofdate"] ||[str1 isEqualToString:@"\"sessionoutofdate\""] ) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"添加返回数据%@",dic);
            NSString *status = dic[@"status"];
            if ([status isEqualToString:@"true"]) {
                _photoID = dic[@"id"];
                [self shangChuanTuPian];
            }else if ([status isEqualToString:@"false"]){
                
                [self showAlert:@"退货添加失败"];
                [_hud hide:YES];
            }
            
            
        }
        _showApply.userInteractionEnabled = YES;
        
    }
}
- (void)searchAction{
    NSLog(@"11");
}
#pragma mark － －－－－－－－－－－－－－－－拍照－－－－－－－－－－－－－－－－－－－－－－－－－－－
//拍照
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
    flowLayout.itemSize = CGSizeMake(45, 45);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(140, 138, KscreenWidth - 140, 45) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    [self.tuiHuoAddScrolview addSubview:collectionView];
    
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
    cameraVc.maxCount = 3;
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

//图片数据上传的方法
- (void)shangChuanTuPian{
    
  
    NSLog(@"相册数据%@",_images);
    NSLog(@"拍照数据%@",_assets);
    //客户名称
    NSString *custName =  _custNamebButton.titleLabel.text;
    custName = [self convertNull:custName];
    //当前时间
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDate =[dateFormatter stringFromDate:date];
    NSString *name = [NSString stringWithFormat:@"%@%@",custName,nowDate];
    //取得存储地理位置
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *place = [userDefault objectForKey:@"LocAdress"];
    place = [self convertNull:place];
    NSLog(@"定位位置%@",place);
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/Upload?action=add&tableName=sto_goods_return"];
    NSArray *array = _assets[0];
    if (array.count != 0) {
        id model = array[0];
        //相机拍照
        if ([model isKindOfClass:[ZLCamera class]]) {
            for (ZLCamera *model in array) {
                UIImage *image =  [UIImage imageWithContentsOfFile:model.imagePath];
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSDictionary *parameters = @{@"tableId":_photoID,@"mobile":@"true",@"action":@"add",@"filenote":@"",@"file":model.imagePath,@"photoename":name,@"place":place};
                //NSLog(@"字典%@",parameters);
                [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    
                    NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
                    NSData *imageData = UIImageJPEGRepresentation(image,0.4);
                    NSLog(@"拍照图片命名%@",fileName);
//                    UIImageJPEGRepresentation
                
                    [formData appendPartWithFileData:imageData
                                                name:name
                                            fileName:fileName
                                            mimeType:@"image/png"];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    if (str.length != 0) {
                        if ([str isEqualToString:@"sessionoutofdate"] ||[str isEqualToString:@"\"sessionoutofdate\""] ) {
                            //掉线自动登录
                            [self selfLogin];
                        }else{
                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            NSString *status = dic[@"status"];
                            NSLog(@"上传返回%@",str);
                            if ([status isEqualToString:@"true"]) {
                                [self showAlert:@"操作成功"];
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                [self showAlert:@"照片上传失败"];
                            }
                            [_hud removeFromSuperview];
                            
                        }

                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [_hud removeFromSuperview];
                }];
                
                
                
            }
            //读取相册
        }else if([model isKindOfClass:[ZLPhotoAssets class]]){
            
            
            for (ZLPhotoAssets *model in array) {
                UIImage *image =  [UIImage imageWithCGImage:[[model.asset defaultRepresentation] fullScreenImage]];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSDictionary *parameters = @{@"tableId":_photoID,@"photoename":name,@"place":place,@"mobile":@"true",@"action":@"add",@"filenote":@" ",@"file":@" "};
                //NSLog(@"字典%@",parameters);
                [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    
                    NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
                    NSData *imageData = UIImageJPEGRepresentation(image,0.4);
                    
                    NSLog(@"相册图片上传命名%@",fileName);
                    [formData appendPartWithFileData:imageData
                                                name:name
                                            fileName:fileName
                                            mimeType:@"image/png"];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    
                    if (str.length != 0) {
                        if ([str isEqualToString:@"sessionoutofdate"] ||[str isEqualToString:@"\"sessionoutofdate\""] ) {
                            //掉线自动登录
                            [self selfLogin];
                        }else{
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            NSString *status = dic[@"status"];
                            NSLog(@"上传返回%@",str);
                            if ([status isEqualToString:@"true"]) {
                                [self showAlert:@"操作成功"];
                                [self.navigationController popViewControllerAnimated:YES];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"newReturn" object:self];
                            }else{
                                [self showAlert:@"照片上传失败"];
                            }
                            [_hud removeFromSuperview];
                            
                        }

                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [_hud removeFromSuperview];
                }];
                
                
                
            }
            
            
        }
        
    }else if(array.count == 0 ){
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"请添加照片！"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确定", nil];
        
        [tan show];
    }
    
}



@end
