//
//  XiaoShouFaHuoChartVC.m
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "XiaoShouFaHuoChartVC.h"
#import "UUChart.h"
#import "UIViewExt.h"
@interface XiaoShouFaHuoChartVC ()<UUChartDataSource,UIScrollViewDelegate>{
    
    
    NSIndexPath *path;
    UUChart *chartView;
}

@end

@implementation XiaoShouFaHuoChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报表统计";
    self.navigationItem.rightBarButtonItem = nil;
    //创建图表视图
    [self initChartView];
    
    
}
- (void)initChartView{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64 - 40 )];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor blueColor];
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    mainScrollView.contentSize = CGSizeMake(KscreenWidth, 0);
    [self.view addSubview:mainScrollView];
    
    UIView *heng = [[UIView alloc] initWithFrame:CGRectMake(0, mainScrollView.bottom + 5, KscreenWidth, 1)];
    heng.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:heng];
    //
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, mainScrollView.bottom + 10 , 60, 20)];
    label1.backgroundColor = UUiOSGreenColor;
    label1.text = @"今年发货";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    //
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth - 100, mainScrollView.bottom + 10 , 60, 20)];
    label2.backgroundColor = UUiOSBlue;
    label2.text = @"去年发货";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KscreenHeight - 64 - 40)
                                              withSource:self
                                               withStyle:UUChartBarStyle];
    [chartView showInView:mainScrollView];
    
    
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"R-%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    NSArray *arrat =  _nameData;
    
    return  arrat; //[self getXTitles:7];
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    
    NSArray *ary1 = _thisYearData;   //第一列
    NSArray *ary2 = _lastYearData;   //第二列
    
    
    
    return @[ary1,ary2];
    
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUiOSGreenColor,UUiOSBlue,UUBrown];
}

@end
