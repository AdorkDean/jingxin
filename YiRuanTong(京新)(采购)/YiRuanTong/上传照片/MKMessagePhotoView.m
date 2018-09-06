//
//  MKMessagePhotoView.h
//
//  Created by Mory on 16/3/12.
//  Copyright © 2016年 MCWonders. All rights reserved.
//


#import "MKMessagePhotoView.h"
#import "AFNetworking.h"

#define MaxItemCount 4
#define ItemWidth 50 *MYWIDTH
#define ItemHeight 50 *MYWIDTH

//图片路径
#define  ImagePath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Documents"]
#define KWIDTH [UIScreen mainScreen].bounds.size.width

@interface MKMessagePhotoView ()

/**
 *  这是背景滚动视图
 */
@property (nonatomic,strong) UIScrollView  *photoScrollView;
@property (nonatomic,strong) MKComposePhotosView *photoItem;
@property (nonatomic,strong) NSMutableArray *array;//展示图片数
@property (nonatomic,strong) NSMutableArray *imgsArr;//沙盒中图片数
@property (nonatomic,strong) NSMutableArray *imagePath;//图片不同的路径

@end
static int k = 10000;//分别提供不同的图片名称
@implementation MKMessagePhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{

    
    ///注册通知,用以接收上传通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upImageWithData:) name:@"upImageWithData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upImageWithDatabaoxiao:) name:@"upImageWithDatabaoxiao" object:nil];

    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, 60*MYWIDTH)];
    _array = [NSMutableArray arrayWithCapacity:0];
    _imgsArr = [NSMutableArray arrayWithCapacity:0];
    _imagePath = [NSMutableArray arrayWithCapacity:0];
    [self addSubview:_photoScrollView];

    
    [self initlizerScrollView:_array];
    [self.delegate upDataUIImageArr:_array.count];

}

///调用布局
-(void)initlizerScrollView:(NSArray *)imgList{

    ///移除之前添加的图片缩略图
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<imgList.count;i++){

        _photoItem = [[MKComposePhotosView alloc]initWithFrame:CGRectMake(5+ i * (ItemWidth + 10*MYWIDTH), 0, ItemWidth, ItemHeight)];
        _photoItem.delegate = self;
        _photoItem.index = i;
        _photoItem.image = (UIImage *)[imgList objectAtIndex:i];
        [self.photoScrollView addSubview:_photoItem];
        
    }
//    if(imgList.count<MaxItemCount){
//        
//        UIImageView *addPhotos =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addImage.jpg"]];
//        [addPhotos setFrame:CGRectMake(5 + (ItemWidth + 20*MYWIDTH) * imgList.count, 10*MYWIDTH, 80*MYWIDTH, 80*MYWIDTH)];
//        [addPhotos setUserInteractionEnabled:YES];
//        
//        [addPhotos addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddPhotos:)]];
//        
//        [self.photoScrollView addSubview:addPhotos];
//    }
    
    NSLog(@"self.frame.origin.y是:%f",self.frame.size.height);
    NSInteger count = MIN(imgList.count +1, MaxItemCount);
    NSLog(@"图片总数量：%ld",_array.count);
        

    [self.photoScrollView setContentSize:CGSizeMake(5 + (ItemWidth + 10*MYWIDTH)*count, 0)];
    
}

///浏览图片的代理方法
-(void)clickAddPhotos:(UITapGestureRecognizer *)gestureRecognizer{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];

    [myActionSheet showInView:self.window];
    
}
//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
       
        [self.delegate addUIImagePicker:picker];
    
    }else{
        NSLog(@"模拟机中无法打开照相机,请在真机中使用");
    }
}


#pragma mark - ImagePicker delegate
//相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [_array addObject:image];

    [self initlizerScrollView:_array];
    [self.delegate upDataUIImageArr:_array.count];
}

//打开相册，可以多选
-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = 4;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    
    [self.delegate addPicker:picker];
    
    
}

/**
 * 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    NSLog(@"assets is %lu",(unsigned long)assets.count);
    NSLog(@"你是什么类型的%@",assets);
    

    
    if (_array.count + assets.count > 4) {
        NSLog(@"图片数量超过3张，目前多出%lu张",(_array.count + assets.count -4));
//        jxt_showAlertTitle([NSString stringWithFormat:@"图片数量最多3张，目前多出%lu张",(_array.count + assets.count -3)]);
        [self showAlert:[NSString stringWithFormat:@"图片数量最多9张，目前多出%lu张",(_array.count + assets.count -4)]];
        return;
    }

   
    for (int i =0; i< assets.count; i++) {
        
        ALAsset *asset = assets[i];
        ///获取到相册图片
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [_array addObject:tempImg];
        
    }
    
    //重新布局
    [self initlizerScrollView:_array];
    [self.delegate upDataUIImageArr:_array.count];

    [picker dismissViewControllerAnimated:YES completion:nil];

}


/// 上传时将原始图片转化为NSData数据,写入沙盒
- (void)upImageWithData:(NSNotification *)notification{
    
//    NSString *uuid = notification.userInfo[@"uuid"];
//
//    //[SVProgressHUD showWithStatus:@"上传图片..."];
//
//
//    for (UIImage *image in _array) {
//
//        NSString* urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/mbtwz/logisticsgoods?action=uploadLogisticsGoodsImg"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        NSDictionary* params = @{@"orderUuid":uuid};
//        [HTNetWorking uploadWithImage:image url:urlStr filename:fileName name:@"img" mimeType:@"image/jpeg" parameters:params progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
//
//        } success:^(id response) {
//            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//            NSLog(@"上传返回%@",str);
//
//            k++;
//        } fail:^(NSError *error) {
//            [SVProgressHUD dismiss];
//
//        }];
//
//    }
    
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    NSDictionary * info = notification.userInfo;
    NSString * surl = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    // 查询条件
//    NSDictionary *params = @{@"action":@"uploadImage",@"params":[NSString stringWithFormat:@"{\"srcname\":\"%@\",\"reportid\":\"%@\"}",@"",info[@"reallystr"]]};
    NSDictionary *params = @{@"action":@"uploadImage",@"reportid":info[@"reallystr"],@"srcname":@""};
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:surl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < _array.count; i++) {
            
            UIImage *image = _array[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *nameStr =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"```上传成功``` %@",nameStr);
        [self showAlert:@"上报成功"];
        [self removeAllObjectsImage];
        [self.ViewController.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"xxx上传失败xxx %@", error);
        ALERT(@"上传图片失败");
    }];

    
    
    //上传后删除之前缓存的文件夹
//    [fileManager removeItemAtPath:ImagePath error:nil];
    
//    NSLog(@"\n\n   上传成功。 \n\n");
    
}
/// 上传时将原始图片转化为NSData数据,写入沙盒
- (void)upImageWithDatabaoxiao:(NSNotification *)notification{
    
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    NSDictionary * info = notification.userInfo;
    NSString * surl = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply"];
    // 查询条件
    NSDictionary *params = @{@"action":@"uploadImage",@"costid":info[@"reallystr"],@"srcname":@""};
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:surl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < _array.count; i++) {
            
            UIImage *image = _array[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *nameStr =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"```上传成功``` %@",nameStr);
        [self showAlert:@"上报成功"];
        [self removeAllObjectsImage];
        [self.ViewController.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"xxx上传失败xxx %@", error);
        ALERT(@"上传图片失败");
    }];
    
    
    
    //上传后删除之前缓存的文件夹
    //    [fileManager removeItemAtPath:ImagePath error:nil];
    
    //    NSLog(@"\n\n   上传成功。 \n\n");
    
}





- (void)removeAllObjectsImage{
    ///上传完成，清空数组
    
    
    
    [_array removeAllObjects];
    [_imagePath removeAllObjects];
    [_imgsArr removeAllObjects];
    
    [self initlizerScrollView:_array];
    [self.delegate upDataUIImageArr:_array.count];
}

#pragma mark - MKComposePhotosViewDelegate

///删除已选中图片并从新写入沙盒
-(void)MKComposePhotosView:(MKComposePhotosView *)MKComposePhotosView didSelectDeleBtnAtIndex:(NSInteger)Index{
    
    [_array removeObjectAtIndex:Index];
    [self initlizerScrollView:_array];
    [self.delegate upDataUIImageArr:_array.count];

    ///先删除原来数组的路径和名称，防止多次添加存储
//    [_imagePath removeAllObjects];
//    [_imgsArr removeAllObjects];
//    
    NSLog(@"删除了第%ld张",(long)Index);

}

///图片浏览的 delegate 方法
-(void)MKComposePhotosView:(MKComposePhotosView *)MKComposePhotosView didSelectImageAtIndex:(NSInteger)Index{
    
    [XLPhotoBrowser showPhotoBrowserWithImages:_array currentImageIndex:Index];
    
}


#pragma mark - 上传操作 自己按需求来吧





////////////暂时隐藏上传
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSURL * URL = [NSURL URLWithString:@""];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"" forHTTPHeaderField:@""];
//        AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//        [request addValue:[NSString stringWithFormat:@"image%d.png",k] forHTTPHeaderField:@"imageName"];
//        //进行上传操作
//        NSURLSessionUploadTask *upLoadTask = [manager uploadTaskWithRequest:request fromData:imageData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
//                                              {
//                                                  if (error) {
//
//                                                      [MBProgressHUD showError:@"请求失败"];
//                                                  }else{
//
//                                                      NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//
//                                                      NSLog(@"请求完成的结果是:%@",dic);
//                                                      //用户默认设置
//                                                      NSUserDefaults *imgLinkDefault = [NSUserDefaults standardUserDefaults];
//                                                      NSArray *aa = [[NSArray alloc] init];
//                                                      aa = [imgLinkDefault objectForKey:@"imgLink"];
//                                                      [aa arrayByAddingObject:[dic objectForKey:@"attachmentPath"]];
//                                                      [imgLinkDefault setObject:aa forKey:@"aa"];
//                                                      [imgLinkDefault synchronize];
//
//                                                  }
//                                              }];
//
//        //开始上传操作
//        [upLoadTask resume];
//    });


//时间
- (void)showAlert:(NSString *)message{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
   
    [promptAlert show];
}
//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}


@end
