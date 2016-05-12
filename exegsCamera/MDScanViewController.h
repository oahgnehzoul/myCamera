//
//  MDScannerViewController.h
//  MeiMeiDa
//
//  Created by Yulin Ding on 9/7/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

//#import "MDViewController.h"
#import <UIKit/UIKit.h>

@class MDScanViewController;

@protocol MDScanViewControllerDelegate <NSObject>

- (void)scanViewController:(MDScanViewController *)viewController barcode:(NSString *)code;

@end

@interface MDScanViewController : UIViewController

@property (nonatomic, weak) id<MDScanViewControllerDelegate> scanDelegate;

- (instancetype)initWithDeliveryCode;

@end
