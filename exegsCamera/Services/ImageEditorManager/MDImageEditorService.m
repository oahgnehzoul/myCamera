//
//  MDImageEditorService.m
//  MeiMeiDa
//
//  Created by Jason Wong on 15/10/12.
//  Copyright © 2015年 Jason Wong. All rights reserved.
//

#import "MDImageEditorService.h"
#import <PhotoEditFramework/PhotoEditFramework.h>

@interface MDImageEditorService () <pg_edit_sdk_controller_delegate>

@property (nonatomic, strong) MDImageEditorServiceCompletionHandler handler;

@end

@implementation MDImageEditorService

+ (instancetype)sharedInstance {
    static MDImageEditorService *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setup {
#if !(TARGET_IPHONE_SIMULATOR)
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *key = nil;
    if ([identifier isEqualToString:@"com.exegsCamera"]) {
        key = Camera_API_Key;
    }
    
    
    if (![pg_edit_sdk_controller sStart:key]) {
        
        /*
         *  http://sdk.camera360.com
         */
    }
#endif
}

- (void)startWithImage:(UIImage *)image completionHandler:(MDImageEditorServiceCompletionHandler)completionHandler {
#if !(TARGET_IPHONE_SIMULATOR)
    self.handler = completionHandler;
    md_dispatch_sync_on_main_thread(^{
        pg_edit_sdk_controller *editCtl = nil;
        {
            //构建编辑对象    Construct edit target
            pg_edit_sdk_controller_object *obje = [[pg_edit_sdk_controller_object alloc] init];
            {
                //输入原图  Input original
                obje.pCSA_fullImage = [image copy];
            }
            editCtl = [[pg_edit_sdk_controller alloc] initWithEditObject:obje withDelegate:self];
        }
        
        if (editCtl) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                    withAnimation:UIStatusBarAnimationFade];
            [MDNavigator presentViewController:editCtl animated:YES completion:nil];
        }
    });
    
#endif
}

// 完成后调用，点击保存
- (void)dgPhotoEditingViewControllerDidFinish:(UIViewController *)pController object:(pg_edit_sdk_controller_object *)object {
    if (self.handler) {
        self.handler(nil, [UIImage imageWithData:object.pOutEffectOriData]);
        self.handler = nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];

    [pController dismissViewControllerAnimated:YES completion:nil];
}

// 完成后调用， 点击取消
- (void)dgPhotoEditingViewControllerDidCancel:(UIViewController *)pController withClickSaveButton:(BOOL)isClickSaveBtn {
    if (self.handler) {
        self.handler([NSError errorWithDomain:@"com.kongge" code:-1 userInfo:nil], nil);
        self.handler = nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    [pController prefersStatusBarHidden];
    [pController dismissViewControllerAnimated:YES completion:nil];
}

@end
