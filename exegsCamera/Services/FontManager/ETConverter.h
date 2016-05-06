//
//  ETConverter.h
//  ftf2ttfDemoIOS
//
//  Created by Leng Huaijing on 13-12-18.
//  Copyright (c) 2013年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ftf_converter.h"

#define  CMZ_TTF_MD5   @"60a607a24f1b074f340adfb103f2f261"
#define  KT_TTF_MD5    @"eef7bc39d2a84194f05c675dd71a84c3"
#define  YY_TTF_MD5    @"d828c8cc723cb4068b3576d929b68140"

@interface ETConverter : NSObject


+ (BOOL) ttfFromFTF:(NSString *)ftfFile
            ttfFile:(NSString *)ttfFile
  specifiedUnicodes:(NSString *)unicodes
              flags:(int)flags;


+ (BOOL) checkTTF:(NSString *)ttfFile
          withFTF:(NSString *)ftfFile
        withChars:(NSString *)text
            flags:(int)flags;


+(NSString *) getMD5WithFilePath : (NSString *)filePath;

@end
