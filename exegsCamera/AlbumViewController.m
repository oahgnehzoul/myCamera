//
//  AlbumViewController.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/11.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "AlbumViewController.h"
#import "ZLPhoto.h"
#import "UIImage+ZLPhotoLib.h"
#import "UIButton+WebCache.h"
#import "WCAlertView.h"
#import "PHPhotoLibrary+CustomPhotoAlbum.h"
#import "MBProgressHUD.h"
#import "UIViewController+Alert.h"

@interface AlbumViewController ()<ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate>
@property (weak,nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSString *albumName;

//@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation AlbumViewController

- (instancetype)initWithPhotos:(NSArray *)photos {
    if (self = [super init]) {
        self.assets = photos.mutableCopy;
        self.photos = @[].mutableCopy;
        for (id asset in self.assets) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                photo.asset = asset;
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                ZLCamera *camera = (ZLCamera *)asset;
                photo.thumbImage = [camera thumbImage];
            }else if ([asset isKindOfClass:[UIImage class]]){
                photo.thumbImage = (UIImage *)asset;
                photo.photoImage = (UIImage *)asset;
            }
            [self.photos addObject:photo];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"暂存册";
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];

    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    // 属性scrollView
    [self reloadScrollView];
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _saveButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:15];
        [_saveButton setTitle:@"\U0000e610" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithHexString:kMDColorBaseLevel2] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(doSave:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)doSave:(UIButton *)button {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到现有相册",@"新建相册", nil];
    [as showInView:self.view];
}



- (BOOL)shouldAutorotate {
    return NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //保存到现有相册
        ZLPhotoPickerGroupViewController *groupVc = [[ZLPhotoPickerGroupViewController alloc] init];
        groupVc.assets = self.assets;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:groupVc];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    } else if (buttonIndex == 1) {
        //保存到新建相册
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"新建相簿" message:@"请为此相簿输入名称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"存储" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *input = alertVc.textFields.firstObject;
            self.albumName = input.text;
            [self showWaitingAnimationWithText:@"保存成功"];
            [self.assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZLCamera *camera = (ZLCamera *)obj;
               [[PHPhotoLibrary sharedPhotoLibrary] saveImage:camera.thumbImage ToAlbum:self.albumName completion:^(PHAsset *imageAsset) {
                   [self hideWaitingAnimation];
               } failure:^(NSError *error) {
               }];
            }];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        }];
        okAction.enabled = NO;
        [alertVc addAction:cancelAction];
        [alertVc addAction:okAction];
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"标题";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

- (void)alertTextFieldDidChange:(NSNotification *)notification {
    UIAlertController *alertVc = (UIAlertController *)self.presentedViewController;
    if (alertVc) {
        UITextField *input = alertVc.textFields.firstObject;
        UIAlertAction *saveAction = alertVc.actions.lastObject;
        saveAction.enabled = input.text.length > 0;
    }
}


- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 3;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count;
    
    CGFloat width = self.view.frame.size.width / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        
        // UIButton
//        if (i == self.assets.count){
//            // 最后一个Button
//            [btn setImage:[UIImage ml_imageFromBundleNamed:@"camera"] forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(takeCamera) forControlEvents:UIControlEventTouchUpInside];
//        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLCamera class]]) {
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
            }else if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
            }else if ([self.assets[i] isKindOfClass:[NSString class]]){
                [btn sd_setImageWithURL:[NSURL URLWithString:self.assets[i]] forState:UIControlStateNormal];
            }else if([self.assets[i] isKindOfClass:[ZLPhotoPickerBrowserPhoto class]]){
                ZLPhotoPickerBrowserPhoto *photo = self.assets[i];
                photo.toView = btn.imageView;
                [btn sd_setImageWithURL:photo.photoURL forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
//        }
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}
- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    
    
    pickerBrowser.photos = self.photos;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}


@end
