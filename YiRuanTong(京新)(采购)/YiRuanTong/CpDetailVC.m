//
//  CpDetailVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "CpDetailVC.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "UIViewExt.h"
#define LineColor COLOR(240, 240, 240, 1);
@interface CpDetailVC (){

    NSInteger _page;
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
    UILabel *_label5;
    UILabel *_label6;
    UILabel *_label7;
    UILabel *_label8;
    

}

@end

@implementation CpDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"产品详情";
    self.navigationItem.rightBarButtonItem = nil;
    _page = 1;
    [self initView];
    [self DataRequest];
    
}

- (void)initView{
    UIScrollView *back = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    back.contentSize = CGSizeMake(0, KscreenHeight);
    [self.view addSubview:back];
    //
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45)];
    label11.font = [UIFont systemFontOfSize:14];
    label11.text = @"产品名称";
    [back addSubview:label11];
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, KscreenWidth - 110, 45)];
    _label1.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label1];
    UIView *view1  = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view1];
    //
    UILabel *label22 = [[UILabel alloc] initWithFrame:CGRectMake(10, label11.bottom + 1, 90, 45)];
    label22.font = [UIFont systemFontOfSize:14];
    label22.text = @"助记码";
    [back addSubview:label22];
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, label11.bottom + 1, KscreenWidth - 110, 45)];
    _label2.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label2];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, label22.bottom, KscreenWidth, 1)];
    view2.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view2];
    //
    UILabel *label33 = [[UILabel alloc] initWithFrame:CGRectMake(10, label22.bottom + 1, 90, 45)];
    label33.font = [UIFont systemFontOfSize:14];
    label33.text = @"产品类型";
    [back addSubview:label33];
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(100, label22.bottom + 1, KscreenWidth - 110, 45)];
    _label3.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label3];
    UIView *view3  = [[UIView alloc] initWithFrame:CGRectMake(0, label33.bottom, KscreenWidth, 1)];
    view3.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view3];
    //
    UILabel *label44 = [[UILabel alloc] initWithFrame:CGRectMake(10, label33.bottom + 1, 90, 45)];
    label44.font = [UIFont systemFontOfSize:14];
    label44.text = @"规格";
    [back addSubview:label44];
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(100, label33.bottom + 1, KscreenWidth - 110, 45)];
    _label4.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label4];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, label44.bottom, KscreenWidth, 1)];
    view4.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view4];
    //
    UILabel *label55 = [[UILabel alloc] initWithFrame:CGRectMake(10, label44.bottom + 1, 90, 45)];
    label55.font = [UIFont systemFontOfSize:14];
    label55.text = @"主单位";
    [back addSubview:label55];
    _label5= [[UILabel alloc] initWithFrame:CGRectMake(100, label44.bottom + 1, KscreenWidth - 110, 45)];
    _label5.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label5];
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, label55.bottom, KscreenWidth, 1)];
    view5.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view5];
    //
    UILabel *label66 = [[UILabel alloc] initWithFrame:CGRectMake(10, label55.bottom + 1, 90, 45)];
    label66.font = [UIFont systemFontOfSize:14];
    label66.text =@"副单位";
    [back addSubview:label66];
    _label6 = [[UILabel alloc] initWithFrame:CGRectMake(100, label55.bottom + 1, KscreenWidth - 110, 45)];
    _label6.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label6];
    UIView *view6  = [[UIView alloc] initWithFrame:CGRectMake(0, label66.bottom, KscreenWidth, 1)];
    view6.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view6];
    //
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(10, label66.bottom + 1, 90, 45)];
    label77.font = [UIFont systemFontOfSize:14];
    label77.text = @"单价";
    [back addSubview:label77];
    _label7 = [[UILabel alloc] initWithFrame:CGRectMake(100, label66.bottom + 1, KscreenWidth - 110, 45)];
    _label7.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label7];
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(0, label77.bottom, KscreenWidth, 1)];
    view7.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view7];
    //
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(10, label77.bottom + 1, 90, 45)];
    label88.font = [UIFont systemFontOfSize:14];
    label88.text = @"产品编码";
    [back addSubview:label88];
    _label8 = [[UILabel alloc] initWithFrame:CGRectMake(100, label77.bottom + 1, KscreenWidth - 110, 45)];
    _label8.font = [UIFont systemFontOfSize:14];
    [back addSubview:_label8];
    UIView *view8  = [[UIView alloc] initWithFrame:CGRectMake(0, label88.bottom, KscreenWidth, 1)];
    view8.backgroundColor = COLOR(240, 240, 240, 1);
    [back addSubview:view8];
    




}

- (void)DataRequest{
    /*
        action:"getBeans"
     view:"cpstview"
     page:"1"
     rows:"20"
     params:"{"table":"cpxx","pronoEQ":"","pronameLIKE":"A牛羊菌毒康治疗包","helpnoLIKE":"","protypeidEQ":"","mainunitEQ":"","secondunitEQ":"","isvalidEQ":""}"
     
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/product"];
    NSDictionary *params = @{@"action":@"getBeans",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"view":@"cpstview",@"params":[NSString stringWithFormat:@"{\"table\":\"cpxx\",\"pronoEQ\":\"\",\"pronameLIKE\":\"%@\",\"helpnoLIKE\":\"\",\"protypeidEQ\":\"\",\"mainunitEQ\":\"\",\"secondunitEQ\":\"\",\"isvalidEQ\":\"\"}",_ProId]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品浏览列表:%@",dic);
        if (array.count != 0) {
            _label1.text = array[0][@"proname"];
            _label2.text = [NSString stringWithFormat:@"%@",array[0][@"helpno"]];
            _label3.text = [NSString stringWithFormat:@"%@",array[0][@"protypename"]];
            _label4.text = [NSString stringWithFormat:@"%@",array[0][@"specification"]];
            _label5.text = [NSString stringWithFormat:@"%@",array[0][@"mainunitname"]];
            _label6.text = [NSString stringWithFormat:@"%@",array[0][@"secondunitname"]];
            _label7.text = [NSString stringWithFormat:@"%@",array[0][@"saleprice"]];
            _label8.text = [NSString stringWithFormat:@"%@",array[0][@"prono"]];
            
            
    
        }
       
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {

        NSLog(@"错误%@",error);
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
