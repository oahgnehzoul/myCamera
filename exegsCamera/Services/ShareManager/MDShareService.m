//
//  MDShareService.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/9.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "MDShareService.h"

@implementation MDShareService

+ (instancetype)shareInstance {
    static MDShareService *shareInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });

    return shareInstance;
}

- (void)setup {
    [UMSocialData setAppKey:kMDUMengAppKey];
}

@end
