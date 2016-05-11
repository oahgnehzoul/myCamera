//
//  JWNavigationViewController.m
//  Version 0.1
//
//  Created by Jason Wong on 13-2-8.
//  Copyright (c) 2013年 iHu.im. All rights reserved.
//

#import "JWNavigationViewController.h"

#define kPushAnimationDuration  0.35
#define kOverlayViewAlpha       0.3
#define kTransformScale         0.65

typedef void (^JWTransitionBlock)(void);

@interface JWNavigationViewController () <UINavigationControllerDelegate>

@property (nonatomic, assign) CGFloat systemVersion;

@property (nonatomic, strong) NSMutableArray *peddingBlocks;

@end

@implementation JWNavigationViewController

+ (void)load {
    [super load];
    UIImage *image = [MDUtil createImageWithColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:kMDColorBaseLevel2]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:kMDColorBaseLevel2]];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:image];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [MDFont fontWithSize:17],
                                                           NSForegroundColorAttributeName: [UIColor colorWithHexString:kMDColorBaseLevel2]
                                                           }];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [MDFont fontWithSize:15],
                                                           NSForegroundColorAttributeName: [UIColor colorWithHexString:kMDColorBaseLevel2]
                                                           } forState:UIControlStateNormal];
    
    UIImage *backImage = [UIImage imageNamed:@"MDBackIndicator"];
    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
}

- (CGFloat)systemVersion {
    if (!_systemVersion) {
        _systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    
    return _systemVersion;
}

- (NSMutableArray *)peddingBlocks {
    if (!_peddingBlocks) {
        _peddingBlocks = @[].mutableCopy;
    }
    
    return _peddingBlocks;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithHexString:kMDColorBaseLevel6];
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.systemVersion >= 8.0) {
       [super pushViewController:viewController animated:animated];
    }
    
    else if (!self.isTransitionInProgress) {
        self.isTransitionInProgress = YES;
        [super pushViewController:viewController animated:animated];
    } else {
        [self addTransitionBlock:^{
            [super pushViewController:viewController animated:animated];
        }];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedViewController = nil;
    if (_systemVersion >= 8.0) {
        poppedViewController = [super popViewControllerAnimated:animated];
    }
    else {
        typeof(self) __weak weakSelf = self;
        [self addTransitionBlock:^{
            UIViewController *viewController = [super popViewControllerAnimated:animated];
            if (viewController == nil) {
                weakSelf.isTransitionInProgress = NO;
            }
        }];
    }
    return poppedViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *poppedViewControllers = nil;
    if (_systemVersion >= 8.0) {
        poppedViewControllers = [super popToViewController:viewController animated:animated];
    }
    else {
        typeof(self) __weak weakSelf = self;
        [self addTransitionBlock:^{
            if ([weakSelf.viewControllers containsObject:viewController]) {
                NSArray *viewControllers = [super popToViewController:viewController animated:animated];
                if (viewControllers.count == 0) {
                    weakSelf.isTransitionInProgress = NO;
                }
            }
            else {
                weakSelf.isTransitionInProgress = NO;
            }
        }];
    }
    return poppedViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *poppedViewControllers = nil;
    if (_systemVersion >= 8.0) {
        poppedViewControllers = [super popToRootViewControllerAnimated:animated];
    }
    else {
        typeof(self) __weak weakSelf = self;
        [self addTransitionBlock:^{
            NSArray *viewControllers = [super popToRootViewControllerAnimated:animated];
            if (viewControllers.count == 0) {
                weakSelf.isTransitionInProgress = NO;
            }
        }];
    }
    return poppedViewControllers;
}


#pragma mark - Transition Manager

- (void)addTransitionBlock:(void (^)(void))block {
    if (![self isTransitionInProgress]) {
        self.isTransitionInProgress = YES;
        block();
    }
    else {
        [self.peddingBlocks addObject:[block copy]];
    }
}

- (void)setIsTransitionInProgress:(BOOL)isTransitionInProgress {
    _isTransitionInProgress = isTransitionInProgress;
    if (!isTransitionInProgress && _peddingBlocks.count > 0) {
        _isTransitionInProgress = YES;
        [self runNextTransition];
    }
}

- (void)runNextTransition {
    JWTransitionBlock block = _peddingBlocks.firstObject;
    [_peddingBlocks removeObject:block];
    block();
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.isTransitionInProgress = NO;
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}




@end
