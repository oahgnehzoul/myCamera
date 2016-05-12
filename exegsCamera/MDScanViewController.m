//
//  MDScannerViewController.m
//  MeiMeiDa
//
//  Created by Yulin Ding on 9/7/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDScanViewController.h"
#import "MTBBarcodeScanner.h"
#import "WCAlertView.h"
//#import "MDWebViewController.h"
//#import "MDWebViewNavigation.h"

@interface MDScanViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIImageView *rectView;
@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, assign) BOOL isDeliveryCode;
@property (nonatomic, assign) BOOL isFlashEnabeld;

@end

@implementation MDScanViewController

- (instancetype)initWithDeliveryCode {
    if (self = [super init]) {
        _isDeliveryCode = YES;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_scanner && !_scanner.isScanning) {
        [self startScanning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
   
    [self renderNavBar];
    
    _previewView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_previewView];
    _previewView.backgroundColor = [UIColor blackColor];
    
    _rectView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_rectView];
    
    CGFloat rectWidth = self.view.width - 120;
    CGFloat rectHeight = rectWidth;
    CGFloat rectLeft = (self.view.width - rectWidth)/2;
    CGFloat rectTop = (self.view.height - rectHeight)/2 - 60;
    
    if (_isDeliveryCode) {
        rectWidth = self.view.width - 160;
        rectHeight = self.view.height - 120;
        rectLeft = (self.view.width - rectWidth)/2;
        rectTop = (self.view.height - rectHeight - 60)/2;
    }
    _rectView.frame = CGRectMake(rectLeft, rectTop, rectWidth, rectHeight);
    UIImage *rectImage = [[UIImage imageNamed:@"MDScanRect"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    _rectView.image = rectImage;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLabel.backgroundColor = [UIColor whiteColor];
    tipLabel.font = [MDFont fontWithSize:14];
    tipLabel.textColor = [UIColor colorWithHexString:kMDColorBaseLevel2];
    tipLabel.text = _isDeliveryCode ? @"请扫描条形码" : @"请扫描二维码";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.clipsToBounds = YES;
    [self.view addSubview:tipLabel];
    [tipLabel sizeToFit];
    
    tipLabel.size = CGSizeMake(tipLabel.width + 20, tipLabel.height + 15);
    tipLabel.layer.cornerRadius = tipLabel.height/2;
    
    if (_isDeliveryCode) {
        tipLabel.origin = CGPointMake(0, _rectView.top + (_rectView.height - tipLabel.width + 80) / 2);
        CGFloat transformAngle = M_PI/2;
        tipLabel.transform = CGAffineTransformMakeRotation(transformAngle);
    } else {
        tipLabel.origin = CGPointMake((self.view.width - tipLabel.width)/2, _rectView.bottom + 40);
    }
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanner stopScanning];
}

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    
    return _scanner;
}

- (void)startScanning {
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                [self handlerCode:code.stringValue];
            }];
        } else {
            [self displayPermissionMissingAlert];
        }
    }];
}

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"请先授权空格访问你的相机。设置方法:设置－隐私－相机－空格－开启";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"无相机";
    } else {
        message = @"未知错误";
    }
    
    [[[UIAlertView alloc] initWithTitle:@"扫码不可用"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
}



- (void)handlerCode:(NSString *)code {
    if (!code) {
        return;
    }
    [self.scanner stopScanning];
    NSURL *url = [NSURL URLWithString:code];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [WCAlertView showAlertWithTitle:@"扫码结果" message:code customizationBlock:^(WCAlertView *alertView) {
            //NOTHING
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 0) {
                UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
                appPasteBoard.persistent = YES;
                [appPasteBoard setString:code];
            }
            [self startScanning];
        } cancelButtonTitle:@"复制" otherButtonTitles:@"确定", nil];
        return;
    }

}


- (void)renderNavBar {
    TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:_isFlashEnabeld ? @"\U0000e613" : @"\U0000e612" size:22 color:[UIColor whiteColor]];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage iconWithInfo:iconInfo] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFlash)];
    NSMutableArray *items = @[rightButtonItem].mutableCopy;
   
    // iOS8 才支持识别相册二维码
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
        TBCityIconInfo *iconInfo2 = [TBCityIconInfo iconInfoWithText:@"\U0000e611" size:24 color:[UIColor whiteColor]];
        UIBarButtonItem *rightButtonItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage iconWithInfo:iconInfo2] style:UIBarButtonItemStylePlain target:self action:@selector(doPhoto)];
        [items addObject:rightButtonItem2];
    }
    
    self.navigationItem.rightBarButtonItems = items;
}

- (void)toggleFlash {
    _isFlashEnabeld = !_isFlashEnabeld;
    [self renderNavBar];
    self.scanner.torchMode = _isFlashEnabeld ? MTBTorchModeOn : MTBTorchModeOff;
}

- (void)doPhoto {
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
            [self handlerCode:result];
        }
    }];
}

@end
