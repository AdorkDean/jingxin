//
//  WriteReportVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/5.
//  Copyright © 2018年 联祥. All rights reserved.
//



#import "WriteReportVC.h"
#import "ExpenseDemoCell.h"
#import "LXLocationCell.h"
#import "LXUploadPhotoCell.h"
#import "LXSelectDocumentCell.h"
#import "MKComposePhotosView.h"
#import "MKMessagePhotoView.h"
#import "RZInfoModel.h"
#import "LXWriteReportTableHeadView.h"
#import "IsNumberOrNot.h"
#import <CoreLocation/CoreLocation.h>
@interface WriteReportVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TextViewCellDelegate,MKMessagePhotoViewDelegate,CLLocationManagerDelegate>
@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * textFieldArray;
@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic,strong)NSMutableArray * countLimitArray;

@property (nonatomic, strong) MKMessagePhotoView *photosView;
@property (nonatomic,strong) NSMutableArray *firstArr;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,copy)NSString * address;
@end

@implementation WriteReportVC
{
    NSInteger _flag;
    NSInteger _lg;
    NSInteger _imageInteger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.name;
    self.navigationItem.rightBarButtonItem = nil;
    _imageInteger = 0;
    [self startLocation];
    
   
    self.dataArr = [[NSMutableArray alloc]init];
    _firstArr = [NSMutableArray new];
    [self DataRequest];
    
    [self.view addSubview:self.tableView];
    UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, KscreenWidth, 160*MYWIDTH)];
    imageV.image = [UIImage imageNamed:@"rizhiruhexie"];
    _tableView.tableHeaderView = imageV;
    [self createBottomView];
    //监听键盘出现和消失
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘出现

-(void)keyboardWillShow:(NSNotification*)note{
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.tableView.contentInset= UIEdgeInsetsMake(0,0, keyBoardRect.size.height,0);
    
}

#pragma mark 键盘消失

-(void)keyboardWillHide:(NSNotification*)note{
    
    self.tableView.contentInset= UIEdgeInsetsZero;
    
}

#pragma mark - 日志类型详情加载
- (void)DataRequest
{
    /*
     类型详情
     http://182.92.96.58:8005/yrt/servlet/dailyreport
     action    getTypeDetail
     params    {"idEQ":"26"}  id=73
     */
    //类型详情接口   解析good；
    
    _dataArray = [[NSMutableArray alloc] init];
    _textFieldArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc] init];
    _countLimitArray = [[NSMutableArray alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *str = [NSString stringWithFormat: @"action=getTypeDetail&params={\"idEQ\":\"%zi\"}",self.nameID];
    
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
            NSLog(@"类型数组:%@",array);
            
            for (NSDictionary *dic in array) {
                RZInfoModel *model = [[RZInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
                [_firstArr addObject:model.name];
                [self.dataArr addObject:@{@"ExpenseDetails":@""}];
                
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
    
}
//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            NSLog(@"city = %@", city);//石家庄市
            NSLog(@"--%@",placemark.name);//黄河大道221号
            NSLog(@"++++%@",placemark.subLocality); //裕华区
            NSLog(@"country == %@",placemark.country);//中国
            NSLog(@"administrativeArea == %@",placemark.administrativeArea); //河北省
            self.address = [NSString stringWithFormat:@"%@%@%@%@",placemark.administrativeArea,city,placemark.subLocality,placemark.name];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

           
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

-(void)createBottomView{

   UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-64-60, KscreenWidth, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(10,10, KscreenWidth-20, 40);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.backgroundColor = ssRGBHex(0x03a9f4);
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commitBtn];
}
-(void)commit{
    /*上报日志（上报）
     http://182.92.96.58:8005/yrt/servlet/dailyreport
     mobile    true
     action    addReprt
     data    {"reporttypename":"年度总结汇报","rbmxList":[],"reporttypeid":"34","table":"rzsb"}
     table    rzsb   */

    for (NSDictionary *dic in self.dataArr) {
        if ([dic[@"ExpenseDetails"] length]==0) {
            [self showAlert:@"工作内容不能为空"];
            return;
        }
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSMutableString *str = [NSMutableString stringWithFormat:@"mobile=true&action=addReprt&data={\"reporttypename\":\"%@\",\"reporttypeid\":\"%zi\",\"location\":\"%@\",\"table\":\"rzsb\",\"rbmxList\":[]}",self.name,_nameID,self.address];
    for (int i = 0; i < _dataArray.count; i++) {
        RZInfoModel *model = [_dataArray objectAtIndex:i];
        UITextView *textView = [_textFieldArray objectAtIndex:i];
        NSString *contentStr = textView.text;
        NSString * reportTitle = _firstArr[i];
        contentStr = [self replace:contentStr];
        NSInteger length = [model.minlength integerValue];
        _lg = length - contentStr.length;
//        if (contentStr.length < length) {
//            _flag = 1;
//        } else {
        
            _flag = 0;
            [str insertString:[NSString stringWithFormat:@"{\"table\":\"rbmx\",\"reporttitleid\":\"%@\",\"reporttitle\":\"%@\",\"reportcontent\":\"%@\"},",[NSString stringWithFormat:@"%ld",_nameID],reportTitle,contentStr] atIndex:str.length-2];
//        }
    }
    
//    if (_flag == 0) {
    
        [str deleteCharactersInRange:NSMakeRange(str.length - 3, 1)];
        
        NSLog(@"日志上传字符串:%@",str);
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"日志上报返回信息:%@",str1);
        if (str1.length != 0) {
            NSRange range = {1,str1.length-2};
            NSString *reallystr = [str1 substringWithRange:range];
            if ([IsNumberOrNot isAllNum:reallystr]) {
                
//                [self showAlert:@"上报成功!"];
//                [self.navigationController popViewControllerAnimated:YES];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"newDailyreport" object:self];
                
                if (_imageInteger != 0) {
                    NSDictionary * dic =@{@"reallystr":reallystr};
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"upImageWithData" object:self userInfo:dic];
                }else{
                    [self showAlert:@"上报成功!"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self showAlert:reallystr];
            }
            
        }
        
//    } else if (_flag == 1){
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"字数不够,还差%ld个字",_lg] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.firstArr.count;
    }else{
        return 1;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *cellID =@"ExpenseDemoCell";
        ExpenseDemoCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell ==nil)
        {
            cell =(ExpenseDemoCell*)[[[NSBundle mainBundle]loadNibNamed:@"ExpenseDemoCell" owner:self options:nil]firstObject];
        }
        cell.nameLabel.text = _firstArr[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [_textFieldArray addObject:cell.textView];
        [cell initwith:self.dataArr[indexPath.row] Index:indexPath.row+1];
        cell.delegate=self;
        return cell;
    }else if(indexPath.section == 1){
//        if (indexPath.row == 0) {
            static NSString *cellID =@"LXUploadPhotoCell";
            LXUploadPhotoCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell ==nil)
            {
                cell =(LXUploadPhotoCell*)[[[NSBundle mainBundle]loadNibNamed:@"LXUploadPhotoCell" owner:self options:nil]firstObject];
            }
            __weak typeof(cell) weakCell = cell;
            [cell setSelectPhotoBlock:^{
                if (!self.photosView)
                {
                    //设置图片展示区域
                    self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(10*MYWIDTH,40,UIScreenW-20*MYWIDTH, 60)];
                    //self.photosView.backgroundColor = [UIColor redColor];
                    [weakCell addSubview:self.photosView];
                    self.photosView.backgroundColor = [UIColor whiteColor];
                    self.photosView.delegate = self;
                    self.photosView.ViewController = self;
//                    [_tableView reloadData];
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

                }
                
                [self.photosView clickAddPhotos:nil];
            }];
            [cell addSubview:self.photosView];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return cell;
        }
//        else{
//            static NSString *cellID =@"LXSelectDocumentCell";
//            LXSelectDocumentCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
//            if (cell ==nil)
//            {
//                cell =(LXSelectDocumentCell*)[[[NSBundle mainBundle]loadNibNamed:@"LXSelectDocumentCell" owner:self options:nil]firstObject];
//            }
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//
//            return cell;
//        }
//    }
    else{
        static NSString *cellID =@"LXLocationCell";
        LXLocationCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell ==nil)
        {
            cell =(LXLocationCell*)[[[NSBundle mainBundle]loadNibNamed:@"LXLocationCell" owner:self options:nil]firstObject];
        }
        cell.address.text = self.address;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *inforStr = self.dataArr[indexPath.row];
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize size = CGSizeMake(KscreenWidth-80,2000);
        CGSize labelsize = [inforStr[@"ExpenseDetails"] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        return labelsize.height+44;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if (self.photosView){
                return 100;
            }
        }
        return 40;
    }else{
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        LXWriteReportTableHeadView * headview = [LXWriteReportTableHeadView headerViewWithTableView:tableView];
        return headview;
    }else{
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
            view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
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
    
}
- (void)textViewCell:(ExpenseDemoCell *)cell didChangeText:(NSString *)text
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:self.dataArr[indexPath.row]];
    
    dict[@"ExpenseDetails"]=text;
    
    self.dataArr[indexPath.row]=dict;

//    _tableView.frame=CGRectMake(0, 0, KscreenWidth, _tableView.contentSize.height+10);
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight-64-60) style:UITableViewStyleGrouped];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _tableView;
}
//实现代理方法，相册
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

//相机📷
-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}
- (void)upDataUIImageArr:(NSInteger)integer{
    _imageInteger = integer;
}
- (NSString *)replace:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    return returnString;
}



@end
