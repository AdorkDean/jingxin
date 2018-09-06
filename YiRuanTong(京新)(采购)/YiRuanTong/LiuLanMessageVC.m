//
//  LiuLanMessageVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "LiuLanMessageVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "RZzhanshiInfoModel.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "PicModel.h"
#import "XWScanImage.h"
@interface LiuLanMessageVC ()<UIScrollViewDelegate,UITextFieldDelegate>

{
    UIView *_detailView;
    NSMutableArray *_dataArray;
    NSMutableArray *_picArr;
    UIScrollView *_rzScrollView;
   
    UIButton *_statusBtn;
    UIButton *_qualityBtn;
    MBProgressHUD *_HUD;
}

@end

@implementation LiuLanMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"日志详情";
    _dataArray = [[NSMutableArray alloc] init];
    _picArr = [[NSMutableArray alloc]init];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadPage];
             [self reloadDetailView];
            
            [_HUD hide:YES];
        });
    });

    
    
}

- (void)loadPage
{
    _rzScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _rzScrollView.delegate = self;
   
    _rzScrollView.bounces = NO;
    [self.view addSubview:_rzScrollView];
    
    //类型
    UILabel *leiXingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 40)];
    leiXingLabel.text = @"类型";
    leiXingLabel.textAlignment = NSTextAlignmentCenter;
    leiXingLabel.font = [UIFont systemFontOfSize:14.0];
    leiXingLabel.backgroundColor = COLOR(231, 231, 231, 1);
    
    _leiXing = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 220, 40)];
    _leiXing.textAlignment = NSTextAlignmentLeft;
    _leiXing.font = [UIFont boldSystemFontOfSize:14.0];
    
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    line0.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_rzScrollView addSubview:leiXingLabel];
    [_rzScrollView addSubview:_leiXing];
    [_rzScrollView addSubview:line0];
    
    //上报人
    UILabel *shangbaorenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 89, 40)];
    shangbaorenLabel.text = @"上报人";
    shangbaorenLabel.textAlignment = NSTextAlignmentCenter;
    shangbaorenLabel.font = [UIFont systemFontOfSize:14.0];
    shangbaorenLabel.backgroundColor = COLOR(231, 231, 231, 1);
    
    _shangBaoRen = [[UILabel alloc] initWithFrame:CGRectMake(95, 41, 220, 40)];
    _shangBaoRen.textAlignment = NSTextAlignmentLeft;
    _shangBaoRen.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 81, KscreenWidth, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_rzScrollView addSubview:shangbaorenLabel];
    [_rzScrollView addSubview:_shangBaoRen];
    [_rzScrollView addSubview:line1];
    
    //上报时间
    UILabel *shangbaoshijian = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 89, 40)];
    shangbaoshijian.text = @"上报时间";
    shangbaoshijian.textAlignment = NSTextAlignmentCenter;
    shangbaoshijian.font = [UIFont systemFontOfSize:14.0];
    shangbaoshijian.backgroundColor = COLOR(231,231, 231,1);
    
    _shangBaoTime = [[UILabel alloc] initWithFrame:CGRectMake(95, 82, 220, 40)];
    _shangBaoTime.textAlignment = NSTextAlignmentLeft;
    _shangBaoTime.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 122, KscreenWidth, 1)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //上报地点
    UILabel *shangbaoAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 123, 89, 40)];
    shangbaoAddress.text = @"上报地点";
    shangbaoAddress.textAlignment = NSTextAlignmentCenter;
    shangbaoAddress.font = [UIFont systemFontOfSize:14.0];
    shangbaoAddress.backgroundColor = COLOR(231,231, 231,1);
    
    _shangBaoAddress = [[UILabel alloc] initWithFrame:CGRectMake(95, 123, 220, 40)];
    _shangBaoAddress.textAlignment = NSTextAlignmentLeft;
    _shangBaoAddress.font = [UIFont systemFontOfSize:14.0];
    _shangBaoAddress.textColor = [UIColor blackColor];
    
    UILabel *lineAdr = [[UILabel alloc] initWithFrame:CGRectMake(0, 163, KscreenWidth, 1)];
    lineAdr.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.leiXing.text = _model.reporttypename;
    self.shangBaoRen.text = _model.creator;
    self.shangBaoTime.text = _model.reportdate;
    self.shangBaoAddress.text = _model.location;
    
    [_rzScrollView addSubview:shangbaoAddress];
    [_rzScrollView addSubview:_shangBaoAddress];
    [_rzScrollView addSubview:shangbaoshijian];
    [_rzScrollView addSubview:_shangBaoTime];
    [_rzScrollView addSubview:line2];
    [_rzScrollView addSubview:lineAdr];
}

- (void)reloadDetailView
{
    [self dataRequest];
    [self getPicRequest];
    NSLog(@"数组数目:%zi",_dataArray.count);
    
    _rzScrollView.contentSize = CGSizeMake(0, 163 + _dataArray.count * 80 + 60);
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 165, KscreenWidth, _dataArray.count * 80)];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < _dataArray.count; i++) {
        RZzhanshiInfoModel *model = [_dataArray objectAtIndex:i];
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 80*i, 89, 80)];
        titleLabel.text = model.reporttitle;
        titleLabel.backgroundColor = COLOR(231, 231, 231, 1);
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(95, 5 + 81*i, KscreenWidth - 95 - 10, 70)];
        //[contentLabel loadHTMLString:model.reportcontent baseURL:nil];
        //[contentLabel sizeToFit];
        
        contentLabel.userInteractionEnabled = NO;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.backgroundColor = [UIColor whiteColor];
        //contentLabel.textAlignment = NSTextAlignmentCenter;
        //contentLabel.font = [UIFont systemFontOfSize:13.0];
        //contentLabel.userInteractionEnabled = NO;
        //contentLabel.numberOfLines = 0;
        NSString *content = model.reportcontent;
        content = [self getRealStr:content];
        contentLabel.text = content;
        //线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, contentLabel.bottom , KscreenWidth, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_detailView addSubview:titleLabel];
        [_detailView addSubview:contentLabel];
        [_detailView addSubview:line];
    }
    [_rzScrollView addSubview:_detailView];
    
    ///////////// 评价
    
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0,165 +  _detailView.frame.size.height,KscreenWidth , 200)];
    addView.backgroundColor = [UIColor whiteColor];
    [_rzScrollView addSubview:addView];
    
    // 完成情况
    UILabel *wanchengLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 40)];
    wanchengLabel.text = @"完成情况";
    wanchengLabel.textAlignment = NSTextAlignmentCenter;
    wanchengLabel.backgroundColor = COLOR(231, 231, 231, 1);
    wanchengLabel.font = [UIFont systemFontOfSize:14];
    [addView addSubview:wanchengLabel];
    _statusBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _statusBtn.frame = CGRectMake(95, 0, KscreenWidth - 100, 40);
    [_statusBtn setTintColor:[UIColor blackColor]];
    _statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _statusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
   // [_statusBtn addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:_statusBtn];
    NSString *stiua = [NSString stringWithFormat:@"%@",_model.situation];
    if ([stiua isEqualToString:@"1"]) {
        [_statusBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else if ([stiua isEqualToString:@"0"]){
        [_statusBtn setTitle:@"未完成" forState:UIControlStateNormal];
    }
    
    //
    UILabel *qualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, wanchengLabel.bottom + 1, 89, 40)];
    qualityLabel.text = @"完成质量";
    qualityLabel.textAlignment = NSTextAlignmentCenter;
    qualityLabel.backgroundColor = COLOR(231, 231, 231, 1);
    qualityLabel.font = [UIFont systemFontOfSize:14];
    [addView addSubview:qualityLabel];
    UILabel *qualityline = [[UILabel alloc] initWithFrame:CGRectMake(0, wanchengLabel.bottom, KscreenWidth, 1)];
    qualityline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [addView addSubview:qualityline];
    _qualityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _qualityBtn.frame = CGRectMake(95, wanchengLabel.bottom + 1, KscreenWidth - 100, 40);
    [_qualityBtn setTintColor:[UIColor blackColor]];
    _qualityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _qualityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
   // [_qualityBtn addTarget:self action:@selector(qualityAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *qualitybline = [[UILabel alloc] initWithFrame:CGRectMake(0, qualityLabel.bottom, KscreenWidth, 1)];
    qualitybline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [addView addSubview:qualitybline];
    [addView addSubview:_qualityBtn];
    NSString *qual = [NSString stringWithFormat:@"%@",_model.quality];
    if ([qual isEqualToString:@"0"]) {
        [_qualityBtn setTitle:@"较差" forState:UIControlStateNormal];
    }else if ([qual isEqualToString:@"1"]){
        [_qualityBtn setTitle:@"一般" forState:UIControlStateNormal];
    }else if ([qual isEqualToString:@"2"]){
        [_qualityBtn setTitle:@"较好" forState:UIControlStateNormal];
    }
    
    //上报图片
    UILabel *photo = [[UILabel alloc] initWithFrame:CGRectMake(0, qualityLabel.bottom+1, 89, 80)];
    photo.text = @"上报图片";
    photo.textAlignment = NSTextAlignmentCenter;
    photo.font = [UIFont systemFontOfSize:14.0];
    photo.backgroundColor = COLOR(231,231, 231,1);
    CGFloat width = (KscreenWidth-89)/4;
    for (int i = 0; i<_picArr.count; i++) {
        PicModel * model = _picArr[i];
        _shangBaoPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(89+i*width, qualityLabel.bottom+1, width, 80)];
        [_shangBaoPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,model.folder,model.autoname]]];
        [addView addSubview:_shangBaoPhoto];
        NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,model.folder,model.autoname]]);
        // - 浏览大图点击事件
        //为UIImageView1添加点击事件
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
        [_shangBaoPhoto addGestureRecognizer:tapGestureRecognizer1];
        //让UIImageView和它的父类开启用户交互属性
        [_shangBaoPhoto setUserInteractionEnabled:YES];
    }
    UILabel *lineAdr = [[UILabel alloc] initWithFrame:CGRectMake(0, photo.bottom, KscreenWidth, 1)];
    lineAdr.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [addView addSubview:photo];
    [addView addSubview:lineAdr];
    //批复
    UILabel *pifuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,lineAdr.bottom + 1,89 , 40)];
    
    pifuLabel.textAlignment = NSTextAlignmentCenter;
    pifuLabel.backgroundColor = COLOR(231, 231, 231, 1);
    pifuLabel.font = [UIFont systemFontOfSize:14.0];
    [addView addSubview:pifuLabel];
    pifuLabel.text = [NSString stringWithFormat:@"%@批复",_model.replyer];
    UILabel *pifuline = [[UILabel alloc] initWithFrame:CGRectMake(0, lineAdr.bottom, KscreenWidth, 1)];
    pifuline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [addView addSubview:pifuline];
    _piFuNeiRong = [[UITextField alloc] initWithFrame:CGRectMake(95, lineAdr.bottom + 1, KscreenWidth - 155, 40)];
    _piFuNeiRong.font = [UIFont systemFontOfSize:13.0];
    _piFuNeiRong.delegate = self;
    _piFuNeiRong.userInteractionEnabled = NO;
    [addView addSubview:_piFuNeiRong];
    if (_model.replycontent.length == 0) {
        self.piFuNeiRong.text = @"暂无";
    } else {
        
        self.piFuNeiRong.text = _model.replycontent;
    }

    //批复按钮
//    UIButton *piFuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [piFuBtn setTitle:@"批复" forState:UIControlStateNormal];
//    [piFuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [piFuBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    piFuBtn.frame = CGRectMake(KscreenWidth - 55, qualityLabel.bottom + 1 + 5,50 , 30);
//    [piFuBtn addTarget:self action:@selector(piFu) forControlEvents:UIControlEventTouchUpInside];
//    [addView addSubview:piFuBtn];
    
    //线
    UILabel *piFuline = [[UILabel alloc] initWithFrame:CGRectMake(0, pifuLabel.bottom + 1, KscreenWidth, 1)];
    piFuline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [addView addSubview:piFuline];
    //线
    UILabel *sline = [[UILabel alloc] initWithFrame:CGRectMake(89, 0, 1, 123)];
    sline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [addView addSubview:sline];
    
    
    //    //附件
    //    UILabel *fujianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 164 + _detailView.frame.size.height, 89, 40)];
    //    fujianLabel.text = @"附件";
    //    fujianLabel.textAlignment = NSTextAlignmentCenter;
    //    fujianLabel.backgroundColor = COLOR(231, 231, 231, 1);
    //    fujianLabel.font = [UIFont systemFontOfSize:14.0];
    //    //[self.view addSubview:fujianLabel];
    //    //线
    //    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 204 + _detailView.frame.size.height, KscreenWidth, 1)];
    //    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //竖线
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(89, 0,1, addView.frame.origin.y +1)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    
    //[self.view addSubview:line1];
    [_rzScrollView addSubview:line2];
}
// - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
- (void)dataRequest
{
    NSLog(@"id:%@",self.idEQ);
    NSString *strAdress = @"/dailyreport";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getReprtDetail&params={\"idEQ\":\"%@\"}",self.idEQ];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"日志详情返回信息:%@",array);
            for (NSDictionary *dic in array) {
                RZzhanshiInfoModel *model = [[RZzhanshiInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }

        }
    }

    
}
-(void)getPicRequest{
    
    NSLog(@"id:%@",self.idEQ);
    NSString *strAdress = @"/dailyreport";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=searchdailyreportPic&data={\"reportid\":\"%@\"}",self.idEQ];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"请求图片返回信息:%@",array);
            for (NSDictionary *dic in array) {
                PicModel *model = [[PicModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_picArr addObject:model];
            }
            
        }
    }
}
- (NSString *)getRealStr:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    return returnString;
}


@end
