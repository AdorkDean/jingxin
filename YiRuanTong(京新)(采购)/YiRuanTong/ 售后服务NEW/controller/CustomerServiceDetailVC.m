//
//  CustomerServiceDetailVC.m
//  YiRuanTong
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CustomerServiceDetailVC.h"
#import "UIViewExt.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface CustomerServiceDetailVC ()

@end

@implementation CustomerServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    [self creatUI];
    
}
- (void)creatUI{
    self.title = @"售后详情";
    UIScrollView* sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    sView.contentSize = CGSizeMake(KscreenWidth, 700);
    sView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sView];
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KscreenWidth - 20, 50)];
    titleLabel.text = @"问题详情";
    titleLabel.font = [UIFont systemFontOfSize:17];
    [sView addSubview:titleLabel];
    UIView* titleLine = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom-1, titleLabel.width, 1)];
    titleLine.backgroundColor = lineColor;
    [sView addSubview:titleLine];
    
    NSArray* titleArray = @[@"提问时间",@"提问内容",@"处理时间",@"处理结果"];
    NSString* submittime = [NSString stringWithFormat:@"%@",_model.submittime];
    NSString* question = [NSString stringWithFormat:@"%@",_model.question];
    NSString* dealtime = [NSString stringWithFormat:@"%@",_model.dealtime];
    NSString* dealresult = [NSString stringWithFormat:@"%@",_model.dealresult];
    NSArray* detailArray = @[submittime,question,dealtime,dealresult];
    CGSize questH = [self sizeWithText:question font:[UIFont systemFontOfSize:14] maxW:KscreenWidth -100];
    CGSize dealH = [self sizeWithText:dealresult font:[UIFont systemFontOfSize:14] maxW:KscreenWidth -100];
    if (questH.height<45) {
        questH.height = 45;
    }
    if (dealH.height<45) {
        dealH.height = 45;
    }
    NSArray* heightArray = @[@"45",[NSString stringWithFormat:@"%f",questH.height],@"45",[NSString stringWithFormat:@"%f",dealH.height]];
    CGFloat h = 0;
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLine.bottom+h, 80, [heightArray[i] floatValue])];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [sView addSubview:titleLabel];
        UILabel* detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, sView.width - titleLabel.width - 20, titleLabel.height)];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.tag = 100+i;
        if (i<detailArray.count) {
            detailLabel.text = detailArray[i];
        }
        [sView addSubview:detailLabel];
        if (i == titleArray.count - 1) {
            titleLabel.textColor = UIColorFromRGB(0x3cbaff);
            detailLabel.textColor = UIColorFromRGB(0x3cbaff);
        }
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, KscreenWidth - 20, 0.5)];
        [self drawDashLine:line lineLength:1 lineSpacing:1 linecolor:COLOR(188, 188, 188, 1)];
        [sView addSubview:line];
        h = [heightArray[i] floatValue]+h;
    }

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
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSDictionary* atrDict = @{NSFontAttributeName:font};
    CGSize size1 =  [text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    return size1;
}


@end
