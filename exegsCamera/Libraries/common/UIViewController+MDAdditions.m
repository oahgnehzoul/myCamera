//
//  UIViewController+MDAdditions.m
//  MeiMeiDa
//
//  Created by Jason Wong on 15/6/6.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import "UIViewController+MDAdditions.h"

@implementation UIViewController (MDAdditions)

+ (UIViewController *)findBestViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:viewController.presentedViewController];
        
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)viewController;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return viewController;
        
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController *svc = (UINavigationController *)viewController;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return viewController;
        
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController *svc = (UITabBarController *)viewController;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return viewController;
        
    } else {
        // Unknown view controller type, return last child view controller
        return viewController;
        
    }
    
}

+ (UIViewController *)currentViewController {
//    // Find best view controller
//    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    return [UIViewController findBestViewController:viewController];
    UIViewController *topViewController = [MDUtil mainWindow].rootViewController;
    UIViewController *temp = nil;
    
    while (YES) {
        temp = nil;
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            temp = ((UINavigationController *)topViewController).visibleViewController;
        }
        
        else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            temp = ((UITabBarController *)topViewController).selectedViewController;
        }
        
        else if (topViewController.presentedViewController != nil) {
            temp = topViewController.presentedViewController;
        }
        
        
        if (temp != nil) {
            topViewController = temp;
        }
        
        else {
            break;
        }
    }
    
    return topViewController;
}

@end
