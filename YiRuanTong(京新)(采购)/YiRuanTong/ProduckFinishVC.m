//
//  ProduckFinishVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProduckFinishVC.h"
#import "UIViewExt.h"
#import "ProFinishCell.h"
#import "DataPost.h"
#import "ProFinishModel.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface ProduckFinishVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tbView;
@property (nonatomic,strong)NSMutableArray * resultData;

@end

@implementation ProduckFinishVC
{
    UIView* _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生产领料详情";
    self.navigationItem.rightBarButtonItem = nil;
    _resultData = [[NSMutableArray alloc]init];
    [self initScrollView];
    [self dataRequest];
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
//        if (detailLabel.tag != 106) {
//            detailLabel.userInteractionEnabled = NO;
//        }
        detailLabel.userInteractionEnabled = NO;
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
-(void)dataRequest{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getSODetailBeans",@"params":[NSString stringWithFormat:@"{\"bomnoEQ\":\"%@\"}",self.model.bomno]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in  arr) {
            ProFinishModel *model = [[ProFinishModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_resultData addObject:model];
        }
        _tbView.frame = CGRectMake(0, _headerView.bottom, KscreenWidth, 370*_resultData.count+10);
        self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, _headerView.bottom+370*_resultData.count+10);
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
    //    else if(tableView == self.cgpeopleTable){
    //        return _cgpeopleArr.count;
    //    }else if (tableView == self.orderNoTable){
    //        return _orderNoArray.count;
    //    }
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
        return 370;
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
    
    ProFinishCell* procell = [tableView dequeueReusableCellWithIdentifier:@"ProFinishCell"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"ProFinishCell" owner:self options:nil]firstObject];
    }
    if ([self.model.flag integerValue] != 1&&[self.model.isstockout integerValue] == 2) {
        procell.delBtn.hidden = YES;
        
    }
//    [procell setDelBtnBlock:^{
//        [_resultData removeObjectAtIndex:indexPath.row];
//        [_tbView beginUpdates];
//        [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [_tbView endUpdates];
//        self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, _headerView.bottom+280*_resultData.count+10);
//        [_tbView reloadData];
//    }];
    if (tableView == _tbView) {
        if (_resultData.count!=0) {
            procell.model = _resultData[indexPath.row];
            procell.count = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
            NSLog(@"procell.count%@",procell.count);
        }
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        return procell;
    }
    //    else if (tableView == self.orderNoTable){
    //
    //        cell.textLabel.text = _orderNoArray[indexPath.row];
    //        return cell;
    //
    //    }else if (tableView == self.cgpeopleTable){
    //        cell.textLabel.text = _cgpeopleArr[indexPath.row];
    //        return cell;
    //    }
    //
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
