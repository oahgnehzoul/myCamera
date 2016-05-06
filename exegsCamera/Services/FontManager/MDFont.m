//
//  MDFont.m
//  MeiMeiDa
//
//  Created by Jason Wong on 15/8/31.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import "MDFont.h"
#import "ETConverter.h"
#import <CoreText/CoreText.h>

#define GET_RESOURCE_BUNDLE         [[NSBundle mainBundle] pathForResource:@"fonts" ofType:@"bundle"]
#define kFontFileName               @"HYQiH18030F50"

@interface MDFont ()

@end

@implementation MDFont

+ (instancetype)sharedInstance {
    static MDFont *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    MDFont *font = [MDFont sharedInstance];
    if (font.fontName) {
        return [UIFont fontWithName:font.fontName size:size];
    }
    
    if ([font isInstalled] && font.fontName) {
        return [UIFont fontWithName:font.fontName size:size];
    }
    
    if (!font.isConverted) {
//        md_dispatch_async_on_global_thread(^{
//            // 转换字体
//            [font convert];
//        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [font convert];
        });
    }
    
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];
}

+ (UIFont *)iconfontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"iconfont" size:size];
}

- (id)init {
    if (self = [super init]) {
        [self createFontConvertDstDir];
    }
    
    return self;
}

- (BOOL)isInstalled {
    NSString *ttfPath = [self getTTFFolderPath];
    BOOL        isDir = YES;
    NSString *ttfFile = [ttfPath stringByAppendingPathComponent:[kFontFileName stringByAppendingPathExtension:@"ttf"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:ttfFile isDirectory:&isDir]) {
        // 找到了转换过的字库文件
        NSString *bundle  = GET_RESOURCE_BUNDLE;
        NSString *ftfFile = [bundle stringByAppendingPathComponent:[kFontFileName stringByAppendingPathExtension:@"ttf"]];
        if ([self checkTTFValid:ttfFile ftfFile:ftfFile]) {
            [self useFontFile:ttfFile];
        }
        
        _isConverted = YES;
        _isConverting = NO;
        return YES;
    }
    
    return NO;
}

- (void)convert {
    // 正在转换或已经转换了，不处理
    if (_isConverting || _isConverted) {
        return;
    }
    _isConverting = YES;
   
    // 如果不存在，进行转换
    [self _convert:kFontFileName];
}

- (void)_convert:(NSString *)fontFileName {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *ttfPath = [weakSelf getTTFFolderPath];
        NSString *bundle  = GET_RESOURCE_BUNDLE;
        NSString *ftfFile = [bundle stringByAppendingPathComponent:[fontFileName stringByAppendingPathExtension:@"ttf"]];;
        NSString *ttfFile = [ttfPath stringByAppendingPathComponent:[fontFileName stringByAppendingPathExtension:@"ttf"]];
        
        // 验证并转换文件
        if (![weakSelf converting:ttfFile ftfFile:ftfFile]) {
            _isConverting = NO;
            _isConverted = NO;
            return;
        }
        
        // 验证文件是否合法
        if (![weakSelf checkTTFValid:ttfFile ftfFile:ftfFile]) {
            [[NSFileManager defaultManager] removeItemAtPath:ttfFile error:nil];
            _isConverting = NO;
            _isConverted = NO;
            return;
        }
        
        
        [weakSelf useFontFile:ttfFile];
        _isConverted = YES;
        _isConverting = NO;
    });
}

- (BOOL)converting:(NSString*)ttfFile ftfFile:(NSString*)ftfFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if( ![fileManager fileExistsAtPath:ftfFile isDirectory:nil] )
    {
        return FALSE;
    }
    
    BOOL isDir = YES;
    if( [fileManager fileExistsAtPath:ttfFile isDirectory:&isDir] )
    {
        if( isDir )
            return NO;
        else
            [fileManager removeItemAtPath:ttfFile error:nil];
    }
    
    // 字库文件转换，一般情况下，flags设置为 ET_CONVERTER_LOAD_FTF_FROM_MEMORY_FLAG
    BOOL        ret = [ETConverter ttfFromFTF:ftfFile ttfFile:ttfFile specifiedUnicodes:nil flags:ET_CONVERTER_LOAD_FTF_FROM_MEMORY_FLAG];
    return ret;
}

- (NSString *)getTTFFolderPath {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fontsDirPath = [documentDir stringByAppendingPathComponent:@"fonts"] ;
    return fontsDirPath;
}

- (void)createFontConvertDstDir {
    NSString *fontsDirPath = [self getTTFFolderPath];
    BOOL       isDirecotry = YES;
    BOOL   shouldCreateDir = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fontsDirPath isDirectory:&isDirecotry]) {
        if (!isDirecotry) {
            [[NSFileManager defaultManager] removeItemAtPath:fontsDirPath error:nil];
        }
        else {
            shouldCreateDir = NO;
        }
    }
    
    if (shouldCreateDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fontsDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    /* 设置字体转换目录不自动同步到iCloud，防止app store审核不通过 */
    NSURL     *URL = [NSURL fileURLWithPath:fontsDirPath];
    NSError *error = nil;
    BOOL   success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                    forKey: NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
}

- (BOOL)checkTTFValid:(NSString *)ttfFile ftfFile:(NSString *)ftfFile {
    BOOL check = YES;
    
#ifdef NORMAL_CHECK
    NSString *checkString = @"的一是在不了有和人这中大为上个国";
    
    // 一般情况下，flags设置为 ET_CONVERTER_CHECK_OUTLINE_FLAG
    check = [ETConverter checkTTF:ttfFile
                          withFTF:ftfFile
                        withChars:checkString
                            flags:ET_CONVERTER_CHECK_OUTLINE_FLAG];
#endif
    
    return check;
}

- (void)useFontFile:(NSString *)ttfFile {
    if (![self installFont:ttfFile]) {
        self.fontName = nil;
        return;
    }
    
    NSString *fontName = [self getFontName:ttfFile];
    self.fontName = fontName;
}

- (NSString *)getFontName:(NSString *)fontFilePath {
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontFilePath UTF8String]);
    CGFontRef               customFont = CGFontCreateWithDataProvider(fontDataProvider);
    NSString*                 fontName = (NSString *)CFBridgingRelease(CGFontCopyFullName(customFont));
    CGDataProviderRelease(fontDataProvider);
    CGFontRelease(customFont);
    
    return fontName;
}

- (BOOL)installFont:(NSString *)fontFileName {
    if (!fontFileName) return NO;
    if (fontFileName.length == 0)return NO;
    
    NSString *pathname = fontFileName;
    if (![[NSFileManager defaultManager]fileExistsAtPath:pathname]) return NO;
    CGFontRef customFont;
    @try
    {
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([pathname UTF8String]);
        customFont = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        CTFontManagerRegisterGraphicsFont( customFont, nil );
        CGFontRelease(customFont);
    }
    @catch (NSException* e)
    {
        CGFontRelease(customFont);
        [[NSFileManager defaultManager]removeItemAtPath:pathname error:nil];
        return NO;
    }
    return YES;
}
@end
