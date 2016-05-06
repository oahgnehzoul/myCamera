//
//  ViewController.m
//  exegsCamera
//
//  Created by oahgnehzoul on 15/12/28.
//  Copyright © 2015年 exegs. All rights reserved.
//

#import "ViewController.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PHPhotoLibrary+CustomPhotoAlbum.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 100, 50, 50);
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(doSetup) forControlEvents:UIControlEventTouchUpInside];
}

// 创建相簿
- (void)doSetup {
    //1.
//    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
//    [lib addAssetsGroupAlbumWithName:@"test" resultBlock:^(ALAssetsGroup *group) {
//        NSLog(@"success");
//    } failureBlock:^(NSError *error) {
//        NSLog(@"false");
//    }];
    
    //2
    UIImage *image = [UIImage imageNamed:@"IMG_0533.JPG"];
    [[PHPhotoLibrary sharedPhotoLibrary] saveImage:image ToAlbum:@"相册1" completion:^(PHAsset *imageAsset) {
        
    } failure:^(NSError *error) {
        
    }];
}


@end
