//
//  LXRizhiManagerVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/5.
//  Copyright © 2018年 联祥. All rights reserved.
//



#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))





#import "LXRizhiManagerVC.h"
#import "LXRizhiManagerCell.h"
#import "WriteReportVC.h"
#import "ScanReportVC.h"
#import "TongjiVC.h"
@interface LXRizhiManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,strong) NSArray *leiXingDataArray;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *firstArr;
@property (nonatomic,strong) NSMutableArray *colorArr;
@property (nonatomic,strong) NSArray *imageArr;
@end

@implementation LXRizhiManagerVC
{
    UIView * _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"写日志";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArr = @[@"写日志",@"看日志",@"统计"];
    _imageArr = @[@"xielan",@"xiezhi",@"tongji"];
    
    NSArray *color = @[ssRGBHex(0x83CC2B),ssRGBHex(0xEE4B47),ssRGBHex(0xFF8040),ssRGBHex(0x3CC24C),ssRGBHex(0x69CFFA),ssRGBHex(0xF54E91),ssRGBHex(0xFF8040),ssRGBHex(0xFFDE5A),ssRGBHex(0x83CC2B),ssRGBHex(0x3CC24C)];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:color];
    _colorArr = [[NSMutableArray alloc] init];
    int i;
    int count = tempArray.count;
    for (i = 0; i < count; i ++) {
        int index = arc4random() % (count - i);
        [_colorArr addObject:[tempArray objectAtIndex:index]];
        NSLog(@"index:%d,xx:%@",index,[tempArray objectAtIndex:index]);
        [tempArray removeObjectAtIndex:index];
        
    }
    
    _leiXingDataArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBottomView];
    [self typeRequest];
    
}
-(void)createBottomView{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-64-50, KscreenWidth, 1)];
    line.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line];
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-64-50, KscreenWidth, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [self addButtonS];
    [self.view addSubview:self.tableView];
    
    
}
-(void)addButtonS
{
    for (int i = 0 ; i < 3; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        
        // 圆角按钮
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeCustom];
//        [aBt setTitle:_dataArr[i] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        [aBt addTarget:self action:@selector(jumpPageAction:) forControlEvents:UIControlEventTouchUpInside];
        aBt.tag = i+1000;
        [_bottomView addSubview:aBt];
    }
}
-(void)jumpPageAction:(UIButton *)sender{
    if (sender.tag == 1000) {
        
    }else if (sender.tag == 1001){
        ScanReportVC * vc = [[ScanReportVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        TongjiVC * vc = [[TongjiVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - 日志类型加载方法
- (void)typeRequest{
    
    NSString *strAdress = @"/dailyreport";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getTypeComBox";
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            NSLog(@"日志类型输出:%@",array);
            self.leiXingDataArray = array;
            _arr = [NSMutableArray  array];
            _firstArr = [NSMutableArray  array];
            for (int i = 0; i< array.count; i++) {
                NSString *str12 = array[i][@"name"];
                NSString *firstString = [str12 substringToIndex:1];
                [_arr addObject:str12];
                [_firstArr addObject:firstString];
            }
        }
        [self.tableView reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _firstArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"LXRizhiManagerCell";
    LXRizhiManagerCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil)
    {
        cell =(LXRizhiManagerCell*)[[[NSBundle mainBundle]loadNibNamed:@"LXRizhiManagerCell" owner:self options:nil]firstObject];
    }
    [cell.btn setTitle:self.firstArr[indexPath.row] forState:UIControlStateNormal];

    
    
    [cell.btn setBackgroundColor:_colorArr[indexPath.row]];
    
    cell.btn.layer.cornerRadius = 5.0f;
    cell.btn.layer.masksToBounds = YES;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",self.arr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WriteReportVC * vc = [[WriteReportVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
    NSString * idstr = [NSString stringWithFormat:@"%@",self.leiXingDataArray[indexPath.row][@"id"]];
    NSString * name = [NSString stringWithFormat:@"%@",self.leiXingDataArray[indexPath.row][@"name"]];
    vc.name = name;
    vc.nameID =  [idstr integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight-64-50) style:UITableViewStyleGrouped];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}
- (void)backButtonAction:(UIButton*)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
