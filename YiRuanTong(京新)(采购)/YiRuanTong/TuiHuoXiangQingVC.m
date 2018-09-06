//
//  TuiHuoXiangQingVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "TuiHuoXiangQingVC.h"
#import "TuiHuoViewController.h"
#import "UIViewExt.h"
#import "THPictureView.h"
#define lineColer COLOR(240, 240, 240, 1);
@interface TuiHuoXiangQingVC ()
{

    NSInteger count;
    UIView *_chanPinView;
}

@end

@implementation TuiHuoXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退货详情";
    //删除 添加按钮
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    [self showBarWithName:@"图片" addBarWithName:nil];
    
     [self DataRequest];
    _tuiHuoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    
    self.tuiHuoScrollView.contentSize = CGSizeMake(KscreenWidth, 150 + 384*count);
    self.tuiHuoScrollView.bounces= NO;
    self.tuiHuoScrollView.backgroundColor =[UIColor clearColor];
    self.tuiHuoScrollView.delegate =self;
    [self.view addSubview:self.tuiHuoScrollView];
   
    [self PageViewDidLoad];
    [self PageViewDidLoad1];
}


- (void)DataRequest
{
    /*退货申请  产品名称
     产品信息的接口
     goodsreturn
     action=toUpdateReturn
     table=thmx
     params	{"idEQ":"184"}
     */
    //退货浏览详情列表

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn"];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=toUpdateReturn&table=thmx&params={\"idEQ\":\"%@\"}",_model.Id];
  
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
        _xiangQinArray = arr;
        NSLog(@"退货详情%@",_xiangQinArray);
        count = _xiangQinArray.count;
            
        }
    
    }
    
    
}


-(void)PageViewDidLoad
{
    UILabel * keHuName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    keHuName.text = @"客户名称";
    keHuName.font =[UIFont systemFontOfSize:13];
    UIView *keHuNameView =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    keHuNameView.backgroundColor = lineColer;
    [self.tuiHuoScrollView addSubview:keHuNameView];
    [self.tuiHuoScrollView addSubview:keHuName];
    UILabel * keHuName1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, KscreenWidth - 100, 45)];
    keHuName1.font =[UIFont systemFontOfSize:13];
    keHuName1.textAlignment = NSTextAlignmentLeft;
    [self.tuiHuoScrollView addSubview:keHuName1];
    keHuName1.text = _model.custname;
    //
    UILabel * yeWuYuan = [[UILabel alloc]initWithFrame:CGRectMake(10, 46, 80, 45)];
    yeWuYuan.text = @"业务员";
    yeWuYuan.font = [UIFont systemFontOfSize:13];
    UIView *yeWuYuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    yeWuYuanView.backgroundColor = lineColer;
    [self.tuiHuoScrollView addSubview:yeWuYuanView];
    [self.tuiHuoScrollView addSubview:yeWuYuan];
    
    UILabel *yeWuYuan1 =[[UILabel alloc]initWithFrame:CGRectMake(90, 46, KscreenWidth - 100, 45)];
    yeWuYuan1.font =[UIFont systemFontOfSize:13];
    yeWuYuan1.textAlignment = NSTextAlignmentLeft;
    [self.tuiHuoScrollView addSubview:yeWuYuan1];
    yeWuYuan1.text = _model.saler;
    
    //
    UILabel * tuiHuoYuanYin = [[UILabel alloc]initWithFrame:CGRectMake(10, 92, 80, 45)];
    tuiHuoYuanYin.text = @"退货原因";
    tuiHuoYuanYin.font =[UIFont systemFontOfSize:13];
    UIView *tuiHuoYuanYinView =[[UIView alloc]initWithFrame:CGRectMake(0, 137, KscreenWidth, 1)];
    tuiHuoYuanYinView.backgroundColor = lineColer;
    [self.tuiHuoScrollView addSubview:tuiHuoYuanYinView];
    [self.tuiHuoScrollView addSubview:tuiHuoYuanYin];
    
    UILabel *tuiHuoYuanYin1 =[[UILabel alloc]initWithFrame:CGRectMake(90, 92, KscreenWidth - 100, 45)];
    tuiHuoYuanYin1.font =[UIFont systemFontOfSize:13];
    tuiHuoYuanYin1.textAlignment = NSTextAlignmentLeft;
    [self.tuiHuoScrollView addSubview:tuiHuoYuanYin1];
    tuiHuoYuanYin1.text = _model.returnreason;
    
}
-(void)PageViewDidLoad1{
    
    for (int i = 0; i < count; i ++) {
        _chanPinView = [[UIView alloc] initWithFrame:CGRectMake(0, 137 +i* 384, KscreenWidth, 384)];
        
        NSDictionary *dic = _xiangQinArray[i];

        UILabel *chanPinXinXi=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 24)];
        chanPinXinXi.text = [NSString stringWithFormat:@"产品信息(%zi)",i + 1];
        chanPinXinXi.font =[UIFont systemFontOfSize:18];
        chanPinXinXi.backgroundColor = COLOR(240, 240, 240, 1);
        chanPinXinXi.textAlignment = NSTextAlignmentCenter;
        [_chanPinView addSubview:chanPinXinXi];
        //////////
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 80, 45)];
        label1.text = @"产品名称";
        label1.font =[UIFont systemFontOfSize:13];
        UIView *chanPinNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, KscreenWidth, 1)];
        chanPinNameView.backgroundColor = lineColer;
        [_chanPinView addSubview:label1];
        [_chanPinView addSubview:chanPinNameView];
        
        UILabel * chanPinName1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 25, KscreenWidth - 100, 45)];
        chanPinName1.font =[UIFont systemFontOfSize:13];
        chanPinName1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanPinName1];
        chanPinName1.text = dic[@"proname"];
        
        UILabel *label2 =[[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
        label2.text = @"产品编码";
        label2.font =[UIFont systemFontOfSize:13];
        UIView *faHuoDanHaoView =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
        faHuoDanHaoView.backgroundColor = lineColer;
        [_chanPinView addSubview:faHuoDanHaoView];
        [_chanPinView addSubview:label2];
        
        UILabel * chanpinBianMa = [[UILabel alloc]initWithFrame:CGRectMake(90, label1.bottom + 1 , KscreenWidth - 100, 45)];
        chanpinBianMa.font =[UIFont systemFontOfSize:13];
        chanpinBianMa.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanpinBianMa];
        chanpinBianMa.text = dic[@"prono"];
        //
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
        label3.text = @"产品规格";
        label3.font =[UIFont systemFontOfSize:13];
        UIView *chanPinGuiGeView =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
        chanPinGuiGeView.backgroundColor =  lineColer;
        [_chanPinView addSubview:chanPinGuiGeView];
        [_chanPinView addSubview:label3];
        
        UILabel * chanPinGuiGe1 = [[UILabel alloc]initWithFrame:CGRectMake(90, label2.bottom + 1, KscreenWidth - 100, 45)];
        chanPinGuiGe1.font =[UIFont systemFontOfSize:13];
        chanPinGuiGe1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanPinGuiGe1];
        chanPinGuiGe1.text = dic[@"specification"];
        //
        UILabel *label4 =[[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
        label4.text = @"产品单位";
        label4.font =[UIFont systemFontOfSize:13];
        UIView *chanPinDanWeiView = [[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
        chanPinDanWeiView.backgroundColor =  lineColer;
        [_chanPinView addSubview:chanPinDanWeiView];
        [_chanPinView addSubview:label4];
        
        UILabel * chanPinDanWei1 = [[UILabel alloc]initWithFrame:CGRectMake(90, label3.bottom + 1, KscreenWidth - 100, 45)];
        chanPinDanWei1.textAlignment = NSTextAlignmentLeft;
        chanPinDanWei1.font =[UIFont systemFontOfSize:13];
        [_chanPinView addSubview:chanPinDanWei1];
        chanPinDanWei1.text = dic[@"prounitname"];
        //
        UILabel *label5 =[[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
        label5.text = @"单价";
        label5.font =[UIFont systemFontOfSize:13];
        UIView *danJiaView =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
        danJiaView.backgroundColor = lineColer;
        [_chanPinView addSubview:danJiaView];
        [_chanPinView addSubview:label5];
        UILabel * danJia1 = [[UILabel alloc]initWithFrame:CGRectMake(90, label4.bottom + 1, KscreenWidth - 100, 45)];
        danJia1.font =[UIFont systemFontOfSize:13];
        [_chanPinView addSubview:danJia1];
        danJia1.textAlignment = NSTextAlignmentLeft;
        NSString *singleprice =[NSString stringWithFormat:@"%@",dic[@"singleprice"]];
        danJia1.text =singleprice;
       
       
        //
        UILabel *label6 =[[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
        label6.text = @"产品批号";
        label6.font =[UIFont systemFontOfSize:13];
        UIView *chanPinPiHaoView =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
        chanPinPiHaoView.backgroundColor =  lineColer;
        [_chanPinView addSubview:chanPinPiHaoView];
        [_chanPinView addSubview:label6];
        
        UILabel * chanPinPiHao1 = [[UILabel alloc]initWithFrame:CGRectMake(90,label5.bottom + 1, KscreenWidth - 100, 45)];
        chanPinPiHao1.font =[UIFont systemFontOfSize:13];
        chanPinPiHao1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanPinPiHao1];
        chanPinPiHao1.text = dic[@"probatch"];
        //
        UILabel *label7 =[[UILabel alloc]initWithFrame:CGRectMake(10,label6.bottom + 1, 80, 45)];
        label7.text = @"退货数量";
        label7.font =[UIFont systemFontOfSize:13];
        UIView *tuiHuoShuLiangView =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
        tuiHuoShuLiangView.backgroundColor =  lineColer;
        [_chanPinView addSubview:tuiHuoShuLiangView];
        [_chanPinView addSubview:label7];
        UILabel * tuiHuoShuLiang1 = [[UILabel alloc]initWithFrame:CGRectMake(90,label6.bottom + 1, KscreenWidth - 100, 45)];
        tuiHuoShuLiang1.font =[UIFont systemFontOfSize:13];
        tuiHuoShuLiang1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:tuiHuoShuLiang1];
        NSString *procount =[NSString stringWithFormat:@"%@",dic[@"procount"]];
        tuiHuoShuLiang1.text =procount;
        
        //
        UILabel *label8 =[[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
        label8.text = @"退货金额";
        label8.font =[UIFont systemFontOfSize:13];
        UIView *tuiHuoJinEView =[[UIView alloc]initWithFrame:CGRectMake(0,label8.bottom, KscreenWidth, 1)];
        tuiHuoJinEView.backgroundColor =  lineColer;
        [_chanPinView addSubview:tuiHuoJinEView];
        [_chanPinView addSubview:label8];
        
        UILabel * tuiHuoJinE1 = [[UILabel alloc]initWithFrame:CGRectMake(90,label7.bottom + 1, KscreenWidth - 100, 45)];
        tuiHuoJinE1.font =[UIFont systemFontOfSize:13];
        tuiHuoJinE1.textAlignment = NSTextAlignmentLeft;
        NSString *returnmoney =[NSString stringWithFormat:@"%@",dic[@"goodsmoney"]];
        tuiHuoJinE1.text =returnmoney;
        [_chanPinView addSubview:tuiHuoJinE1];
    
        [self.tuiHuoScrollView addSubview:_chanPinView];
        
    }
}
- (void)addNext{
    NSLog(@"跳转");
    THPictureView *PicVC = [[THPictureView alloc] init];
    PicVC.tHIId = _model.Id;
    [self.navigationController pushViewController:PicVC animated:YES];
    
}
- (void)searchAction{
    
}


@end
