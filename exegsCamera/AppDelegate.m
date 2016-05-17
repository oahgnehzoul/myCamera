//
//  AppDelegate.m
//  exegsCamera
//
//  Created by oahgnehzoul on 15/12/28.
//  Copyright © 2015年 exegs. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UMSocial.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import "QiniuUploader.h"
#import "Routable.h"
#import "MDScanViewController.h"
#import "ZLCameraViewController.h"
#import "ViewController2.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [QiniuToken registerWithScope:@"exegscamera:a.jpg" SecretKey:KQiniuSecretKey Accesskey:KQiniuAccessKey TimeToLive:10];


    [UMSocialData setAppKey:kMDUMengAppKey];
    [UMSocialWechatHandler setWXAppId:kMDWeChatAppKey appSecret:kMDWeChatAppSecret url:@"https://github.com/oahgnehzoul/myCamera"];
    [UMSocialQQHandler setQQWithAppId:kMDQQAppId appKey:kMDQQAppKey url:@"https://github.com/oahgnehzoul/myCamera"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:kMDWeiboAuthCallback];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kMDWeiboAppKey secret:kMDWeiboAppSecret RedirectURL:kMDWeiboAuthCallback];
    
    [self setupWithOptions:nil];
    JWNavigationViewController *nav = [[JWNavigationViewController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    [[Routable sharedRouter] setNavigationController:nav];
    [[Routable sharedRouter] map:@"scan" toController:[MDScanViewController class]];
    [[Routable sharedRouter] map:@"photo" toController:[ViewController2 class]];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = nav;
    
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (!result) {
        NSLog(@"false");
    }
    return result;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:@"photo"]) {
        [[Routable sharedRouter] open:@"photo" animated:YES];
    }
    if ([shortcutItem.type isEqualToString:@"scan"]) {
        [[Routable sharedRouter] open:@"scan" animated:YES];
    }
}

- (void)setupWithOptions:(NSDictionary *)launchOptions {
    // 3D Touch
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(shortcutItems)]) {
        UIApplicationShortcutIcon *itemAIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"photo"];
        UIApplicationShortcutItem *itemA = [[UIApplicationShortcutItem alloc] initWithType:@"photo" localizedTitle:@"拍照" localizedSubtitle:nil icon:itemAIcon userInfo:nil];
        UIApplicationShortcutIcon *itemBIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"scan"];
        UIApplicationShortcutItem *itemB = [[UIApplicationShortcutItem alloc] initWithType:@"scan" localizedTitle:@"扫一扫" localizedSubtitle:nil icon:itemBIcon userInfo:nil];
        [UIApplication sharedApplication].shortcutItems = @[itemA,itemB];
    }
    
    
    // init font
    [TBCityIconFont setFontName:@"iconfont"];
    // camera360
    [[MDImageEditorService sharedInstance] setup];
    
//    md_dispatch_async_on_global_thread(^{
////        [[MDShareService shareInstance] setup];
////        [[MDShareService sharedInstance] setup];
//
//    });

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
