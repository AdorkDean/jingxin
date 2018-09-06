//
//  ZDYSPShangBaoVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/5/19.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZDYSPShangBaoVC.h"
#import "TypeDetailModel.h"
#import "YeWuYuanModel.h"
#import "UIViewExt.h"
#import "ZiDingYiSPViewController.h"
#import "MBProgressHUD.h"
#import "IsNumberOrNot.h"

@interface ZDYSPShangBaoVC (){
    
    UIButton *_typeButton;
    UIButton *_classButton;
    NSMutableArray *_typeArray;
    NSMutableArray *_typeIDArray;
    NSMutableArray *_typeDetailArray;
    NSMutableArray *_dataArray2;  //业务员
    NSArray *_classArray;
    UIView *_detailBackView;
    UIView *_shenpirenView;
    NSString *_typeID;
    NSString *_classID;
    NSString *_currentDateStr;
    UIScrollView *_scrollView;
    int _spCount;
    NSInteger _Count;
    //审批人的个数
    NSMutableArray *_labelArray;
    NSMutableArray *_spButtonArray;
    NSMutableArray *_textArray;
    NSMutableArray *_accountArray;
    NSMutableArray *_accountIdArray;
    NSMutableArray *_deleteArray;
    NSMutableArray *_shenpirenLabelArray;
    NSMutableArray *_hengxinaArray;
    MBProgressHUD *_hud;
    UIButton* _hide_keHuPopViewBut;
}

@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *typeTableView;
@property(nonatomic,retain)UITableView *classTableView;
@property(nonatomic,retain)UITableView *salerTableView;

@end

@implementation ZDYSPShangBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"审批上报";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    _labelArray = [NSMutableArray array];
    _spButtonArray = [NSMutableArray array];
    _textArray = [[NSMutableArray alloc] init];
    _accountArray = [NSMutableArray array];
    _accountIdArray = [NSMutableArray array];
    _deleteArray = [[NSMutableArray alloc] init];
    _shenpirenLabelArray = [[NSMutableArray alloc] init];
    _hengxinaArray = [[NSMutableArray alloc] init];
    
    [self initView];
    
    [self typeRequest];
    [self typeDetailRequest];
    [self initDetailView];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    [_typeButton setTitle:@"请选择审批类型" forState:UIControlStateNormal];
    [_classButton setTitle:@"请选择审批流程"forState:UIControlStateNormal];
}

//页面设置

- (void)initView{
    
    UIButton *AddSpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AddSpButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddSpButton setTitle:@"上报" forState:UIControlStateNormal];
    [AddSpButton addTarget:self action:@selector(shangBao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddSpButton];
    self.navigationItem.rightBarButtonItem = right;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(KscreenWidth, KscreenHeight - 64);
    [self.view addSubview:_scrollView];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] ;
    label1.backgroundColor = COLOR(231, 231, 231, 1);
    label1.text = @"审批类型";
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:label1];
    _typeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _typeButton.frame = CGRectMake(110, 0, KscreenWidth - 110, 40);
    [_typeButton setTintColor:[UIColor blackColor]];
    _typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_typeButton addTarget:self action:@selector(typeAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_typeButton];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_scrollView addSubview:view1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 100, 40)];
    label2.backgroundColor = COLOR(231, 231, 231, 1);
    label2.text = @"审批流程";
    label2.font = [UIFont systemFontOfSize:14.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:label2];
    _classButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _classButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _classButton.frame = CGRectMake(110, 41, KscreenWidth - 110, 40);
    [_classButton setTintColor:[UIColor blackColor]];
    [_classButton addTarget:self action:@selector(classAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_classButton];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    view2.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_scrollView addSubview:view2];
}
- (void)typeAction{
    /*
     http://182.92.96.58:8005/yrt/servlet/spdefine
     action:"getSpDefineComBox"
     table:"shenpibt"
     */
    _typeButton.userInteractionEnabled = NO;
      self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor lightGrayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.typeTableView == nil) {
        self.typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.typeTableView.backgroundColor = [UIColor whiteColor];
    }
    self.typeTableView.dataSource = self;
    self.typeTableView.delegate = self;
    [bgView addSubview:self.typeTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.typeTableView reloadData];
}
- (void)typeRequest{
    _typeArray = [NSMutableArray array];
    _typeIDArray = [NSMutableArray array];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine"];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getSpDefineComBox&table=shenpibt";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"审批类型点击后返回:%@",array);
        for (NSDictionary *dic  in array) {
            NSString *str = [dic objectForKey:@"name"];
            NSString *str1 =  [dic objectForKey:@"id"];
            [_typeArray addObject:str];
            [_typeIDArray addObject:str1];
        }
        if (array.count != 0) {
            _typeID = array[0][@"id"];
            [_typeButton setTitle:array[0][@"name"] forState:UIControlStateNormal];
        }
    }
}

- (void)typeDetailRequest{
    /*
     spdefine
     action:"getTypeDetail"
     table:"shenpizdy"
     params:"{"idEQ":"77"}"
     */
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine"];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getTypeDetail&table=shenpizdy&params={\"idEQ\":\"%@\"}",_typeID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"上传字符串%@",str);
        NSLog(@"类型详情返回:%@",array);
        _typeDetailArray = [NSMutableArray array];
        for (NSDictionary *dic  in array) {
            TypeDetailModel *model = [[TypeDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_typeDetailArray addObject:model];
        }

    }
}

- (void)classAction{
    
    _classButton.userInteractionEnabled = NO;
    _classArray = @[@"预定义审批",@"自定义审批"];
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor lightGrayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 344)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.classTableView == nil) {
        self.classTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-374) style:UITableViewStylePlain];
    }
    self.classTableView.dataSource = self;
    self.classTableView.delegate = self;
    [bgView addSubview:self.classTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.classTableView reloadData];
}

- (void)closePop
{
    _typeButton.userInteractionEnabled = YES;
    _classButton.userInteractionEnabled = YES;
    [self.m_keHuPopView removeFromSuperview];
}
#pragma mark - 预定义审批的方法
- (void)initDetailView {
    
    [_textArray removeAllObjects];
    NSInteger count = _typeDetailArray.count;
    _detailBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 82, KscreenWidth, 41*count+20)];
    for (int i = 0; i<count; i++) {
        //显示label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 41*i , 100, 40)];
        label.backgroundColor = COLOR(231, 231, 231, 1);
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_detailBackView addSubview:label];
        TypeDetailModel *model = _typeDetailArray[i];
        label.text = model.name;
        [_labelArray addObject:label];
        //输入框
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(110, 41*i , KscreenWidth - 115, 40)];
        text.delegate = self;
        text.font = [UIFont systemFontOfSize:14.0];
        [_detailBackView addSubview:text];
        [_textArray addObject:text];
        //横线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1), KscreenWidth, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [_detailBackView addSubview:view];
    }
    [_scrollView addSubview:_detailBackView];
}

#pragma mark - 自定义审批的方法
- (void)initDetailView1{
    
    
    _shenpirenView = [[UIView alloc] initWithFrame:CGRectMake(0, 82, KscreenWidth,41)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2 - 50, 0, 100, 40)];
    titleLabel.text = @"审批人";
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    [_shenpirenView addSubview:titleLabel];
    
    //添加按钮
    UIButton  *ADDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ADDButton.frame = CGRectMake(KscreenWidth - 40, 0, 40, 40);
    [ADDButton setBackgroundColor:[UIColor whiteColor]];
    [ADDButton setTitle:@"+" forState:UIControlStateNormal];
    ADDButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [ADDButton setTitleColor:COLOR(102, 199, 250, 1) forState:UIControlStateNormal];
    [ADDButton addTarget:self action:@selector(ADD) forControlEvents:UIControlEventTouchUpInside];
    [_shenpirenView addSubview:ADDButton];
    
    [self zidingyiDetailViewLoad];
    [_scrollView addSubview:_shenpirenView];
}

- (void)zidingyiDetailViewLoad
{
     NSInteger count = _typeDetailArray.count;
    
    _detailBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _shenpirenView.bottom +10, KscreenWidth, 40*count)];
    NSArray *arr = [[NSArray alloc]initWithArray:_textArray];
    [_textArray removeAllObjects];
    //详情页面
    for (int i = 0; i < count; i++) {
        //显示label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 41*i+1,100, 40)];
        label.backgroundColor = COLOR(231, 231, 231, 1);
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_detailBackView addSubview:label];
        TypeDetailModel *model = _typeDetailArray[i];
        label.text = model.name;
        [_labelArray addObject:label];
        
        //输入框
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(110,41*i*1,KscreenWidth-115,40)];
        text.delegate = self;
        text.font = [UIFont systemFontOfSize:14.0];
        [_detailBackView addSubview:text];
        [_textArray addObject:text];
        if (arr.count) {
            UITextField *text1 = arr[i];
            text.text = text1.text;
        }
        //横线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1)+1, KscreenWidth, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [_detailBackView addSubview:view];
    }
    [_scrollView addSubview:_detailBackView];
}

#pragma mark - 审批人添加删除

- (void)ADD{
    [_accountArray addObject:@""];
    [_accountIdArray addObject:@""];
    
    [_detailBackView removeFromSuperview];
    _shenpirenView.frame = CGRectMake(0, 82, KscreenWidth, 41 + _shenpirenView.frame.size.height);
    //审批人
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 41*(_spCount+1), 100, 41)];
    label.backgroundColor = COLOR(231, 231, 231, 1);
    label.text = @"审批人";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    [_shenpirenLabelArray addObject:label];
    
    //审批人按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(101, 41*(_spCount+1), KscreenWidth - 150, 40);
    button1.tag = _spCount;
    [button1 setTintColor:[UIColor blackColor]];
    [button1 addTarget:self action:@selector(spAction:) forControlEvents:UIControlEventTouchUpInside];
    [_spButtonArray addObject:button1];
    
    //删除按钮
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(KscreenWidth - 35, 41 * (_spCount+1),35, 35);
    [button2 setBackgroundColor:[UIColor whiteColor]];
    [button2 setTitle:@"x" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:23];
    [button2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(DeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = _spCount+100;
    [_deleteArray addObject:button2];
    
    [_shenpirenView addSubview:label];
    [_shenpirenView addSubview:button1];
    [_shenpirenView addSubview:button2];
    
    //横线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,40+41 * (_spCount+1), KscreenWidth, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [_shenpirenView addSubview:view];
    [_hengxinaArray addObject:view];
    [_detailBackView removeFromSuperview];
    [self zidingyiDetailViewLoad];
    _spCount = _spCount + 1;
}

- (void)spAction:(UIButton *)sender{
    _Count = sender.tag;
    //审批人
    _dataArray2 = [NSMutableArray array];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getPrincipals&table=yhzh";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"业务员点击后返回:%@",array);
        for (NSDictionary *dic in array) {
            YeWuYuanModel *model = [[YeWuYuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray2 addObject:model];
        }

    }
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor lightGrayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.salerTableView == nil) {
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    [bgView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.salerTableView reloadData];
}

- (void)DeleteAction:(UIButton *)btn{
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_spButtonArray];
    UIButton *btn11 = [arr objectAtIndex:btn.tag-100];
    [arr removeObject:btn11];
    
    [_accountArray removeObjectAtIndex:btn.tag-100];
    [_accountIdArray removeObjectAtIndex:btn.tag-100];
    
    UILabel *label = [_shenpirenLabelArray objectAtIndex:_spCount-1];
    [label removeFromSuperview];
    [_shenpirenLabelArray removeObject:label];
    UIButton *btn1 = [_spButtonArray objectAtIndex:_spCount-1];
    [btn1 removeFromSuperview];
    [_spButtonArray removeObject:btn1];
    UIButton *btn2 = [_deleteArray objectAtIndex:_spCount-1];
    [btn2 removeFromSuperview];
    [_deleteArray removeObject:btn2];
    UIView *view = [_hengxinaArray objectAtIndex:_spCount - 1];
    [view removeFromSuperview];
    [_hengxinaArray removeObject:view];
    _spCount--;
    _shenpirenView.frame = CGRectMake(0, 82, KscreenWidth, _shenpirenView.frame.size.height - 41);
    [_detailBackView removeFromSuperview];
    [self zidingyiDetailViewLoad];
    
    for (int i=0; i<_spButtonArray.count; i++) {
        UIButton *but =  arr[i];
        UIButton *but1 =  _spButtonArray[i];
        NSLog(@"%@ %@",but.titleLabel.text,but1.titleLabel.text);
        [but1 setTitle:but.titleLabel.text forState:UIControlStateNormal];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.typeTableView) {
        return _typeArray.count;
    } else if(tableView == self.classTableView){
        return _classArray.count;
    } else {
        return _dataArray2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell_1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (tableView == self.typeTableView) {
        cell.textLabel.text = _typeArray[indexPath.row];
        return cell;
    }else if(tableView == self.classTableView){
        NSString *type = _classArray[indexPath.row];
        cell.textLabel.text = type;
        return cell;
    }else if(tableView == self.salerTableView){
        YeWuYuanModel *model = _dataArray2[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.typeTableView) {
        
        if (_spCount > 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先关闭审批人选择框!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
        
        [_accountIdArray removeAllObjects];
        [_accountArray removeAllObjects];
        [_labelArray removeAllObjects];
        [_spButtonArray removeAllObjects];
        
        NSString *name = _typeArray[indexPath.row];
        [_typeButton setTitle:name forState:UIControlStateNormal];
        _typeID = _typeIDArray[indexPath.row];
        NSString *title = _classButton.titleLabel.text;
        if ([title isEqualToString:@"自定义审批"]) {
          
            [_shenpirenView removeFromSuperview];
            [_detailBackView removeFromSuperview];
            [self typeDetailRequest];
            [self initDetailView1];
            
        } else if([title isEqualToString:@"预定义审批"]){
           
            [_detailBackView removeFromSuperview];
            [self typeDetailRequest];
            [self initDetailView];
        }
        }
        _typeButton.userInteractionEnabled = YES;
        
    } else if(tableView == self.classTableView){
        
        [_accountIdArray removeAllObjects];
        [_accountArray removeAllObjects];
        [_labelArray removeAllObjects];
        [_spButtonArray removeAllObjects];
        
        NSString *type = _classArray[indexPath.row];
        [_classButton setTitle:type forState:UIControlStateNormal];
        if( [type isEqualToString:@"自定义审批"]){
            
            [_detailBackView removeFromSuperview];
            [self typeDetailRequest];
            [self initDetailView1];
        } else if ([type isEqualToString:@"预定义审批"]){
           
            [_shenpirenView removeFromSuperview];
            [_detailBackView removeFromSuperview];
            [self typeDetailRequest];
            [self initDetailView];
        }
        _classButton.userInteractionEnabled = YES;
    } else if(tableView == self.salerTableView){
        
        YeWuYuanModel *model = _dataArray2[indexPath.row];
        UIButton *btn = [_spButtonArray objectAtIndex:_Count];
        [btn setTitle:model.name forState:UIControlStateNormal];
//        [_accountArray addObject:model.name];
//        [_accountIdArray addObject:model.Id];
        [_accountArray replaceObjectAtIndex:btn.tag withObject:model.name];
        [_accountIdArray replaceObjectAtIndex:btn.tag withObject:model.Id];
    }
    [self.m_keHuPopView removeFromSuperview];
}

- (void)shangBao{
    
    NSString *classt = _typeButton.titleLabel.text;
    if ([classt isEqualToString:@"请选择审批类型"]) {
        [self showAlert:@"请选择审批类型"];
        return;
    }
    NSString *classtp = _classButton.titleLabel.text;
    if ([classtp isEqualToString:@"请选择审批流程"]) {
        [self showAlert:@"请选择审批流程"];
        return;
    }
    NSString *class = _classButton.titleLabel.text;
    if ([class isEqualToString:@"预定义审批"]) {
        [self shangbao1];
    } else if([class isEqualToString:@"自定义审批"]){
        [self shangbao2];
    }
}

- (void)shangbao1{
    //预定义的方法
    /*
     spdefine
     action:"addSpSelfDefine"
     table:"shenpizdy"
     data:"{"table":"shenpizdy","sptypeid":"53","sptypename":"请假流程","spchoose":"0","createtime":"2015-5-19","shenpizdymxList":[{"table":"shenpizdymx","sptitleid":"30","sptitle":"请假申请","spcontent":"测试测试测试测试测试测试测试测试"},{"table":"shenpizdymx","sptitleid":"33","sptitle":"请假时间","spcontent":"11212121212121"}]}"
     */
    
    for (int i = 0; i<_typeDetailArray.count; i++) {
        UITextField *text = _textArray[i];
        if (text.text.length == 0) {
            [self showAlert:@"请填写内容"];
            return;
        }
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine"];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSMutableString *str = [NSMutableString stringWithFormat:@"action=addSpSelfDefine&table=shenpizdy&data={\"table\":\"shenpizdy\",\"sptypeid\":\"%@\",\"sptypename\":\"%@\",\"spchoose\":\"0\",\"createtime\":\"%@\",\"shenpizdymxList\":[]}",_typeID,_typeButton.titleLabel.text,_currentDateStr];
    for (int i = 0; i<_typeDetailArray.count; i++) {
        UILabel *label = _labelArray[i];
        UITextField *text = _textArray[i];
        TypeDetailModel *model = _typeDetailArray[i];
        [str insertString:[NSString stringWithFormat:@"{\"table\":\"shenpizdymx\",\"sptitleid\":\"%@\",\"sptitle\":\"%@\",\"spcontent\":\"%@\"},",model.Id,label.text,text.text] atIndex:str.length-2];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length - 3, 1)];
    NSLog(@"预定义上传字符串%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"上报返回%@",dic);
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)shangbao2
{
    //自定义的方法
    /*
     data:"{"table":"shenpizdy","sptypeid":"53","sptypename":"请假流程","spchoose":"1","createtime":"2015-5-20",
        "shenpizdymxList":[{"table":"shenpizdymx","sptitleid":"30","sptitle":"请假申请","spcontent":"1122231313131"},                    {"table":"shenpizdymx","sptitleid":"33","sptitle":"请假时间","spcontent":"2131313131313131311"}],
        "spzdyList":[{"table":"spzdy","sprank":"0","spaccountid":"126","spaccountname":"张宝英"}]}"
     */
//    for (int i = 0; i<_spCount; i++) {
//        NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        UITableViewCell * cell = [self.salerTableView cellForRowAtIndexPath:indexPath];
        
//    }
    for (int i = 0; i<_typeDetailArray.count; i++) {
        UITextField *text = _textArray[i];
        if (text.text.length == 0) {
            [self showAlert:@"请填写内容"];
            return;
        }
    }
    if (_spButtonArray.count != 0) {
         //= [_spButtonArray objectAtIndex:_spCount-1];
        for (UIButton *btn1 in _spButtonArray) {
            if (btn1.titleLabel.text.length == 0) {
                [self showAlert:@"请添加相应的审批人"];
                return;
            }
        }
        
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/spdefine"];
        NSURL *url = [NSURL URLWithString:urlstr];
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSMutableString *str = [NSMutableString stringWithFormat:@"action=addSpSelfDefine&table=shenpizdy&data={\"table\":\"shenpizdy\",\"sptypeid\":\"%@\",\"sptypename\":\"%@\",\"spchoose\":\"1\",\"createtime\":\"%@\",\"shenpizdymxList\":[],\"spzdyList\":[]}",_typeID,_typeButton.titleLabel.text,_currentDateStr];
        
        NSLog(@"输入框数组的个数:%zi",_textArray.count);
        
        for (int i = 0; i < _typeDetailArray.count; i++) {
            UILabel *label = _labelArray[i];
            UITextField *text = _textArray[i];
            TypeDetailModel *model = _typeDetailArray[i];
            [str insertString:[NSString stringWithFormat:@"{\"table\":\"shenpizdymx\",\"sptitleid\":\"%@\",\"sptitle\":\"%@\",\"spcontent\":\"%@\"},",model.Id,label.text,text.text] atIndex:str.length-17];
        }
        if (_typeDetailArray.count) {
            [str deleteCharactersInRange:NSMakeRange(str.length - 18, 1)];
        }
        
        if(_accountArray.count > 0){
            for (int i = 0; i < _spCount; i++) {
                NSString *ID = _accountIdArray[i];
                NSString *name = _accountArray[i];
                [str insertString:[NSString stringWithFormat:@"{\"table\":\"spzdy\",\"sprank\":\"%@\",\"spaccountid\":\"%@\",\"spaccountname\":\"%@\"},",[NSString stringWithFormat:@"%zi",i],ID,name] atIndex:str.length - 2];
            }
            [str deleteCharactersInRange:NSMakeRange(str.length - 3, 1)];
        }
        NSLog(@"自定义上传字符串%@",str);
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"上报返回%@",dic);
        
        NSString  *str1  = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"上报返回%@",str1);
        if (str1.length != 0) {
            NSRange range = {1,str1.length-2};
            NSString *reallystr = [str1 substringWithRange:range];
            if ([IsNumberOrNot isAllNum:reallystr]&&![reallystr isEqualToString:@""]) {
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"添加成功";
                _hud.margin = 10.f;
                _hud.yOffset = 150.f;
                [_hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [_hud removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
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

    }else if(_spButtonArray.count == 0){
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"请添加审批人！"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确定", nil];
        [tan show];
    }
    
}
@end
