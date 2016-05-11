//
//  ViewController1.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/6.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "ViewController1.h"
#import "UMSocial.h"
#import "MDShareService.h"
#import "MDShareView.h"
#import <QiniuSDK.h>
#import "AFNetWorking.h"
#import "QiniuUploader.h"

@interface ViewController1 ()<MDShareViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *uploadButton;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) UIImage *pickImage;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"挑战";
    
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _imgView.image = [UIImage imageNamed:@"1.jpg"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap)];
    _imgView.userInteractionEnabled = YES;
    [_imgView addGestureRecognizer:tap];
    [self.view addSubview:_imgView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    
    self.uploadButton.frame = CGRectMake(_imgView.left, _imgView.bottom + 20, 40, 40);
    [self.view addSubview:self.uploadButton];
    self.pickImage = _imgView.image;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _shareButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:15];
        [_shareButton setTitle:@"\U0000e601" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor colorWithHexString:kMDColorBaseLevel2] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(doShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _uploadButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:15];
        [_uploadButton setTitle:@"\U0000e608" forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor colorWithHexString:kMDColorBaseLevel2] forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(doUpload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}

- (void)doUpload {
    
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(self.imgView.image, 1.0f)];
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:file];
    [uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
        NSLog(@"index:%ld key:%@",(long)index,key);
    }];
    
    [uploader setUploadOneFileProgress:^(AFHTTPRequestOperation *operation, NSInteger index, double percent){
        NSLog(@"index:%ld percent:%lf",(long)index,percent);
        
    }];
    [uploader setUploadAllFilesComplete:^(void){
        NSLog(@"complete");
    }];
    [uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
        NSLog(@"%@",error);
    }];
    [uploader startUpload];

    
//    [QiniuToken registerWithScope:@"exegscamera:a.jpg" SecretKey:KQiniuSecretKey Accesskey:KQiniuAccessKey TimeToLive:10];
//    NSString *token = @"iN7NgwM31j4-BZacMjPrOQBs34UG1maYCAQmhdCV:EfmGKkmyhpPRrqLXFP1SVcmUJvU=:eyJzY29wZSI6InF0ZXN0YnVja2V0IiwiZGVhZGxpbmUiOjE0NjI4NjkyMDV9";
//    QNUploadManager *upMnanger = [[QNUploadManager alloc] init];
//    NSData *data = UIImagePNGRepresentation(self.imgView.image);
//    [upMnanger putData:data key:@"fadf" token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        NSLog(@"info%@\n%@",info,resp);
//    } option:nil];
    
    
//    NSString *token = @"iN7NgwM31j4-BZacMjPrOQBs34UG1maYCAQmhdCV:EfmGKkmyhpPRrqLXFP1SVcmUJvU=:eyJzY29wZSI6InF0ZXN0YnVja2V0IiwiZGVhZGxpbmUiOjE0NjI4NjkyMDV9";
    
    //iN7NgwM31j4-BZacMjPrOQBs34UG1maYCAQmhdCV:tuSWvG7-vv8bpSBHEPAspEHYaxg=:eyJzY29wZSI6InF0ZXN0YnVja2V0IiwiZGVhZGxpbmUiOjE0NjI5MzU4ODB9
    
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    NSData *data = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];
//    [upManager putData:data key:@"hello" token:token
//              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                  NSLog(@"%@", info);
//                  NSLog(@"%@", resp);
//              } option:nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://115.231.183.102:9090/api/quick_start/simple_image_example_token.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.domain = responseObject[@"domain"];
        self.token = responseObject[@"uptoken"];
        [self uploadImageToQNFilePath:[self getImagePath:self.pickImage]];
    }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error);
      }];
}

- (void)uploadImageToQNFilePath:(NSString *)filePath {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        NSLog(@"%@/%@", self.domain, resp[@"key"]);
//        [self.preViewImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.domain, resp[@"key"]]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        
    }
        option:uploadOption];
}


//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}


-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    NSLog(@"%@",platformName);
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
//    if (platformName isEqualToString:<#(nonnull NSString *)#>) {
//        <#statements#>
//    }
}
- (void)doShare:(UIButton *)button {
    
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kMDUMengAppKey shareText:@"123" shareImage:[UIImage imageNamed:@"1.jpg"] shareToSnsNames:@[UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToDouban] delegate:self];
    ;
    
//    [UMSocialSnsService presentSnsController:self appKey:kMDUMengAppKey shareText:@"123" shareImage:[UIImage imageNamed:@"1.jpg"] shareToSnsNames:[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray delegate:self];
    
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"图文分享" message:@"图文分享" preferredStyle:UIAlertControllerStyleActionSheet];
//    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:snsPlatform.displayName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            //设置分享内容，和回调对象
//            NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
//            UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];
//            
//            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
//            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        }];
//        [alertController addAction:alertAction];
//    }
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [alertController dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [alertController addAction:cancelAction];
//    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
//    if (popover)
//    {
//        popover.sourceView = button;
//        popover.sourceRect = button.bounds;
//        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    }
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
//    if ([self.view viewWithTag:999]) {
//        [MDShareView dismissInView:self.view animated:YES];
//        return;
//    }
//    MDShareView *shareView = [MDShareView presentInView:[MDUtil mainWindow] withShareTypes:MDShareTypeWeChatSession | MDShareTypeWeibo | MDShareTypeQQ animated:YES];
//    shareView.tag = 999;
//    shareView.delegate = self;
}

- (MDShareItem *)itemForShare:(MDShareType)shareType {
    MDShareItem *item = [MDShareItem new];
    item.title = @"分享图片";
    item.image = [UIImage imageNamed:@"1.jpg"];
    item.url = @"http://www.baidu.com";
    return item;
}

- (void)doTap {
    [[MDImageEditorService sharedInstance] startWithImage:self.imgView.image completionHandler:^(NSError *error, UIImage *image) {
        if (image) {
            //image为处理之后的图片。
            NSLog(@"1");
        }
    }];

}




@end
