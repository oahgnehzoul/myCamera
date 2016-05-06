//
//  ETConverter.m
//  ftf2ttfDemoIOS
//
//  Created by Leng Huaijing on 13-12-18.
//  Copyright (c) 2013年 Henry. All rights reserved.
//

#include <stdint.h>
#include <stdio.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "ETConverter.h"
#import "etrump/ftf_converter.h"



#define MD5DEFAULTBULKSIZE 8192


@implementation ETConverter

+ (BOOL) ttfFromFTF:(NSString *)ftfFile
            ttfFile:(NSString *)ttfFile
  specifiedUnicodes:(NSString *)text
              flags:(int)flags
{
    if( ttfFile == nil || ftfFile == nil )
        return FALSE;

    const char * ftf_c_path = [ftfFile UTF8String];
    const char * ttf_c_path = [ttfFile UTF8String];
        
    int len = (int)[text length];
    unsigned short* ucs = NULL;
    if( len > 0 )
    {
        ucs = calloc( len, sizeof(unsigned short) );
        if( ucs )
            for( int i = 0; i < len; i++ )
                ucs[i]  = [text characterAtIndex:i];
    }

    int error = ET_Converter_FTF_To_TTF( ftf_c_path, ttf_c_path, ucs, len, flags );

    if( ucs ) free( ucs );
    
    return ( error ? FALSE : TRUE );
}


+ (BOOL) checkTTF:(NSString *)ttfFile
          withFTF:(NSString *)ftfFile
        withChars:(NSString *)text
            flags:(int)flags
{
    if (ttfFile == nil || ftfFile == nil)
        return FALSE;

    const char * ftf_c_path = [ftfFile UTF8String];
    const char * ttf_c_path = [ttfFile UTF8String];

    unsigned short* ucs = NULL;
    int len = (int)[text length];
    if (len > 0) {
        ucs = calloc(len, sizeof(unsigned short));
        if (ucs) {
            for (int i = 0; i < len; i++)
                ucs[i] = [text characterAtIndex:i];
        }
    }
    
    int error = ET_Converter_Check_TTF_With_FTF( ftf_c_path, ttf_c_path, ucs, len, flags );
    
    if (ucs) free(ucs);
    
    return (error ? FALSE : TRUE);
}

#pragma mark MD5
CFStringRef getFileMD5(CFStringRef filePath, size_t chunkSizeForReadingData)
{
    CFReadStreamRef fileStream = NULL;
    CFStringRef         result = NULL;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                 (CFStringRef)filePath,
                                                 kCFURLPOSIXPathStyle,
                                                 (Boolean)false);
    
    if (!url)
        goto exit;
    
    fileStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, (CFURLRef)url);
    
    if (!fileStream)
        goto exit;
    
    bool bSuccess = (bool)CFReadStreamOpen(fileStream);
    if (!bSuccess)
        goto exit;
    
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    if (!chunkSizeForReadingData)
        chunkSizeForReadingData = MD5DEFAULTBULKSIZE;
    
    bool isFinished = false;
    while ( !isFinished )
    {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(fileStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));
        
        if( -1 == readBytesCount )
            goto exit;
        
        if (readBytesCount == 0)
        {
            isFinished = true;
            break;
        }
        
        CC_MD5_Update(&hashObject, (const void *)buffer, (CC_LONG)readBytesCount);
    }
    
    bSuccess = isFinished;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    if (!bSuccess)
        goto exit;
    
    char str[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(str + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault, (const char *)str, kCFStringEncodingUTF8);
    
exit:
    if (fileStream)
    {
        CFReadStreamClose(fileStream);
        CFRelease(fileStream);
    }
    
    if (url)
    {
        CFRelease(url);
    }
    
    return result;
}


+(NSString *) getMD5WithFilePath : (NSString *)filePath
{
    return (__bridge_transfer NSString *)getFileMD5((__bridge CFStringRef)filePath, MD5DEFAULTBULKSIZE);
}

@end
