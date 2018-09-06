//
//  ProductMateriaDetailVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProductMateriaDetailVC.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "ProFinishModel.h"
#import "ProgressingCell.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface ProductMateriaDetailVC ()
@property (nonatomic,strong)UITableView * tbView;
@property (nonatomic,strong)NSMutableArray * resultData;
@end

@implementation ProductMateriaDetailVC
{
    UIView* _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生产领料详情";
    self.navigationItem.rightBarButtonItem = nil;
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
//    UIButton * surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    surebtn.frame =CGRectMake(30, _headerView.bottom-70, (KscreenWidth-90)/2, 40);
//    [surebtn setTitle:@"确定" forState:UIControlStateNormal];
//    surebtn.layer.cornerRadius = 5.f;
//    surebtn.layer.masksToBounds = YES;
//    [surebtn setBackgroundColor:[UIColor redColor]];
//    [_headerView addSubview:surebtn];
//
//    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame =CGRectMake(30+(KscreenWidth-90)/2+30, _headerView.bottom-70, (KscreenWidth-90)/2, 40);
//    cancelBtn.layer.cornerRadius = 5.f;
//    cancelBtn.layer.masksToBounds = YES;
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setBackgroundColor:[UIColor cyanColor]];
//    [_headerView addSubview:cancelBtn];
    

}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == _tbView){
//        return _resultData.count;
//    }
//    //    else if(tableView == self.cgpeopleTable){
//    //        return _cgpeopleArr.count;
//    //    }else if (tableView == self.orderNoTable){
//    //        return _orderNoArray.count;
//    //    }
//    return 0;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    //    if (tableView == _tbView) {
//    //        return _dataArray.count;
//    //    }
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == _tbView) {
//        return 280;
//    }
//    return 44;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView == _tbView) {
//        return 10;
//    }
//    return 0;
//}
//
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString* cellID = @"cellID";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//
//    ProgressingCell* procell = [tableView dequeueReusableCellWithIdentifier:@"ProgressingCell"];
//    if (!procell) {
//        procell = [[[NSBundle mainBundle]loadNibNamed:@"ProgressingCell" owner:self options:nil]firstObject];
//    }
//    [procell setDelBtnBlock:^{
//        [_resultData removeObjectAtIndex:indexPath.row];
//        [_tbView beginUpdates];
//        [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [_tbView endUpdates];
//        self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, _headerView.bottom+280*_resultData.count+10);
//        [_tbView reloadData];
//    }];
//    if (tableView == _tbView) {
//        if (_resultData.count!=0) {
//            procell.model = _resultData[indexPath.row];
//            procell.count = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
//            NSLog(@"procell.count%@",procell.count);
//        }
//        procell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return procell;
//    }
//    //    else if (tableView == self.orderNoTable){
//    //
//    //        cell.textLabel.text = _orderNoArray[indexPath.row];
//    //        return cell;
//    //
//    //    }else if (tableView == self.cgpeopleTable){
//    //        cell.textLabel.text = _cgpeopleArr[indexPath.row];
//    //        return cell;
//    //    }
//    //
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    [self.m_keHuPopView removeFromSuperview];
//    //    if(tableView == self.orderNoTable) {
//    //        _orderNoBtn.userInteractionEnabled = YES;
//    //        [_orderNoBtn setTitle:[_orderNoArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
//    //        _orderid = [_orderNoArray objectAtIndex:indexPath.row];
//    //        [_tbView reloadData];
//    //        [self DataRequest2WithProid:[_orderNoArray objectAtIndex:indexPath.row]];
//    //
//    //    }else if (tableView == self.cgpeopleTable){
//    //        _nameButton.userInteractionEnabled = YES;
//    //        [_nameButton setTitle:[_cgpeopleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
//    //        _custid = [_cgpeopleIdArr objectAtIndex:indexPath.row];
//    //    }
//}
@end
