//
//  MyMeansViewController.m
//  YiRuanTong
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "MyMeansViewController.h"

@interface MyMeansViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate>{
    UITableView *_myTab;
    
    UIImageView *_headImage;
    
    NSString *_namestr;
    NSString *_sexstr;
    NSString *_agestr;

    NSString *_imageurl;
    NSString *_mobilestr;
    NSString *_companystr;
    
    UIImagePickerController *_myPicker;
}


@end

@implementation MyMeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    
    self.navigationItem.rightBarButtonItem = nil;

    self.view.backgroundColor = UIColorFromRGB(0xf7f9fa);
    [self createData];

    [self createView];
}

- (void)createData{
    //从userdefault 中取出数据
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _namestr = [user objectForKey:@"name"];
    [[user objectForKey:@"sex"] isEqualToString:@"1"]?(_sexstr = @"男"):(_sexstr = @"女");
    _agestr = [user objectForKey:@"age"];
    // _imageurl = [user objectForKey:@"image"];
    _mobilestr = [user objectForKey:@"mobile"];
    _companystr = [user objectForKey:@"company"];
    
    /*
     //从userdefault 中取出数据
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
     NSString *account = [userDefault objectForKey:@"account"];
     accountLabel1.text = account;
     NSString *name = [userDefault objectForKey:@"name"];
     nameLabel1.text = name;
     NSString *sex = [userDefault objectForKey:@"sex"];
     [sex isEqualToString:@"1"]?(sexLabel1.text=@"男"):(sexLabel1.text=@"女");
     
     NSString *age = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"age"]];
     ageLabel1.text = age;
     NSString *positon = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"myposition"]];
     positionLabel1.text = positon;
     
     NSString *cellno = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"cellno"]];
     cellnoLabel1.text = cellno;
     NSString *telno = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"telno"]];
     telnoLabel1.text = telno;
     NSString *email = [userDefault objectForKey:@"email"];
     emailLabel1.text = email;
     NSString *note = [userDefault objectForKey:@"note"];
     noteLabel1.text = note;
     */
    //DebugLog(@"%@>   %@>    %@>   %@>   %@>",[user objectForKey:@"myposition"],[user objectForKey:@"cellno"],[user objectForKey:@"telno"],[user objectForKey:@"email"],[user objectForKey:@"note"]);
}
-(void)createView{
    _myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    _myTab.showsVerticalScrollIndicator = NO;
    _myTab.scrollEnabled = NO;
    _myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTab.delegate = self;
    _myTab.dataSource = self;
    _myTab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_myTab];
    
}





#pragma mark tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80 * MYHEIGHT;
    }else{
        return 50 * MYHEIGHT;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xf7f9fa);
    return header;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15 * MYWIDTH];
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        NSArray *arr = @[@"头像",@"姓名",@"性别",@"年龄"];
        cell.textLabel.text = arr[indexPath.row];

        if (indexPath.row == 0) {
            //头像
            if (_headImage == nil) {
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12 * MYWIDTH, 79 * MYHEIGHT, KscreenWidth - 12 * MYWIDTH, 1)];
                line.backgroundColor = UIColorFromRGB(0xf7f9fa);
                [cell addSubview:line];
                
                _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(KscreenWidth - 72 * MYHEIGHT, 10 * MYHEIGHT, 60 * MYHEIGHT, 60 * MYHEIGHT)];
                if (_imageurl.length == 0) {
                    _headImage.image = [UIImage imageNamed:@"AppIcon"];
                }else{
                   // [_headImage sd_setImageWithURL:[NSURL URLWithString:_imageurl]];
                }
                _headImage.image = [UIImage imageNamed:@"AppIcon"];

                _headImage.layer.masksToBounds = YES;
                _headImage.layer.cornerRadius = 30 * MYHEIGHT;
                [cell addSubview:_headImage];
            }else{
                if (_imageurl.length == 0) {
                    _headImage.image = [UIImage imageNamed:@"AppIcon"];
                }else{
                    _headImage.image = [UIImage imageNamed:@"AppIcon"];

                   // [_headImage sd_setImageWithURL:[NSURL URLWithString:_imageurl]];
                }
            }
        }else{
            
            NSArray *otherArr = @[@"",_namestr,_sexstr,_agestr];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12 * MYWIDTH, 49 * MYHEIGHT, KscreenWidth - 12 * MYWIDTH, 1)];
            line.backgroundColor = UIColorFromRGB(0xf7f9fa);
            [cell addSubview:line];
            
            UILabel *otherLab = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth - 200 * MYWIDTH, 10 * MYHEIGHT, 170 * MYWIDTH, 30 * MYHEIGHT)];
            otherLab.textAlignment = NSTextAlignmentRight;
            otherLab.font = [UIFont systemFontOfSize:13 * MYWIDTH];
            otherLab.textColor = UIColorFromRGB(0x333333);
            otherLab.text = [NSString stringWithFormat:@"%@",otherArr[indexPath.row]];
            [cell addSubview:otherLab];
        }
    }else{
        NSArray *arr = @[@"部门",@"手机",@"固话",@"邮箱",@"个性签名",@"说明"];
        cell.textLabel.text = arr[indexPath.row];

        return cell;
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //选取头像
        //换头像
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //添加Button
        [alertSheet addAction: [UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //处理点击拍照
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                _myPicker = [[UIImagePickerController alloc] init];
                _myPicker.delegate = self;
                _myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _myPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                _myPicker.allowsEditing = YES;
                [self presentViewController:_myPicker animated:YES completion:nil];
                NSLog(@"选择相机");
            }else{
                NSLog(@"不支持相机");
            }
        }]];
        [alertSheet addAction: [UIAlertAction actionWithTitle: @"从相册中选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //处理点击从相册选取
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                NSLog(@"支持图库");
                _myPicker = [[UIImagePickerController alloc] init];
                _myPicker.delegate = self;
                _myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _myPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                _myPicker.allowsEditing = YES;
                //[self presentModalViewController:_myPicker animated:YES];
                [self presentViewController:_myPicker animated:YES completion:nil];
                NSLog(@"选择相册");
            }
        }]];
        [alertSheet addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertSheet animated: YES completion: nil];
    }
    
}

#pragma mark imagePicker代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消选取图片
    [self dismissViewControllerAnimated:YES completion:^{
        // NSLog(@"取消选取图片");
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_myPicker dismissViewControllerAnimated:YES completion:nil];
    //[MBProgressHUD showMessage:@"正在上传"];
    
    
    
    UIImage *image = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager POST:@"http://www.shhy-yy.com/api/user/avatar.json" parameters:@{@"token":[user objectForKey:@"token"]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
//        
//        NSData *data = UIImageJPEGRepresentation(image,1.0);
//        //NSLog(@"====%@",data);
//        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        // NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        //NSLog(@"===%@",responseObject);
//        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
//            [user setObject:[responseObject objectForKey:@"path"] forKey:@"image"];
//            [user synchronize];
//            _imageurl = [responseObject objectForKey:@"path"];
//            [self clearChangeImage];
//            
//            
//            self.returnMyImage(_imageurl);
//        }else if ([[responseObject objectForKey:@"status"] intValue] == 0){
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"info"]]];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"网络错误"];
//    }];
    
    
    
    
}



//清除之前头像，下载新头像
-(void)clearChangeImage{
    
    
    
    
    [[[SDWebImageManager sharedManager]imageCache] clearDisk];
    [[[SDWebImageManager sharedManager]imageCache] clearMemory];
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_imageurl] placeholderImage:[UIImage imageNamed:@"zwtp"]];
    
   // [MBProgressHUD hideHUD];
    
}







-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        
        [self back];
        NSNotification *mynotification = [NSNotification notificationWithName:@"Login_backLogin" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:mynotification];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark 图片横屏
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
