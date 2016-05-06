//
//  MDFont.h
//  MeiMeiDa
//
//  Created by Jason Wong on 15/8/31.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDFont : NSObject

/**
 *  字体已经转换
 */
@property (nonatomic, assign, readonly) BOOL isConverted;

/**
 *  正在转换
 */
@property (nonatomic, assign, readonly) BOOL isConverting;

/**
 *  安装后的字体名字
 */
@property (nonatomic, strong) NSString *fontName;

+ (instancetype)sharedInstance;

+ (UIFont *)fontWithSize:(CGFloat)size;

+ (UIFont *)boldSystemFontOfSize:(CGFloat)size;

+ (UIFont *)iconfontWithSize:(CGFloat)size;

// 是否已经安装
- (BOOL)isInstalled;

- (void)convert;

@end
