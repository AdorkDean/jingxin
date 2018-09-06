//
//  LXPreViewVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/15.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "LXPreViewVC.h"
#import <QuickLook/QuickLook.h>
#import "AFNetworking.h"


@interface LXPreViewVC ()<QLPreviewControllerDataSource>
@property (strong, nonatomic)QLPreviewController *previewController;
@property (copy, nonatomic)NSURL *fileURL; //文件路径
@end

@implementation LXPreViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
        [self presentViewController:self.previewController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.previewController refreshCurrentPreviewItem];
    }else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"下载中...";
      NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            _hud.labelText = @"加载完成";
            [_hud hide:YES afterDelay:1];
            self.fileURL = filePath;
            [self presentViewController:self.previewController animated:YES completion:nil];
            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
            [self.previewController refreshCurrentPreviewItem];
        }];
        [downloadTask resume];
    }
    
}
//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}


@end
