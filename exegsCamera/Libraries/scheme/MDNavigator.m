//
//  MDNavigator.m
//  MeiMeiDa
//
//  Created by Jason Wong on 15/4/25.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import "MDNavigator.h"
#import "Routable.h"
#import "MDUtil.h"
//#import "MDExploreMCoinService.h"
//#import "UIViewController+MDAdditions.h"

@implementation MDNavigator

+ (instancetype)sharedInstance {
    static MDNavigator *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSMutableArray *)maps {
    if (!_maps) {
        _maps = @[].mutableCopy;
    }
    
    return _maps;
}

+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate {
    //如果是支付唤起，则交由MDPayService处理
//    if ([MDPayService isFromPayScheme:url]) {
//        [MDPayService openURL:url withOptions:nil];
//        return YES;
//    }
 
//    if ([url.scheme isEqualToString:kMDSchemeProtocol]) {
//        [self closeAllAndOpen:url.absoluteString animated:NO];
//        return YES;
//    }
    
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        [self open:url.absoluteString animated:YES];
        return YES;
    }
    
//    if ([MDShareService isFromShareScheme:url]) {
//        [MDShareService openURL:url];
//        return YES;
//    }
    
    return YES;
}

+ (void)open:(NSString *)url animated:(BOOL)animated {
    return [self _openURL:[NSURL URLWithString:[MDUtil urlEncodeIgnoreURLSymbol:url]] closeAll:NO animated:animated];
}

+ (void)closeOneAndOpen:(NSString *)url animated:(BOOL)animated {
    [self popSomeViewControllers:1];
    
    if (url.length > 0) {
        [self _openURL:[NSURL URLWithString:url] closeAll:NO animated:animated];
    }
}

+ (void)closeSomeAndOpen:(NSInteger)count
                 andOpen:(NSString *)url
                animated:(BOOL)animated {
    [self popSomeViewControllers:count];
    
    if (url.length > 0) {
        [self _openURL:[NSURL URLWithString:url] closeAll:NO animated:animated];
    }
}


+ (void)closeAllAndOpen:(NSString *)url animated:(BOOL)animated {
    return [self _openURL:[NSURL URLWithString:url] closeAll:YES animated:animated];
}

+ (void)popSomeViewControllers:(NSInteger)count {
    NSMutableArray *viewControllers = [[UIViewController currentViewController].navigationController.viewControllers mutableCopy];
    if (count >= [viewControllers count]) {
        [self popToRoot];
        return;
    }
    
    [viewControllers removeObjectsInRange:NSMakeRange(viewControllers.count - count, count)];
    [UIViewController currentViewController].navigationController.viewControllers = [viewControllers copy];
}

+ (void)_openURL:(NSURL *)url closeAll:(BOOL)closeAll animated:(BOOL)animated {
    if (closeAll) {
        [self popToRoot];
    }
    
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        NSString *nativeSchemeURL = [MDUtil getNativeSchemeURLFromWeb:url];
        if (nativeSchemeURL.length > 0) {
            url = [NSURL URLWithString:nativeSchemeURL];
        } else {
            url = [NSURL URLWithString:[MDUtil urlDecode:url.absoluteString]];
            [[Routable sharedRouter] open:[NSString stringWithFormat:@"unsafebrowse/%@", [MDUtil urlEncode:url.absoluteString]] animated:YES];
            return;
        }
    }
    
//    if (!url.scheme) {
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", kMDSchemeProtocol, url.absoluteString]];
//    }
    
//    if (![url.scheme isEqualToString:kMDSchemeProtocol] || !url.host) {
//        return;
//    }
//    
//    if ([url.host isEqualToString:@"home"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMDRootViewControllerSwitchNotification object:@0];
//        return;
//    }
//    
//    if ([url.host isEqualToString:@"square"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMDRootViewControllerSwitchNotification object:@1];
//        return;
//    }
//    
//    if ([url.host isEqualToString:@"news"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMDRootViewControllerSwitchNotification object:@3];
//        return;
//    }
//    
//    if ([url.host isEqualToString:@"me"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMDRootViewControllerSwitchNotification object:@4];
//        return;
//    }
    
//    NSString *path = [url.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://", kMDSchemeProtocol] withString:@""];
//    [[Routable sharedRouter] open:path animated:YES];
}

+ (void)popToRoot {
    // todo, 暂时只考虑pop
    [[[Routable sharedRouter] navigationController] popToRootViewControllerAnimated:NO];
}

+ (void)openViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIViewController currentViewController].navigationController pushViewController:viewController animated:animated];
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [[UIViewController currentViewController] presentViewController:
     [[JWNavigationViewController alloc] initWithRootViewController:viewController] animated:animated completion:completion];
}

+ (void)popViewControllerAnimated:(BOOL)animated {
    [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
}

+ (UINavigationController *)navigationController {
    return [[Routable sharedRouter] navigationController];
}


/**
 *  注意，他返回的是当前显示的viewcontroller，如果你在VCA里调用，VCA被pop，但还没被销毁，VCA里有调用了currentViewController，返回的是pop之后的显示的vc。
 */
+ (UIViewController *)currentViewController {
    return [UIViewController currentViewController];
}

@end
