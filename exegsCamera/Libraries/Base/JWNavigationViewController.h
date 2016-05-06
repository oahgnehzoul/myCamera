//
//  JWNavigationViewController.h
//  Version 0.1
//
//  Created by Jason Wong on 13-2-8.
//  Copyright (c) 2013年 iHu.im. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.

#import <UIKit/UIKit.h>
#import "CRNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface JWNavigationViewController : UINavigationController

@property (nonatomic, assign) BOOL isTransitionInProgress;

@end
