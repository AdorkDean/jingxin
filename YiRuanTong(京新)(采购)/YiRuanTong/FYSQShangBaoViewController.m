//
//  FYSQShangBaoViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FYSQShangBaoViewController.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#define LineColor  COLOR(240, 240, 240, 1);
@interface FYSQShangBaoViewController (){
    UIButton *_FYTypeButton;
    UILabel *_applyer;
    UITextField *_field1;
    UITextField *_field2;
    UITextField *_field3;
    NSMutableArray *_typeArray;
    NSMutableArray *_typeIdArray;
    MBProgressHUD *_hud;
    
    NSString *_accountId;
    NSString *_typeId;
    NSString *_type;
}
@property(nonatomic,retain) UIView *listBackView;
@property(nonatomic,retain)UIScrollView *sqScrollView;
@property(nonatomic,retain)UITableView *typeTableView;
@end

@implementation FYSQShangBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"费用申请";
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    _typeArray = [NSMutableArray array];
    _typeIdArray = [NSMutableArray array];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shangBao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    //
    [self initView];
    [self typeRequest];
    
}
- (void)initView{
    _sqScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    _sqScrollView.contentSize = CGSizeMake(KscreenWidth, 400);
    _sqScrollView.backgroundColor =  [UIColor clearColor];
    _sqScrollView.delegate = self;
    [self.view addSubview:_sqScrollView];
    

    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"申请人";
    label1.font =[UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentLeft;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = LineColor
    [self.sqScrollView addSubview:view1];
    [self.sqScrollView addSubview:label1];
    _applyer = [[UILabel alloc] initWithFrame:CGRectMake(91, 0, KscreenWidth - 90, 45)];
    _applyer.font = [UIFont systemFontOfSize:14];
    [self.sqScrollView addSubview:_applyer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString *Id = [userDefaults objectForKey:@"id"];
    _applyer.text = name;
    _accountId = Id;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"费用类型";
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentLeft;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom , KscreenWidth, 1)];
    view2.backgroundColor = LineColor;
    _FYTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _FYTypeButton.frame = CGRectMake(91, label1.bottom + 1, KscreenWidth - 90, 45);
    _FYTypeButton.backgroundColor = [UIColor whiteColor];
    _FYTypeButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_FYTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_FYTypeButton addTarget:self action:@selector(FYTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sqScrollView addSubview:label2];
    [self.sqScrollView addSubview:view2];
    [self.sqScrollView addSubview:_FYTypeButton];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"申请金额";
    label3.font =[UIFont systemFontOfSize:13];
    label3.textAlignment = NSTextAlignmentLeft;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
    view3.backgroundColor = LineColor;
    _field1 = [[UITextField alloc] initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 90, 45)];
    _field1.font = [UIFont systemFontOfSize:14];
    _field1.placeholder = @"请输入金额（必填）";
    _field1.keyboardType = UIKeyboardTypePhonePad;
    [self.sqScrollView addSubview:label3];
    [self.sqScrollView addSubview:view3];
    [self.sqScrollView addSubview:_field1];
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"申请原因";
    label4.font =[UIFont systemFontOfSize:13];
    label4.textAlignment = NSTextAlignmentLeft;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = LineColor;
    _field2 = [[UITextField alloc] initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 90, 45)];
    _field2.font = [UIFont systemFontOfSize:14];
    _field2.placeholder = @"请输入原因（必填）";
    [self.sqScrollView addSubview:label4];
    [self.sqScrollView addSubview:view4];
    [self.sqScrollView addSubview:_field2];
    
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"备注";
    label5.font =[UIFont systemFontOfSize:13];
    label5.textAlignment = NSTextAlignmentLeft;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom , KscreenWidth, 1)];
    view5.backgroundColor = LineColor;
    _field3 = [[UITextField alloc] initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 90, 45)];
    _field3.font = [UIFont systemFontOfSize:14];
    [self.sqScrollView addSubview:label5];
    [self.sqScrollView addSubview:view5];
    [self.sqScrollView addSubview:_field3];

}
- (void)FYTypeAction{
    _FYTypeButton.userInteractionEnabled = NO;
    
    self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(60, 60, KscreenWidth-120, KscreenHeight-144)];
    self.listBackView.backgroundColor = UIColorFromRGB(0x3cbaff);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_listBackView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closeback) forControlEvents:UIControlEventTouchUpInside];
    [self.listBackView addSubview:btn];
    if (self.typeTableView == nil) {
        self.typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.typeTableView.backgroundColor = [UIColor whiteColor];
    }
    self.typeTableView.dataSource = self;
    self.typeTableView.delegate = self;
    [self.listBackView addSubview:self.typeTableView];
    [self.view addSubview:self.listBackView];
    [self typeRequest];
    [self.typeTableView reloadData];
}
- (void)typeRequest
{   /*
     sysbase
     action:"getSelectType"
     type:"costtype"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getSelectType&type=costtype";
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (data1 != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        [_typeArray removeAllObjects];
        [_typeIdArray removeAllObjects];
        for (NSDictionary *dic  in array) {
            NSString *str = [dic objectForKeyedSubscript:@"name"];
            NSString *str1  = [dic objectForKeyedSubscript:@"id"];
            [_typeArray addObject:str];
            [_typeIdArray addObject:str1];
        }
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            NSString *type = [dic objectForKeyedSubscript:@"name"];
            NSString *ID = [dic objectForKeyedSubscript: @"id"];
            [_FYTypeButton setTitle:type forState:UIControlStateNormal];
            _type = type;
            _typeId = ID;
            NSLog(@"返回类型%@",array);
        }
        
    }else{
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    
    }
    

}
- (void)closeback{
    _FYTypeButton.userInteractionEnabled = YES;
    [self.typeTableView removeFromSuperview];
    [self.listBackView removeFromSuperview];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _typeArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_FYSQ";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    NSString *name = _typeArray[indexPath.row];
    cell.textLabel.text = name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.typeTableView) {
        NSString *name = _typeArray[indexPath.row];
        [_FYTypeButton setTitle:name forState:UIControlStateNormal];
        _typeId = _typeIdArray[indexPath.row];
        _type = name;
        _FYTypeButton.userInteractionEnabled = YES;
        [self.listBackView removeFromSuperview];
    }

}
- (void)shangBao{
/*
 costapply
 action:"add"
 table:"fysq"
 SP:"true"
 data:"{"table":"fysq","applyer":"胡云龙","applyerid":"168","costtypeid":"151","costtype":"住宿","applymoney":"166","applyaim":"测试借口","note":"测试"}"
 
 */
    NSString *applymoney = _field1.text;
    NSString *applyaim = _field2.text;
    
     if (_type.length == 0 ) {
         UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择费用类型" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [tan show];
     }else if(applymoney.length == 0){
         UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入申请金额" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [tan show];
     }else if (applyaim.length == 0){
         UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入申请原因" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [tan show];
     }
     else{
         NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=add"];
         NSURL *url =[NSURL URLWithString:urlStr];
         NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
         [request setHTTPMethod:@"POST"];
         NSString *str = [NSString stringWithFormat:@"table=fysq&SP=true&data={\"table\":\"fysq\",\"applyer\":\"%@\",\"applyerid\":\"%@\",\"costtypeid\":\"%@\",\"costtype\":\"%@\",\"applymoney\":\"%@\",\"applyaim\":\"%@\",\"note\":\"%@\"}",_applyer.text,_accountId,_typeId,_type,_field1.text,_field2.text,_field3.text];
         NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
         [request setHTTPBody:data];
         NSLog(@"上传字符串%@",str);
         NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
         NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
         NSLog(@"上传返回%@",str1);
         if (str1.length != 0) {
             NSRange range = {1,str1.length-2};
             NSString *reallystr = [str1 substringWithRange:range];
             if ([reallystr isEqualToString:@"true"]) {
                 _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 _hud.mode = MBProgressHUDModeText;
                 _hud.labelText = @"添加成功";
                 _hud.margin = 10.f;
                 _hud.yOffset = 150.f;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"FYShenQingListVCnewRefresh" object:self];
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
     
     
     }
    
}
    
@end
