//
//  AppDelegate.m
//  exegsCamera
//
//  Created by oahgnehzoul on 15/12/28.
//  Copyright © 2015年 exegs. All rights reserved.
//

#import "AppDelegate.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import "RootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupWithOptions:nil];
    JWNavigationViewController *nav = [[JWNavigationViewController alloc] initWithRootViewController:[[RootViewController alloc] init]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = nav;
    
    
    
    // Override point for customization after application launch.
//    [pg_edit_sdk_controller sStart:@"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"];
    return YES;
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:@"photo"]) {
//        []
        NSURL *url = [NSURL URLWithString:@"home://"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)setupWithOptions:(NSDictionary *)launchOptions {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(shortcutItems)]) {
        UIApplicationShortcutIcon *itemAIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"photo"];
        UIApplicationShortcutItem *itemA = [[UIApplicationShortcutItem alloc] initWithType:@"photo" localizedTitle:@"拍照" localizedSubtitle:nil icon:itemAIcon userInfo:nil];
        [UIApplication sharedApplication].shortcutItems = @[itemA];
    }
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
