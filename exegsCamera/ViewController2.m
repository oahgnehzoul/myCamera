//
//  ViewController2.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/6.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "ViewController2.h"
#import "ZLPhoto.h"
#import "AlbumViewController.h"
#import "MDScanViewController.h"
typedef NS_ENUM(NSInteger, MyButtonType) {
    MyButtonTypeCamera = 0,
    MyButtonTypeSelfCamera = 1,
    MyButtonTypeAlbum = 2,
    MyButtonTypeWallPaper = 3
};

@interface ViewController2 ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;

@property (weak,nonatomic) UIScrollView *scrollView;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照";
    self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight - 49)];
    self.backgroundView.image = [UIImage imageNamed:@"1234.png"];
    self.backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.backgroundView];
    
    NSArray *icons = @[@"\U0000e60d",@"\U0000e615",@"\U0000e60a",@"\U0000e614"];
    NSArray *titles = @[@"相机",@"扫一扫",@"相册",@"精选壁纸"];
    CGFloat btnWidth = (APP_SCREEN_WIDTH - 30 * 2 - 15) / 2;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [self generateButton:icons[i] title:titles[i]];
        btn.frame = CGRectMake(30 + (i % 2) * (btnWidth + 15), 230 + (i / 2) * (13 + 73), btnWidth, 73);
        btn.tag = i;
        [self.view addSubview:btn];
    }
    
}

- (UIButton *)generateButton:(NSString *)iconfont title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(150, 75);
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    // 251 227 202
    button.backgroundColor = [UIColor colorWithRed:252/255.0 green:191/255.0 blue:204/255.0 alpha:1];
//    button.backgroundColor = [UIColor colorWithRed:252/255.0 green:227/255.0 blue:204/255.0 alpha:1];
    //绿
//    button.backgroundColor = [UIColor colorWithRed:177/255.0 green:238/255.0 blue:215/255.0 alpha:1];

    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    NSString *str = [NSString stringWithFormat:@"%@  %@",iconfont,title];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"iconfont" size:25]} range:NSMakeRange(0, 1)];
    [button addTarget:self action:@selector(doButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setAttributedTitle:attrStr forState:UIControlStateNormal];
    return button;
}

- (void)doButtonAction:(UIButton *)btn {
    NSInteger tag = btn.tag;
    switch (tag) {
        case 0: {
            ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
            // MaxCount, Default = 9
            // CallBack
            cameraVc.callback = ^(NSArray *status){
                
                [self.assets addObjectsFromArray:status];
//                [self reloadScrollView];
                
                for (ZLPhotoAssets *asset in status) {
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                        photo.asset = asset;
                    }else if ([asset isKindOfClass:[ZLCamera class]]){
                        ZLCamera *camera = (ZLCamera *)asset;
                        photo.thumbImage = [camera thumbImage];
                    }
                    [self.photos addObject:photo];
                }
            };
            [cameraVc showPickerVc:self];

            break;
        }
        case 1: {
            [MDNavigator openViewController:[[MDScanViewController alloc] init] animated:YES];
            break;
        }
        case 2: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:NO];
                //显示Image Picker
                [self presentViewController:imgPickerVC animated:YES completion:nil];
            } else {
                [WCAlertView showAlertWithTitle:@"无相册可用" message:nil customizationBlock:^(WCAlertView *alertView) {
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                } cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            }
        }
        default:
            break;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *srcImage        = [info objectForKey:UIImagePickerControllerOriginalImage];
    CIContext *context       = [CIContext contextWithOptions:nil];
    CIDetector *detector     = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:nil];
    CIImage *image           = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features        = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    NSString *result         = feature.messageString;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (result) {
//            [self handlerCode:result];
        }
    }];
}



- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
