//
//  MDNavigator.h
//  MeiMeiDa
//
//  Created by Jason Wong on 15/4/25.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDNavigator : NSObject

/**
 *  已定义的map列表
 */
@property (nonatomic, strong) NSMutableArray *maps;

+ (instancetype)sharedInstance;

+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate;

+ (void)open:(NSString *)url animated:(BOOL)animated;

+ (void)closeOneAndOpen:(NSString *)url animated:(BOOL)animated;

+ (void)closeSomeAndOpen:(NSInteger)count andOpen:(NSString *)url animated:(BOOL)animated;

+ (void)closeAllAndOpen:(NSString *)url animated:(BOOL)animated;

+ (void)popSomeViewControllers:(NSInteger)count;

+ (void)openViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

+ (void)popViewControllerAnimated:(BOOL)animated;

+ (UINavigationController *)navigationController;

+ (UIViewController *)currentViewController;

+ (void)popToRoot;

@end
